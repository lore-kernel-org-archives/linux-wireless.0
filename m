Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1DRUpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 16:45:33 -0400
Received: by wya21 with SMTP id 21so4281555wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 13:45:31 -0700 (PDT)
From: Javier Lopez <jlopex@gmail.com>
To: linux-wireless@vger.kernel.org, javier@cozybit.com
Cc: Javier Lopez <jlopex@gmail.com>
Subject: [PATCH] mac80211_hwsim driver support userspace frame tx/rx
Date: Mon, 18 Apr 2011 22:45:10 +0200
Message-Id: <1303159510-2548-1-git-send-email-jlopex@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the capability to hwsim to send traffic via userspace.

Frame exchange between kernel and userspace is done through a generic 
netlink communication protocol, a new family called HWSIM is proposed 
in order to communicate with userspace applications. This family 
contains three basic commands; HWSIM_CMD_REGISTER which is used to 
register a userspace application with this driver, HWSIM_CMD_FRAME to 
exchange frames from kernel to user and vice-versa, and  finally 
HWSIM_CMD_TX_INFO_FRAME which returns to the kernel all the information 
about a frame transmission over the medium, number of tries, rates, 
ack signal and so on.

How it works:

Once the driver is loaded, it registers the HWSIM generic netlink 
family. In the absence of a daemon the driver implements a perfect 
wireless medium in the kernel as it did in the past. Once a daemon a 
registers itself via HWSIM_CMD_REGISTER, the kernel module stores the 
daemon PID and from this moment all frames will be sent to the daemon. 

The userspace application will be in charge of process/forward all 
frames broadcast by any radio using the mac80211_hwsim driver. If the 
user application is stopped the module will switch back to in-kernel 
perfect channel simulation. This transmission of kernel to user space 
is done through the HWSIM_CMD_FRAME command.

The userspace application once sends the HWSIM_CMD_REGISTER, waits 
for incoming messages from kernel, for each HWSIM_CMD_FRAME command 
received, the application will try to broadcast it, cloning the frame 
to all known mac80211_hwsim radios. The daemon may decide to send or 
drop this frame. In the case of sending a frame back to kernel, the 
daemon will create a new HWSIM_CMD_FRAME command, fill the necessary 
attributes and send it back. In the case of a frame drop, the example 
userspace daemon retransmits frames according to the ieee80211_tx_info 
values received from the kernel.

After each frame complete transmission a HWSIM_CMD_TX_INFO command 
may be sent to the kernel to inform about the tx status, this command 
contains information such as number of tries, rates, ack'ed or not 
ack'ed, ack_signal, etc. 

If you want to test the actual implementation of the wireless medium 
daemon (wmediumd) and test this patch, just get it from GitHub:

- Last version tarball: https://github.com/jlopex/cozybit/tarball/master
- Or visiting my github tree: https://github.com/jlopex/cozybit/tree

Best regards,

Signed-off-by: Javier Lopez <jlopex@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  378 ++++++++++++++++++++++++++++++++-
 drivers/net/wireless/mac80211_hwsim.h |  123 +++++++++++
 2 files changed, 495 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/wireless/mac80211_hwsim.h

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index f4f4257..0be0ad7 100644
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
@@ -25,11 +26,15 @@
 #include <linux/rtnetlink.h>
 #include <linux/etherdevice.h>
 #include <linux/debugfs.h>
+#include <net/genetlink.h>
+#include "mac80211_hwsim.h"
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Software simulator of 802.11 radio(s) for mac80211");
 MODULE_LICENSE("GPL");
 
+static atomic_t wmediumd_pid;
+
 static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
@@ -479,20 +484,92 @@ static bool mac80211_hwsim_addr_match(struct mac80211_hwsim_data *data,
 }
 
 
