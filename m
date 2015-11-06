Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45301 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031997AbbKFK50 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:57:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: stop using pointers as cookies
Date: Fri,  6 Nov 2015 11:57:23 +0100
Message-Id: <1446807443-12133-1-git-send-email-johannes@sipsolutions.net> (sfid-20151106_115753_583110_62129990)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of using pointers, use sequentially assigned cookies.
This is easier to understand while debugging and also avoids
problems when the pointer is reused for the next allocation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index ee46f4647fbc..ffb6c72005fd 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -514,6 +514,7 @@ struct mac80211_hwsim_data {
 	bool ps_poll_pending;
 	struct dentry *debugfs;
 
+	uintptr_t pending_cookie;
 	struct sk_buff_head pending;	/* packets pending */
 	/*
 	 * Only radios in the same group can communicate together (the
@@ -960,6 +961,7 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 	unsigned int hwsim_flags = 0;
 	int i;
 	struct hwsim_tx_rate tx_attempts[IEEE80211_TX_MAX_RATES];
+	uintptr_t cookie;
 
 	if (data->ps != PS_DISABLED)
 		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PM);
@@ -1018,7 +1020,10 @@ static void mac80211_hwsim_tx_frame_nl(struct ieee80211_hw *hw,
 		goto nla_put_failure;
 
 	/* We create a cookie to identify this skb */
-	if (nla_put_u64(skb, HWSIM_ATTR_COOKIE, (unsigned long) my_skb))
+	data->pending_cookie++;
+	cookie = data->pending_cookie;
+	info->rate_driver_data[0] = (void *)cookie;
+	if (nla_put_u64(skb, HWSIM_ATTR_COOKIE, cookie))
 		goto nla_put_failure;
 
 	genlmsg_end(skb, msg_head);
@@ -2710,7 +2715,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct mac80211_hwsim_data *data2;
 	struct ieee80211_tx_info *txi;
 	struct hwsim_tx_rate *tx_attempts;
-	unsigned long ret_skb_ptr;
+	u64 ret_skb_cookie;
 	struct sk_buff *skb, *tmp;
 	const u8 *src;
 	unsigned int hwsim_flags;
@@ -2728,7 +2733,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	src = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
 	hwsim_flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
-	ret_skb_ptr = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+	ret_skb_cookie = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
 
 	data2 = get_hwsim_data_ref_from_addr(src);
 	if (!data2)
@@ -2736,7 +2741,12 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	/* look for the skb matching the cookie passed back from user */
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
-		if ((unsigned long)skb == ret_skb_ptr) {
+		u64 skb_cookie;
+
+		txi = IEEE80211_SKB_CB(skb);
+		skb_cookie = (u64)(uintptr_t)txi->driver_data[0];
+
+		if (skb_cookie == ret_skb_cookie) {
 			skb_unlink(skb, &data2->pending);
 			found = true;
 			break;
-- 
2.6.2

