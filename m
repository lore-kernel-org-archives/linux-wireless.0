Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563Ab2FYMuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 08:50:54 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Sj8km-0002mm-UI
	for linux-wireless@vger.kernel.org; Mon, 25 Jun 2012 14:50:53 +0200
Message-ID: <1340628649.4485.0.camel@jlt3.sipsolutions.net> (sfid-20120625_145135_903697_1A290E60)
Subject: [PATCH] mac80211_hwsim: fix smatch/sparse complaints
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 25 Jun 2012 14:50:49 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The code is fine in both cases as-is, but we can
write it slightly differently to fix smatch/sparse
complaints:
 * compare the skb pointer (which we use as a cookie)
   by casting the skb to unsigned long rather than the
   cookie to a pointer (fixes "different address spaces")
 * when transmitting, data->channel must be assigned,
   don't check it (fixes "dereferenced before check")

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
(will commit to mac80211-next unless somebody objects?)

 drivers/net/wireless/mac80211_hwsim.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index bd63501..ab106d6 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -678,8 +678,7 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 			continue;
 
 		if (data2->idle || !data2->started ||
-		    !hwsim_ps_rx_ok(data2, skb) ||
-		    !data->channel || !data2->channel ||
+		    !hwsim_ps_rx_ok(data2, skb) || !data2->channel ||
 		    data->channel->center_freq != data2->channel->center_freq ||
 		    !(data->group & data2->group))
 			continue;
@@ -1486,7 +1485,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	struct mac80211_hwsim_data *data2;
 	struct ieee80211_tx_info *txi;
 	struct hwsim_tx_rate *tx_attempts;
-	struct sk_buff __user *ret_skb;
+	unsigned long ret_skb_ptr;
 	struct sk_buff *skb, *tmp;
 	struct mac_address *src;
 	unsigned int hwsim_flags;
@@ -1504,8 +1503,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 				   info->attrs[HWSIM_ATTR_ADDR_TRANSMITTER]);
 	hwsim_flags = nla_get_u32(info->attrs[HWSIM_ATTR_FLAGS]);
 
-	ret_skb = (struct sk_buff __user *)
-		  (unsigned long) nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
+	ret_skb_ptr = nla_get_u64(info->attrs[HWSIM_ATTR_COOKIE]);
 
 	data2 = get_hwsim_data_ref_from_addr(src);
 
@@ -1514,7 +1512,7 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 
 	/* look for the skb matching the cookie passed back from user */
 	skb_queue_walk_safe(&data2->pending, skb, tmp) {
-		if (skb == ret_skb) {
+		if ((unsigned long)skb == ret_skb_ptr) {
 			skb_unlink(skb, &data2->pending);
 			found = true;
 			break;
-- 
1.7.10