+static int hwsim_frame_send_nl(struct mac_address *src,
+			       struct sk_buff *my_skb, int _pid)
+{
+
+	struct ieee80211_tx_info *txi;
+	struct sk_buff *skb;
+	void *msg_head;
+	int rc;
+
+	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	msg_head = genlmsg_put(skb, 0, 0, &hwsim_genl_family, 0,
+			       HWSIM_CMD_FRAME);
+	if (msg_head == NULL) {
+		printk(KERN_DEBUG "mac80211_hwsim: problem with msg_head\n");
+		goto out;
+	}
+
+	rc = nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
+		     sizeof(struct mac_address), src);
+
+	rc = nla_put_u32(skb, HWSIM_ATTR_MSG_LEN, my_skb->len);
+
+	rc = nla_put(skb, HWSIM_ATTR_MSG, my_skb->len, my_skb->data);
+	if (rc != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: "
+		       "error filling msg payload\n");
+		goto out;
+	}
+
+	/* We get a copy of the control buffer for this tx*/
+	rc = nla_put(skb, HWSIM_ATTR_CB_SKB, sizeof(my_skb->cb),
+		     my_skb->cb);
+
+	txi = IEEE80211_SKB_CB(my_skb);
+
+	/* We get the flags for this transmission, wmediumd maybe
+	   changes its behaviour depending on the flags */
+	rc = nla_put_u32(skb, HWSIM_ATTR_FLAGS, txi->flags);
+	/* We get the tx control (rate and retries) info*/
+	rc = nla_put(skb, HWSIM_ATTR_TX_INFO,
+		     sizeof(struct ieee80211_tx_rate)*IEEE80211_TX_MAX_RATES,
+		     txi->control.rates);
+
+	genlmsg_end(skb, msg_head);
+	rc = genlmsg_unicast(&init_net, skb, _pid);
+	if (rc != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: wmediumd not responding "
+		       "at PID:%d, switching to no wmediumd mode.\n", _pid);
+		atomic_set(&wmediumd_pid, 0);
+	}
+
+	return 0;
+
+out:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -1;
+}
+
 static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 				    struct sk_buff *skb)
 {
 	struct mac80211_hwsim_data *data = hw->priv, *data2;
-	bool ack = false;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_rx_status rx_status;
 
+	bool ack = false;
+
 	if (data->idle) {
 		wiphy_debug(hw->wiphy, "Trying to TX when idle - reject\n");
 		return false;
 	}
 
+	if (data->ps != PS_DISABLED)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
+
+	/* wmediumd mode */
+	if (atomic_read(&wmediumd_pid)) {
+		hwsim_frame_send_nl((struct mac_address *)
+			&data->addresses[1].addr, skb,
+			atomic_read(&wmediumd_pid));
+		return true;
+	}
+
+	/* NO wmediumd, normal mac80211_hwsim behaviour*/
+
 	memset(&rx_status, 0, sizeof(rx_status));
 	/* TODO: set mactime */
 	rx_status.freq = data->channel->center_freq;
@@ -501,9 +578,6 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	/* TODO: simulate real signal strength (and optional packet loss) */
 	rx_status.signal = data->power_level - 50;
 
-	if (data->ps != PS_DISABLED)
-		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
-
 	/* release the skb's source info */
 	skb_orphan(skb);
 	skb_dst_drop(skb);
@@ -530,9 +604,10 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 		if (nskb == NULL)
 			continue;
 
+		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
+
 		if (mac80211_hwsim_addr_match(data2, hdr->addr1))
 			ack = true;
-		memcpy(IEEE80211_SKB_RXCB(nskb), &rx_status, sizeof(rx_status));
 		ieee80211_rx_irqsafe(data2->hw, nskb);
 	}
 	spin_unlock(&hwsim_radio_lock);
@@ -540,12 +615,12 @@ static bool mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
 	return ack;
 }
 
-
 static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	bool ack;
 	struct ieee80211_tx_info *txi;
 
+
 	mac80211_hwsim_monitor_rx(hw, skb);
 
 	if (skb->len < 10) {
@@ -554,6 +629,13 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
+	/* wmediumd mode*/
+	if (atomic_read(&wmediumd_pid)) {
+		mac80211_hwsim_tx_frame(hw, skb);
+		return;
+	}
+
+	/* NO wmediumd, normal mac80211_hwsim behaviour*/
 	ack = mac80211_hwsim_tx_frame(hw, skb);
 	if (ack && skb->len >= 16) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
@@ -1244,6 +1326,276 @@ static int hwsim_fops_group_write(void *dat, u64 val)
 	return 0;
 }
 
