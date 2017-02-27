Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37270 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751344AbdB1Ece (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 23:32:34 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 4/4] mac80211-hwsim: add length checks before allocating skb.
Date: Mon, 27 Feb 2017 13:56:33 -0800
Message-Id: <1488232593-2552-4-git-send-email-greearb@candelatech.com> (sfid-20170228_053240_112558_3745F639)
In-Reply-To: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
References: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
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

v2:  Don't return success when radio is idle, but do return unique
     error code (ENETDOWN) in hopes user-space can make a distinction.

 drivers/net/wireless/mac80211_hwsim.c | 41 +++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c259b99..73dc627 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3020,6 +3020,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	int frame_data_len;
 	void *frame_data;
 	struct sk_buff *skb = NULL;
+	int rv = -EINVAL;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
@@ -3034,25 +3035,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
 	frame_data = (void *)nla_data(info->attrs[HWSIM_ATTR_FRAME]);
 
-	/* Allocate new skb here */
-	skb = alloc_skb(frame_data_len, GFP_KERNEL);
-	if (skb == NULL) {
-		if (hwsim_ratelimit())
-			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
-			       frame_data_len);
-		goto out;
-	}
-
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
-		if (hwsim_ratelimit())
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
@@ -3081,9 +3063,30 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 		if (((cnt++ & 0x3FF) == 0x3FF) && hwsim_ratelimit())
 			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d cnt: %d\n",
 			       dst, data2->idle, !data2->started, cnt);
+		rv = -ENETDOWN;
 		goto out;
 	}
 
+	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: data lenth error: %d  max: %d\n",
+			       frame_data_len, IEEE80211_MAX_DATA_LEN);
+		goto out;
+	}
+
+
+	/* Allocate new skb here */
+	skb = alloc_skb(frame_data_len, GFP_KERNEL);
+	if (skb == NULL) {
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
+			       frame_data_len);
+		goto out;
+	}
+
+	/* Copy the data */
+	memcpy(skb_put(skb, frame_data_len), frame_data, frame_data_len);
+
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
 	if (info->attrs[HWSIM_ATTR_FREQ]) {
-- 
2.4.11
