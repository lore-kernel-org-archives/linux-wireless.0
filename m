Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbaAGXPY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:24 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 08/12] mac80211_hwsim: minor netlink cleanups
Date: Wed,  8 Jan 2014 00:15:13 +0100
Message-Id: <1389136517-21216-9-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001539_626664_B5453780)
In-Reply-To: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
References: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use u8 pointer instead of the struct mac_address and do
some other small cleanups.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 64 +++++++++++++----------------------
 1 file changed, 23 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 08d8d61..9b2d2c5 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -298,18 +298,16 @@ static struct genl_family hwsim_genl_family = {
 /* MAC80211_HWSIM netlink policy */
 
 static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
-	[HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC,
-				       .len = 6*sizeof(u8) },
-	[HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC,
-					  .len = 6*sizeof(u8) },
+	[HWSIM_ATTR_ADDR_RECEIVER] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
+	[HWSIM_ATTR_ADDR_TRANSMITTER] = { .type = NLA_UNSPEC, .len = ETH_ALEN },
 	[HWSIM_ATTR_FRAME] = { .type = NLA_BINARY,
 			       .len = IEEE80211_MAX_DATA_LEN },
 	[HWSIM_ATTR_FLAGS] = { .type = NLA_U32 },
 	[HWSIM_ATTR_RX_RATE] = { .type = NLA_U32 },
 	[HWSIM_ATTR_SIGNAL] = { .type = NLA_U32 },
 	[HWSIM_ATTR_TX_INFO] = { .type = NLA_UNSPEC,
-				 .len = IEEE80211_TX_MAX_RATES*sizeof(
-					struct hwsim_tx_rate)},
+				 .len = IEEE80211_TX_MAX_RATES *
+					sizeof(struct hwsim_tx_rate)},
 	[HWSIM_ATTR_COOKIE] = { .type = NLA_U64 },
 };
 
@@ -536,7 +534,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	}
 
 	if (nla_put(skb, HWSIM_ATTR_ADDR_TRANSMITTER,
-		    sizeof(struct mac_address), data->addresses[1].addr))
+		    ETH_ALEN, data->addresses[1].addr))
 		goto nla_put_failure;
 
 	/* We get the skb->data */
@@ -1825,16 +1823,14 @@ DEFINE_SIMPLE_ATTRIBUTE(hwsim_fops_group,
 			hwsim_fops_group_read, hwsim_fops_group_write,
 			"%llx\n");
 
-static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(
-			     struct mac_address *addr)
+static struct mac80211_hwsim_data *get_hwsim_data_ref_from_addr(const u8 *addr)
 {
 	struct mac80211_hwsim_data *data;
 	bool _found = false;
 
 	spin_lock_bh(&hwsim_radio_lock);
 	list_for_each_entry(data, &hwsim_radios, list) {
-		if (memcmp(data->addresses[1].addr, addr,
-			  sizeof(struct mac_address)) == 0) {
+		if (memcmp(data->addresses[1].addr, addr, ETH_ALEN) == 0) {
 			_found = true;
 			break;
 		}
@@ -1857,27 +1853,23 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct hwsim_tx_rate *tx_attempts;
 	unsigned long ret_skb_ptr;
 	struct sk_buff *skb, *tmp;
-	struct mac_address *src;
+	const u8 *src;
 	unsigned int hwsim_flags;
-
 	int i;
 	bool found = false;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER] ||
-	   !info->attrs[HWSIM_ATTR_FLAGS] ||
-	   !info->attrs[HWSIM_ATTR_COOKIE] ||
-	   !info->attrs[HWSIM_ATTR_TX_INFO])
+	    !info->attrs[HWSIM_ATTR_FLAGS] ||
+	    !info->attrs[HWSIM_ATTR_COOKIE] ||
+	    !info->attrs[HWSIM_ATTR_TX_INFO])
 		goto out;
 
-	src = (struct mac_address *)nla_data(
-				   info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
+	src = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
 	hwsim_flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
-
 	ret_skb_ptr = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
 
 	data2 = get_hwsim_data_ref_from_addr(src);
-
-	if (data2 == NULL)
+	if (!data2)
 		goto out;
 
 	/* look for the skb matching the cookie passed back from user */
@@ -1934,9 +1926,9 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	struct mac80211_hwsim_data *data2;
 	struct ieee80211_rx_status rx_status;
-	struct mac_address *dst;
+	const u8 *dst;
 	int frame_data_len;
-	char *frame_data;
+	void *frame_data;
 	struct sk_buff *skb = NULL;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
@@ -1945,27 +1937,23 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	    !info->attrs[HWSIM_ATTR_SIGNAL])
 		goto out;
 
-	dst = (struct mac_address *)nla_data(
-				   info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
-
+	dst = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
-	frame_data = (char *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
+	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
 
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
 
-	if (frame_data_len <= IEEE80211_MAX_DATA_LEN) {
-		/* Copy the data */
-		memcpy(skb_put(skb, frame_data_len), frame_data,
-		       frame_data_len);
-	} else
+	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
 		goto err;
 
-	data2 = get_hwsim_data_ref_from_addr(dst);
+	/* Copy the data */
+	memcpy(skb_put(skb, frame_data_len), frame_data, frame_data_len);
 
-	if (data2 == NULL)
+	data2 = get_hwsim_data_ref_from_addr(dst);
+	if (!data2)
 		goto out;
 
 	/* check if radio is configured properly */
@@ -1973,7 +1961,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	if (data2->idle || !data2->started)
 		goto out;
 
-	/*A frame is received from user space*/
+	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.freq = data2->channel->center_freq;
 	rx_status.band = data2->channel->band;
@@ -1995,18 +1983,12 @@ out:
 static int hwsim_register_received_nl(struct sk_buff *skb_2,
 				      struct genl_info *info)
 {
-	if (info == NULL)
-		goto out;
-
 	wmediumd_portid = info->snd_portid;
 
 	printk(KERN_DEBUG "mac80211_hwsim: received a REGISTER, "
 	       "switching to wmediumd mode with pid %d\n", info->snd_portid);
 
 	return 0;
-out:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
-	return -EINVAL;
 }
 
 /* Generic Netlink operations array */
-- 
1.8.5.1