+
+struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
+			     struct mac_address *addr)
+{
+	struct mac80211_hwsim_data *data;
+	bool _found = false;
+
+	spin_lock(&hwsim_radio_lock);
+	list_for_each_entry(data, &hwsim_radios, list) {
+		if (memcmp(data->addresses[1].addr, addr,
+			  sizeof(struct mac_address)) == 0) {
+			_found = true;
+			break;
+		}
+	}
+	spin_unlock(&hwsim_radio_lock);
+
+	if (!_found) {
+		printk(KERN_DEBUG "mac80211_hwsim: invalid radio ID\n");
+		return NULL;
+	}
+
+	return data;
+
+
+}
+
+static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
+					   struct genl_info *info)
+{
+
+	struct ieee80211_hdr *hdr;
+	struct mac80211_hwsim_data *data2;
+	struct ieee80211_tx_info *txi;
+	struct ieee80211_tx_rate *tx_attempts;
+	char *cb;
+
+	int i;
+
+	struct mac_address *dst = (struct mac_address *)nla_data(
+				   info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+	int frame_data_len = nla_get_u32(info->attrs[HWSIM_ATTR_MSG_LEN]);
+	char *frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_MSG]);
+	int flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
+
+	/* Allocate new skb here */
+	struct sk_buff *skb = alloc_skb(IEEE80211_MAX_DATA_LEN, GFP_KERNEL);
+
+	if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {
+		/* Copy the data */
+		memcpy(skb_put(skb, frame_data_len), frame_data,
+		       frame_data_len);
+	} else
+		goto out;
+
+	data2 = get_hwsim_data_ref_from_addr(dst);
+
+	if (data2 == NULL)
+		goto out;
+
+	printk(KERN_DEBUG "mac80211_hwsim: TX_INFO received\n");
+
+	/*Tx info received because the frame was acked on user space,
+	 so we get all the necessary info: tx attempts and skb control buffer*/
+
+	tx_attempts = (struct ieee80211_tx_rate *)nla_data(
+		       info->attrs[HWSIM_ATTR_TX_INFO]);
+
+	/* ieee80211_tx_status() does not dereference anything from the
+	 ieee80211_tx_info structure included in this cb, so it is safe
+	 to get whatever we get from userspace and copy it here. */
+
+	cb = (char *)nla_data(info->attrs[HWSIM_ATTR_CB_SKB]);
+	memcpy(skb->cb, cb, sizeof(skb->cb));
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
+	txi->flags = flags;
+
+	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
+		txi->status.rates[i].idx = tx_attempts[i].idx;
+		txi->status.rates[i].count = tx_attempts[i].count;
+		txi->status.rates[i].flags = tx_attempts[i].flags;
+	}
+
+	/* unknown values that must be filled in:
+		txi->status.ampdu_ack_len = ¿?¿¿?¿?¿;
+		txi->status.ampdu_ack_map = ¿?¿?;
+	*/
+
+	txi->status.ack_signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+
+	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) &&
+	   (txi->flags & IEEE80211_TX_STAT_ACK)) {
+		if (skb->len >= 16) {
+			hdr = (struct ieee80211_hdr *) skb->data;
+			mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
+		}
+	}
+	ieee80211_tx_status_irqsafe(data2->hw, skb);
+	return 0;
+
+out:
+	kfree_skb(skb);
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -1;
+
+}
+
+static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
+					  struct genl_info *info)
+{
+
+	struct mac80211_hwsim_data *data2;
+	struct ieee80211_rx_status rx_status;
+
+	struct mac_address *dst = (struct mac_address *)nla_data(
+				   info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
+
+	int frame_data_len = nla_get_u32(info->attrs[HWSIM_ATTR_MSG_LEN]);
+	char* frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_MSG]);
+
+	/* Allocate new skb here */
+	struct sk_buff *skb = alloc_skb(IEEE80211_MAX_DATA_LEN, GFP_KERNEL);
+
+	if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {
+		/* Copy the data */
+		memcpy(skb_put(skb, frame_data_len), frame_data,
+		       frame_data_len);
+	} else
+		goto out;
+
+	data2 = get_hwsim_data_ref_from_addr(dst);
+
+	if (data2 == NULL)
+		goto out;
+
+	/*A frame is received from user space*/
+	printk(KERN_DEBUG "mac80211_hwsim: CLONED FRAME received\n");
+	memset(&rx_status, 0, sizeof(rx_status));
+	/* TODO: set mactime */
+	rx_status.freq = data2->channel->center_freq;
+	rx_status.band = data2->channel->band;
+	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
+	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
+
+	memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
+	ieee80211_rx_irqsafe(data2->hw, skb);
+
+	return 0;
+out:
+	kfree_skb(skb);
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -1;
+}
+
+static int hwsim_register_received_nl(struct sk_buff *skb_2,
+				      struct genl_info *info)
+{
+	if (info == NULL)
+		goto out;
+
+	atomic_set(&wmediumd_pid, info->snd_pid);
+
+	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
+	       "switching to wmediumd mode with pid %d\n", info->snd_pid);
+
+	return 0;
+
+out:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -1;
+}
+
+/* Generic Netlink operations array */
+static struct genl_ops hwsim_ops[] = {
+	{
+		.cmd = HWSIM_CMD_REGISTER,
+		.flags = 0,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_register_received_nl,
+		.dumpit = NULL,
+	},
+	{
+		.cmd = HWSIM_CMD_FRAME,
+		.flags = 0,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_cloned_frame_received_nl,
+		.dumpit = NULL,
+	},
+	{
+		.cmd = HWSIM_CMD_TX_INFO_FRAME,
+		.flags = 0,
+		.policy = hwsim_genl_policy,
+		.doit = hwsim_tx_info_frame_received_nl,
+		.dumpit = NULL,
+	},
+};
+
+static int hwsim_init_netlink(void)
+{
+	int rc;
+	printk(KERN_INFO "mac80211_hwsim: initializing netlink\n");
+
+	atomic_set(&wmediumd_pid, 0);
+
+	rc = genl_register_family(&hwsim_genl_family);
+	if (rc != 0)
+		goto failure;
+	rc = genl_register_ops(&hwsim_genl_family, &hwsim_ops[0]);
+	if (rc != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: register ops: %i\n", rc);
+		genl_unregister_family(&hwsim_genl_family);
+		goto failure;
+	}
+	rc = genl_register_ops(&hwsim_genl_family, &hwsim_ops[1]);
+	if (rc != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: register ops: %i\n", rc);
+		genl_unregister_family(&hwsim_genl_family);
+		goto failure;
+	}
+	rc = genl_register_ops(&hwsim_genl_family, &hwsim_ops[2]);
+	if (rc != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: register ops: %i\n", rc);
+		genl_unregister_family(&hwsim_genl_family);
+		goto failure;
+	}
+	return 0;
+
+failure:
+	printk(KERN_DEBUG "mac80211_hwsim: error occured in %s\n", __func__);
+	return -1;
+}
+
+static void hwsim_exit_netlink(void)
+{
+	int ret;
+
+	printk(KERN_INFO "mac80211_hwsim: closing netlink\n");
+	/*unregister the functions*/
+
+	ret = genl_unregister_ops(&hwsim_genl_family, &hwsim_ops[0]);
+	if (ret != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: unregister ops: %i\n", ret);
+		return;
+	}
+	ret = genl_unregister_ops(&hwsim_genl_family, &hwsim_ops[1]);
+	if (ret != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: unregister ops: %i\n", ret);
+		return;
+	}
+	ret = genl_unregister_ops(&hwsim_genl_family, &hwsim_ops[2]);
+	if (ret != 0) {
+		printk(KERN_DEBUG "mac80211_hwsim: unregister ops: %i\n", ret);
+		return;
+	}
+	ret = genl_unregister_family(&hwsim_genl_family);
+	if (ret != 0)
+		printk(KERN_DEBUG "mac80211_hwsim: "
+		       "unregister family %i\n", ret);
+}
+
+
 DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
