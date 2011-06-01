Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53175 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161376Ab1FAJ0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 05:26:31 -0400
Received: by wwa36 with SMTP id 36so5813678wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Jun 2011 02:26:30 -0700 (PDT)
From: Javier Lopez <jlopex@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, j@w1.fi, javier@cozybit.com,
	johannes@sipsolutions.net, Javier Lopez <jlopex@gmail.com>
Subject: [PATCH v8] mac80211_hwsim driver support userspace frame tx/rx
Date: Wed,  1 Jun 2011 11:26:13 +0200
Message-Id: <1306920373-5281-1-git-send-email-jlopex@gmail.com> (sfid-20110601_112645_864968_08CD0038)
In-Reply-To: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds to mac80211_hwsim the capability to send traffic via 
userspace.

Frame exchange between kernel and user spaces is done through generic 
netlink communication protocol. A new generic netlink family 
MAC80211_HWSIM is proposed, this family contains three basic commands 
HWSIM_CMD_REGISTER, which is the command used to register a new 
traffic listener, HWSIM_CMD_FRAME, to exchange the frames from kernel 
to user and vice-versa, and HWSIM_CMD_TX_INFO_FRAME which returns 
from user all the information about retransmissions, rates, rx signal, 
and so on.

How it works:

Once the driver is loaded the MAC80211_HWSIM family will be registered.
In the absence of userspace daemon, the driver itselfs implements a 
perfect wireless medium as it did in the past. When a daemon sends a 
HWSIM_CMD_REGISTER command, the module stores the application PID, and 
from this moment all frames will be sent to the registered daemon.

The user space application will be in charge of process/forward all 
frames broadcast by any mac80211_hwsim radio. If the user application 
is stopped, the kernel module will detect the release of the socket 
and it will switch back to in-kernel perfect channel simulation.

The userspace daemon must be waiting for incoming HWSIM_CMD_FRAME 
commands sent from kernel, for each HWSIM_CMD_FRAME command the 
application will try to broadcast this frame to all mac80211_hwsim 
radios, however the application may decide to forward/drop this frame. 
In the case of forwarding the frame, a new HWSIM_CMD_FRAME command will
be created, all necessary attributes will be populated and the frame
will be sent back to the kernel.

Also after the frame broadcast phase, a HWSIM_CMD_TX_INFO_FRAME 
command will be sent from userspace to kernel, this command contains 
all the information regarding the transmission, such as number of 
tries, rates, ack signal, etc.

You can find the actual implementation of wireless mediumd daemon 
(wmediumd) at:

* Last version tarball: https://github.com/jlopex/cozybit/tarball/master
* Or visiting my github tree: https://github.com/jlopex/cozybit/tree

Signed-off-by: Javier Lopez <jlopex@gmail.com>
---
Thanks to Johaness Berg, Javier Cardona and John Linville for their 
effort, reviews and patience with me.

Changelog:

v1: Initial version
v2: Fixed memory check issues, added netlink attributes checks, erased
    extra printks
v3: Changed HWSIM generic netlink to MAC80211_HWSIM generic netlink family,
    solved a lock issue
v4: Added netlink notifier in order to detect user space socket release, 
    more accurate memory allocation, added skb_queue per radio to hold last 
    exchanged frames with userspace
v5: Avoided the use of ieee80211 data structures, changed the cookie netlink 
    attribute to U64, solved memory leak in no-wmediumd mode, erased extra 
    debug messages, added netlink attributes check per each command, nla_len 
    for all data structures sent over netlink, solved a bug with interfaces
    not completely configured
v6: Added patch description and changelog
v7: Solved double free / memory leak, moved policy to .c file, changed 
    mistaken returns, now superuser permit is required to use this API
