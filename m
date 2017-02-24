Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58756 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751804AbdBXA3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:29:11 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 162/306] mac80211-hwsim: add length checks before allocating skb.
Date: Thu, 23 Feb 2017 16:28:29 -0800
Message-Id: <1487896109-23851-7-git-send-email-greearb@candelatech.com> (sfid-20170224_012924_608239_582B171A)
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Modify the receive-from-user-space logic to do length
and 'is-down' checks before trying to allocate an skb.

And, if we are going to ignore the pkt due to radio idle,
then do not return an error code to user-space.  User-space
cannot reliably know exactly when a radio is idle or not.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 43 +++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 48ddf5d..3a96933 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3020,25 +3020,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
 	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
 
-	/* Allocate new skb here */
-	skb = alloc_skb(frame_data_len, GFP_KERNEL);
-	if (skb == NULL) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
-			       frame_data_len);
-		goto out;
-	}
-
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
-		if (net_ratelimit())
-			printk(KERN_DEBUG " hwsim rx-nl: data lenth error: %d  max: %d\n",
-			       frame_data_len, IEEE80211_MAX_DATA_LEN);
-		goto out;
-	}
-
-	/* Copy the data */
-	memcpy(skb_put(skb, frame_data_len), frame_data, frame_data_len);
-
 	data2 = get_hwsim_data_ref_from_addr(dst);
 
 	if (!data2) {
@@ -3067,9 +3048,33 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		if (((cnt++ & 0x3FF) == 0x3FF) && net_ratelimit())
 			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d cnt: %d\n",
 			       dst, data2->idle, !data2->started, cnt);
+		/* Fail silently, no need to bug user-space about this, since lots of races
+		 * in up/down interface, and the user-space app cannot keep perfectly
+		 * in sync.
+		 */
+		return 0;
+	}
+
+	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: data lenth error: %d  max: %d\n",
+			       frame_data_len, IEEE80211_MAX_DATA_LEN);
+		goto out;
+	}
+
+
+	/* Allocate new skb here */
+	skb = alloc_skb(frame_data_len, GFP_KERNEL);
+	if (skb == NULL) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
+			       frame_data_len);
 		goto out;
 	}
 
+	/* Copy the data */
+	memcpy(skb_put(skb, frame_data_len), frame_data, frame_data_len);
+
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
 	if (info->attrs[HWSIM_ATTR_FREQ]) {
-- 
2.4.11