@@ -1379,6 +1731,10 @@ static int __init init_mac80211_hwsim(void)
 		data->group = 1;
 		mutex_init(&data->mutex);
 
+		/* Enable frame retransmission mechanism for a lossy channel */
+		hw->max_rates = 4;
+		hw->max_rate_tries = 11;
+
 		/* Work to be done prior to ieee80211_register_hw() */
 		switch (regtest) {
 		case HWSIM_REGTEST_DISABLED:
@@ -1528,8 +1884,16 @@ static int __init init_mac80211_hwsim(void)
 
 	rtnl_unlock();
 
+	err = hwsim_init_netlink();
+	if (err < 0)
+		goto failed_nl;
+
 	return 0;
 
+failed_nl:
+	printk(KERN_DEBUG "mac80211_hwsim: failed initializing netlink\n");
+	return err;
+
 failed_mon:
 	rtnl_unlock();
 	free_netdev(hwsim_mon);
@@ -1550,6 +1914,8 @@ static void __exit exit_mac80211_hwsim(void)
 {
 	printk(KERN_DEBUG "mac80211_hwsim: unregister radios\n");
 
+	hwsim_exit_netlink();
+
 	mac80211_hwsim_free();
 	unregister_netdev(hwsim_mon);
 }
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
new file mode 100644
index 0000000..be37f44
--- /dev/null
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -0,0 +1,123 @@
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
+#include <net/mac80211.h>
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
+ *	%HWSIM_ATTR_MSG, %HWSIM_ATTR_MSG_LEN, %HWSIM_ATTR_FLAGS,
+ *	%HWSIM_ATTR_RX_RATE, %HWSIM_ATTR_SIGNAL, %HWSIM_ATTR_CB_SKB
+ * @HWSIM_CMD_TX_INFO_FRAME: Transmission info report from user space to
+ * kernel, uses:
+ *	%HWSIM_ATTR_ADDR_TRANSMITTER, %HWSIM_ATTR_MSG, %HWSIM_ATTR_MSG_LEN,
+ *	%HWSIM_ATTR_FLAGS, %HWSIM_ATTR_TX_INFO, %HWSIM_ATTR_SIGNAL
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
+ * @HWSIM_ATTR_MSG_LEN: Length of the broadcasted frame
+ * @HWSIM_ATTR_MSG: Data array
+ * @HWSIM_ATTR_FLAGS: mac80211 transmission flags, used to process
+	properly the frame at user space
+ * @HWSIM_ATTR_RX_RATE: estimated rx rate index for this frame at user
+	space
+ * @HWSIM_ATTR_SIGNAL: estimated RX signal for this frame at user
+	space
+ * @HWSIM_ATTR_TX_INFO: ieee80211_tx_rate array
+ * @HWSIM_ATTR_CB_SKB: sk_buff custom buffer of the broadcasted frame
+ * @__HWSIM_ATTR_MAX: enum limit
+ */
+
+
+enum {
+	HWSIM_ATTR_UNSPEC,
+	HWSIM_ATTR_ADDR_RECEIVER,
+	HWSIM_ATTR_ADDR_TRANSMITTER,
+	HWSIM_ATTR_MSG_LEN,
+	HWSIM_ATTR_MSG,
+	HWSIM_ATTR_FLAGS,
+	HWSIM_ATTR_RX_RATE,
+	HWSIM_ATTR_SIGNAL,
+	HWSIM_ATTR_TX_INFO,
+	HWSIM_ATTR_CB_SKB,
+	__HWSIM_ATTR_MAX,
+};
+#define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
+
+static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
+	[HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC,
+				       .len = 6*sizeof(u8) },
+	[HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC,
+					  .len = 6*sizeof(u8) },
+	[HWSIM_ATTR_MSG_LEN] = { .type = NLA_U32 },
+	[HWSIM_ATTR_MSG] = { .type = NLA_STRING },
+	[HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
+	[HWSIM_ATTR_RX_RATE] = { .type = NLA_U32},
+	[HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
+	[HWSIM_ATTR_TX_INFO] = { .type = NLA_UNSPEC,
+				 .len = IEEE80211_TX_MAX_RATES*sizeof(
+					struct ieee80211_tx_rate)},
+	[HWSIM_ATTR_CB_SKB] = { .type = NLA_UNSPEC, .len = 48*sizeof(char) },
+};
+
+#define VERSION_NR 1
+
+static struct genl_family hwsim_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.hdrsize = 0,
+	.name = "HWSIM",
+	.version = VERSION_NR,
+	.maxattr = HWSIM_ATTR_MAX,
+};
-- 
1.7.0.4