v8: Removed unused include clause from mac80211_hwsim.h

 drivers/net/wireless/mac80211_hwsim.c |  462 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  133 ++++++++++
 2 files changed, 580 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211_hwsim.h

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 9d4a40e..7e1fa96 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1,6 +1,7 @@
 /*
  * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
  * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
+ * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -25,11 +26,17 @@
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
+#include <net/genetlink.h>
+#include "mac80211_hwsim.h"
+
+#define WARN_QUEUE 100
+#define MAX_QUEUE 200
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
 MODULE_LICENSE("GPL");
 
+int wmediumd_pid;
 static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
@@ -302,6 +309,7 @@ struct mac80211_hwsim_data {
 	struct dentry *debugfs;
 	struct dentry *debugfs_ps;
 
+	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
 	 * channel has to match too). Each bit represents a group. A
@@ -322,6 +330,32 @@ struct hwsim_radiotap_hdr {
 	__le16 rt_chbitmask;
 } __packed;
 
+/* MAC80211_HWSIM netlinf family */
+static struct genl_family hwsim_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "MAC80211_HWSIM",
+	.version = 1,
+	.maxattr = HWSIM_ATTR_MAX,
+};
+
+/* MAC80211_HWSIM netlink policy */
+
+static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
+	[HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC,
+				       .len = 6*sizeof(u8) },
+	[HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC,
+					  .len = 6*sizeof(u8) },
+	[HWSIM_ATTR_FRAME] = { .type = NLA_BINARY,
+			       .len = IEEE80211_MAX_DATA_LEN },
+	[HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
+	[HWSIM_ATTR_RX_RATE] = { .type = NLA_U32 },
+	[HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
+	[HWSIM_ATTR_TX_INFO] = { .type = NLA_UNSPEC,
+				 .len = IEEE80211_TX_MAX_RATES*sizeof(
+					struct hwsim_tx_rate)},
+	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
+};
 
 static netdev_tx_t hwsim_mon_xmit(struct sk_buff *skb,
 					struct net_device *dev)
@@ -478,9 +512,89 @@ static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
 	return md.ret;
 }
 
+static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
+				       struct sk_buff *my_skb,
+				       int dst_pid)
+{
+	struct sk_buff *skb;
+	struct mac80211_hwsim_data *data = hw->priv;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) my_skb->data;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(my_skb);
+	void *msg_head;
+	unsigned int hwsim_flags = 0;
+	int i;
+	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
+
+	if (data->idle) {
+		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
+		dev_kfree_skb(my_skb);
+		return;
+	}
+
+	if (data->ps != PS_DISABLED)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+	/* If the queue contains MAX_QUEUE skb's drop some */
+	if (skb_queue_len(&data->pending) >= MAX_QUEUE) {
+		/* Droping until WARN_QUEUE level */
+		while (skb_queue_len(&data->pending) >= WARN_QUEUE)
+			skb_dequeue(&data->pending);
+	}
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (skb == NULL)
+		goto nla_put_failure;
+
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			       HWSIM_CMD_FRAME);
+	if (msg_head == NULL) {
+		printk(KERN_DEBUG "mac80211_hwsim: problem with msg_head\n");
+		goto nla_put_failure;
+	}
+
+	NLA_PUT(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		     sizeof(struct mac_address), data->addresses[1].addr);
 
-static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
-				    struct sk_buff *skb)
+	/* We get the skb->data */
+	NLA_PUT(skb, HWSIM_ATTR_FRAME, my_skb->len, my_skb->data);
+
+	/* We get the flags for this transmission, and we translate them to
+	   wmediumd flags  */
+
+	if (info->flags & IEEE80211_TX_CTL_REQ_TX_STATUS)
+		hwsim_flags |= HWSIM_TX_CTL_REQ_TX_STATUS;
+
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
+		hwsim_flags |= HWSIM_TX_CTL_NO_ACK;
+
+	NLA_PUT_U32(skb, HWSIM_ATTR_FLAGS, hwsim_flags);
+
+	/* We get the tx control (rate and retries) info*/
+
+	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		tx_attempts[i].idx = info->status.rates[i].idx;
+		tx_attempts[i].count = info->status.rates[i].count;
+	}
+
+	NLA_PUT(skb, HWSIM_ATTR_TX_INFO,
+		     sizeof(struct hwsim_tx_rate)*IEEE80211_TX_MAX_RATES,
+		     tx_attempts);
+
+	/* We create a cookie to identify this skb */
+	NLA_PUT_U64(skb, HWSIM_ATTR_COOKIE, (unsigned long) my_skb);
+
+	genlmsg_end(skb, msg_head);
+	genlmsg_unicast(&init_net, skb, dst_pid);
+
+	/* Enqueue the packet */
+	skb_queue_tail(&data->pending, my_skb);
+	return;
+
+nla_put_failure:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+}
+
+static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
+					  struct sk_buff *skb)
 {
 	struct mac80211_hwsim_data *data = hw->priv, *data2;
 	bool ack = false;
@@ -540,11 +654,11 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	return ack;
 }
 
-
 static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	bool ack;
 	struct ieee80211_tx_info *txi;
+	int _pid;
 
 	mac80211_hwsim_monitor_rx(hw, skb);
 
@@ -554,7 +668,15 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
-	ack = mac80211_hwsim_tx_frame(hw, skb);
+	/* wmediumd mode check */
+	_pid = wmediumd_pid;
+
+	if (_pid)
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
+
+	/* NO wmediumd detected, perfect medium simulation */
+	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb);
+
 	if (ack && skb->len >= 16) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 		mac80211_hwsim_monitor_ack(hw, hdr->addr2);
@@ -635,6 +757,7 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	struct ieee80211_hw *hw = arg;
 	struct sk_buff *skb;
 	struct ieee80211_tx_info *info;
+	int _pid;
 
 	hwsim_check_magic(vif);
 
@@ -649,7 +772,14 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	info = IEEE80211_SKB_CB(skb);
 
 	mac80211_hwsim_monitor_rx(hw, skb);
-	mac80211_hwsim_tx_frame(hw, skb);
+
+	/* wmediumd mode check */
+	_pid = wmediumd_pid;
+
+	if (_pid)
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
+
+	mac80211_hwsim_tx_frame_no_nl(hw, skb);
 	dev_kfree_skb(skb);
 }
 
@@ -966,12 +1096,7 @@ static int mac80211_hwsim_ampdu_action(struct ieee80211_hw *hw,
 
 static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
 {
-	/*
-	 * In this special case, there's nothing we need to
-	 * do because hwsim does transmission synchronously.
-	 * In the future, when it does transmissions via
-	 * userspace, we may need to do something.
-	 */
+	/* Not implemented, queues only on kernel side */
 }
 
 struct hw_scan_done {
@@ -1119,6 +1244,7 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_pspoll *pspoll;
+	int _pid;
 
 	if (!vp->assoc)
 		return;
@@ -1137,8 +1263,15 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	pspoll->aid = cpu_to_le16(0xc000 | vp->aid);
 	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, mac, ETH_ALEN);
-	if (!mac80211_hwsim_tx_frame(data->hw, skb))
-		printk(KERN_DEBUG "%s: PS-Poll frame not ack'ed\n", __func__);
+
+	/* wmediumd mode check */
+	_pid = wmediumd_pid;
+
+	if (_pid)
+		return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
+
+	if (!mac80211_hwsim_tx_frame_no_nl(data->hw, skb))
+		printk(KERN_DEBUG "%s: PS-poll frame not ack'ed\n", __func__);
 	dev_kfree_skb(skb);
 }
 
@@ -1149,6 +1282,7 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
+	int _pid;
 
 	if (!vp->assoc)
 		return;
@@ -1168,7 +1302,14 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr1, vp->bssid, ETH_ALEN);
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
-	if (!mac80211_hwsim_tx_frame(data->hw, skb))
+
+	/* wmediumd mode check */
+	_pid = wmediumd_pid;
+
+	if (_pid)
+		return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
+
+	if (!mac80211_hwsim_tx_frame_no_nl(data->hw, skb))
 		printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
 	dev_kfree_skb(skb);
 }
@@ -1248,6 +1389,273 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
 
+struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
+			     struct mac_address *addr)
+{
+	struct mac80211_hwsim_data *data;
+	bool _found = false;
+
+	spin_lock_bh(&hwsim_radio_lock);
+	list_for_each_entry(data, &hwsim_radios, list) {
+		if (memcmp(data->addresses[1].addr, addr,
+			  sizeof(struct mac_address)) == 0) {
+			_found = true;
+			break;
+		}
+	}
+	spin_unlock_bh(&hwsim_radio_lock);
+
+	if (!_found)
+		return NULL;
+
+	return data;
+}
+
+static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
+					   struct genl_info *info)
+{
+
+	struct ieee80211_hdr *hdr;
+	struct mac80211_hwsim_data *data2;
+	struct ieee80211_tx_info *txi;
+	struct hwsim_tx_rate *tx_attempts;
+	struct sk_buff __user *ret_skb;
+	struct sk_buff *skb, *tmp;
+	struct mac_address *src;
+	unsigned int hwsim_flags;
+
+	int i;
+	bool found = false;
+
+	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
+	   !info->attrs[HWSIM_ATTR_FLAGS] ||
+	   !info->attrs[HWSIM_ATTR_COOKIE] ||
+	   !info->attrs[HWSIM_ATTR_TX_INFO])
+		goto out;
+
+	src = (struct mac_address *)nla_data(
+				   info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+	hwsim_flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
+
+	ret_skb = (struct sk_buff __user *)
+		  (unsigned long) nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+
+	data2 = get_hwsim_data_ref_from_addr(src);
+
+	if (data2 == NULL)
+		goto out;
+
+	/* look for the skb matching the cookie passed back from user */
+	skb_queue_walk_safe(&data2->pending, skb, tmp) {
+		if (skb == ret_skb) {
+			skb_unlink(skb, &data2->pending);
+			found = true;
+			break;
+		}
+	}
+
+	/* not found */
+	if (!found)
+		goto out;
+
+	/* Tx info received because the frame was broadcasted on user space,
+	 so we get all the necessary info: tx attempts and skb control buff */
+
+	tx_attempts = (struct hwsim_tx_rate *)nla_data(
+		       info->attrs[HWSIM_ATTR_TX_INFO]);
+
+	/* now send back TX status */
+	txi = IEEE80211_SKB_CB(skb);
+
+	if (txi->control.vif)
+		hwsim_check_magic(txi->control.vif);
+	if (txi->control.sta)
+		hwsim_check_sta_magic(txi->control.sta);
+
+	ieee80211_tx_info_clear_status(txi);
+
+	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		txi->status.rates[i].idx = tx_attempts[i].idx;
+		txi->status.rates[i].count = tx_attempts[i].count;
+		/*txi->status.rates[i].flags = 0;*/
+	}
+
+	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+
+	if (!(hwsim_flags & HWSIM_TX_CTL_NO_ACK) &&
+	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
+		if (skb->len >= 16) {
+			hdr = (struct ieee80211_hdr *) skb->data;
+			mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
+		}
+	}
+	ieee80211_tx_status_irqsafe(data2->hw, skb);
+	return 0;
+out:
+	return -EINVAL;
+
+}
+
+static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
+					  struct genl_info *info)
+{
+
+	struct mac80211_hwsim_data  *data2;
+	struct ieee80211_rx_status rx_status;
+	struct mac_address *dst;
+	int frame_data_len;
+	char *frame_data;
+	struct sk_buff *skb = NULL;
+
+	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
+	   !info->attrs[HWSIM_ATTR_FRAME] ||
+	   !info->attrs[HWSIM_ATTR_RX_RATE] ||
+	   !info->attrs[HWSIM_ATTR_SIGNAL])
+		goto out;
+
+	dst = (struct mac_address *)nla_data(
+				   info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
+
+	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
+	frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
+
+	/* Allocate new skb here */
+	skb = alloc_skb(frame_data_len, GFP_KERNEL);
+	if (skb == NULL)
+		goto err;
+
+	if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {
+		/* Copy the data */
+		memcpy(skb_put(skb, frame_data_len), frame_data,
+		       frame_data_len);
+	} else
+		goto err;
+
+	data2 = get_hwsim_data_ref_from_addr(dst);
+
+	if (data2 == NULL)
+		goto out;
+
+	/* check if radio is configured properly */
+
+	if (data2->idle || !data2->started || !data2->channel)
+		goto out;
+
+	/*A frame is received from user space*/
+	memset(&rx_status, 0, sizeof(rx_status));
+	rx_status.freq = data2->channel->center_freq;
+	rx_status.band = data2->channel->band;
+	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(data2->hw, skb);
+
+	return 0;
+err:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	goto out;
+out:
+	dev_kfree_skb(skb);
+	return -EINVAL;
+}
+
+static int hwsim_register_received_nl(struct sk_buff *skb_2,
+				      struct genl_info *info)
+{
+	if (info == NULL)
+		goto out;
+
+	wmediumd_pid = info->snd_pid;
+
+	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
+	"switching to wmediumd mode with pid %d\n", info->snd_pid);
+
+	return 0;
+out:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -EINVAL;
+}
+
+/* Generic Netlink operations array */
+static struct genl_ops hwsim_ops[] = {
+	{
+		.cmd = HWSIM_CMD_REGISTER,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_register_received_nl,
+		.flags = GENL_ADMIN_PERM,
+	},
+	{
+		.cmd = HWSIM_CMD_FRAME,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_cloned_frame_received_nl,
+	},
+	{
+		.cmd = HWSIM_CMD_TX_INFO_FRAME,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_tx_info_frame_received_nl,
+	},
+};
+
+static int mac80211_hwsim_netlink_notify(struct notifier_block *nb,
+					 unsigned long state,
+					 void *_notify)
+{
+	struct netlink_notify *notify = _notify;
+
+	if (state != NETLINK_URELEASE)
+		return NOTIFY_DONE;
+
+	if (notify->pid == wmediumd_pid) {
+		printk(KERN_INFO "mac80211_hwsim: wmediumd released netlink"
+		       " socket, switching to perfect channel medium\n");
+		wmediumd_pid = 0;
+	}
+	return NOTIFY_DONE;
+
+}
+
+static struct notifier_block hwsim_netlink_notifier = {
+	.notifier_call = mac80211_hwsim_netlink_notify,
+};
+
+static int hwsim_init_netlink(void)
+{
+	int rc;
+	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
+
+	wmediumd_pid = 0;
+
+	rc = genl_register_family_with_ops(&hwsim_genl_family,
+		hwsim_ops, ARRAY_SIZE(hwsim_ops));
+	if (rc)
+		goto failure;
+
+	rc = netlink_register_notifier(&hwsim_netlink_notifier);
+	if (rc)
+		goto failure;
+
+	return 0;
+
+failure:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -EINVAL;
+}
+
+static void hwsim_exit_netlink(void)
+{
+	int ret;
+
+	printk(KERN_INFO "mac80211_hwsim: closing netlink\n");
+	/* unregister the notifier */
+	netlink_unregister_notifier(&hwsim_netlink_notifier);
+	/* unregister the family */
+	ret = genl_unregister_family(&hwsim_genl_family);
+	if (ret)
+		printk(KERN_DEBUG "mac80211_hwsim: "
+		       "unregister family %i\n", ret);
+}
+
 static int __init init_mac80211_hwsim(void)
 {
 	int i, err = 0;
@@ -1298,6 +1706,7 @@ static int __init init_mac80211_hwsim(void)
 			goto failed_drvdata;
 		}
 		data->dev->driver = &mac80211_hwsim_driver;
+		skb_queue_head_init(&data->pending);
 
 		SET_IEEE80211_DEV(hw, data->dev);
 		addr[3] = i >> 8;
@@ -1379,6 +1788,10 @@ static int __init init_mac80211_hwsim(void)
 		data->group = 1;
 		mutex_init(&data->mutex);
 
+		/* Enable frame retransmissions for lossy channels */
+		hw->max_rates = 4;
+		hw->max_rate_tries = 11;
+
 		/* Work to be done prior to ieee80211_register_hw() */
 		switch (regtest) {
 		case HWSIM_REGTEST_DISABLED:
@@ -1515,12 +1928,29 @@ static int __init init_mac80211_hwsim(void)
 	if (hwsim_mon == NULL)
 		goto failed;
 
-	err = register_netdev(hwsim_mon);
+	rtnl_lock();
+
+	err = dev_alloc_name(hwsim_mon, hwsim_mon->name);
 	if (err < 0)
 		goto failed_mon;
 
+
+	err = register_netdevice(hwsim_mon);
+	if (err < 0)
+		goto failed_mon;
+
+	rtnl_unlock();
+
+	err = hwsim_init_netlink();
+	if (err < 0)
+		goto failed_nl;
+
 	return 0;
 
+failed_nl:
+	printk(KERN_DEBUG "mac_80211_hwsim: failed initializing netlink\n");
+	return err;
+
 failed_mon:
 	rtnl_unlock();
 	free_netdev(hwsim_mon);
@@ -1541,6 +1971,8 @@ static void __exit exit_mac80211_hwsim(void)
 {
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
+	hwsim_exit_netlink();
+
 	mac80211_hwsim_free();
 	unregister_netdev(hwsim_mon);
 }
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
new file mode 100644
index 0000000..afaad5a
--- /dev/null
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -0,0 +1,133 @@
+/*
+ * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
+ * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
+ * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __MAC80211_HWSIM_H
+#define __MAC80211_HWSIM_H
+
+/**
+ * enum hwsim_tx_control_flags - flags to describe transmission info/status
+ *
+ * These flags are used to give the wmediumd extra information in order to
+ * modify its behavior for each frame
+ *
+ * @HWSIM_TX_CTL_REQ_TX_STATUS: require TX status callback for this frame.
+ * @HWSIM_TX_CTL_NO_ACK: tell the wmediumd not to wait for an ack
+ * @HWSIM_TX_STAT_ACK: Frame was acknowledged
+ *
+ */
+enum hwsim_tx_control_flags {
+	HWSIM_TX_CTL_REQ_TX_STATUS		= BIT(0),
+	HWSIM_TX_CTL_NO_ACK			= BIT(1),
+	HWSIM_TX_STAT_ACK			= BIT(2),
+};
+
+/**
+ * DOC: Frame transmission/registration support
+ *
+ * Frame transmission and registration support exists to allow userspace
+ * entities such as wmediumd to receive and process all broadcasted
+ * frames from a mac80211_hwsim radio device.
+ *
+ * This allow user space applications to decide if the frame should be
+ * dropped or not and implement a wireless medium simulator at user space.
+ *
+ * Registration is done by sending a register message to the driver and
+ * will be automatically unregistered if the user application doesn't
+ * responds to sent frames.
+ * Once registered the user application has to take responsibility of
+ * broadcasting the frames to all listening mac80211_hwsim radio
+ * interfaces.
+ *
+ * For more technical details, see the corresponding command descriptions
+ * below.
+ */
+
+/**
+ * enum hwsim_commands - supported hwsim commands
+ *
+ * @HWSIM_CMD_UNSPEC: unspecified command to catch errors
+ *
+ * @HWSIM_CMD_REGISTER: request to register and received all broadcasted
+ *	frames by any mac80211_hwsim radio device.
+ * @HWSIM_CMD_FRAME: send/receive a broadcasted frame from/to kernel/user
+ * space, uses:
+ *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_ADDR_RECEIVER,
+ *	%HWSIM_ATTR_FRAME, %HWSIM_ATTR_FLAGS, %HWSIM_ATTR_RX_RATE,
+ *	%HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
+ * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
+ * kernel, uses:
+ *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_FLAGS,
+ *	%HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_COOKIE
+ * @__HWSIM_CMD_MAX: enum limit
+ */
+enum {
+	HWSIM_CMD_UNSPEC,
+	HWSIM_CMD_REGISTER,
+	HWSIM_CMD_FRAME,
+	HWSIM_CMD_TX_INFO_FRAME,
+	__HWSIM_CMD_MAX,
+};
+#define HWSIM_CMD_MAX (_HWSIM_CMD_MAX - 1)
+
+/**
+ * enum hwsim_attrs - hwsim netlink attributes
+ *
+ * @HWSIM_ATTR_UNSPEC: unspecified attribute to catch errors
+ *
+ * @HWSIM_ATTR_ADDR_RECEIVER: MAC address of the radio device that
+ *	the frame is broadcasted to
+ * @HWSIM_ATTR_ADDR_TRANSMITTER: MAC address of the radio device that
+ *	the frame was broadcasted from
+ * @HWSIM_ATTR_FRAME: Data array
+ * @HWSIM_ATTR_FLAGS: mac80211 transmission flags, used to process
+	properly the frame at user space
+ * @HWSIM_ATTR_RX_RATE: estimated rx rate index for this frame at user
+	space
+ * @HWSIM_ATTR_SIGNAL: estimated RX signal for this frame at user
+	space
+ * @HWSIM_ATTR_TX_INFO: ieee80211_tx_rate array
+ * @HWSIM_ATTR_COOKIE: sk_buff cookie to identify the frame
+ * @__HWSIM_ATTR_MAX: enum limit
+ */
+
+
+enum {
+	HWSIM_ATTR_UNSPEC,
+	HWSIM_ATTR_ADDR_RECEIVER,
+	HWSIM_ATTR_ADDR_TRANSMITTER,
+	HWSIM_ATTR_FRAME,
+	HWSIM_ATTR_FLAGS,
+	HWSIM_ATTR_RX_RATE,
+	HWSIM_ATTR_SIGNAL,
+	HWSIM_ATTR_TX_INFO,
+	HWSIM_ATTR_COOKIE,
+	__HWSIM_ATTR_MAX,
+};
+#define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
+
+/**
+ * struct hwsim_tx_rate - rate selection/status
+ *
+ * @idx: rate index to attempt to send with
+ * @count: number of tries in this rate before going to the next rate
+ *
+ * A value of -1 for @idx indicates an invalid rate and, if used
+ * in an array of retry rates, that no more rates should be tried.
+ *
+ * When used for transmit status reporting, the driver should
+ * always report the rate and number of retries used.
+ *
+ */
+struct hwsim_tx_rate {
+	s8 idx;
+	u8 count;
+} __packed;
+
+#endif /* __MAC80211_HWSIM_H */
-- 
1.7.0.4

