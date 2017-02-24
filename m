Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58752 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751650AbdBXA3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:29:10 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 160/306] mac80211-hwsim: add rate-limited debugging for rx-netlink
Date: Thu, 23 Feb 2017 16:28:27 -0800
Message-Id: <1487896109-23851-5-git-send-email-greearb@candelatech.com> (sfid-20170224_012925_413696_4E3C0418)
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This makes it easier to understand why wmediumd (or similar)
is getting errors when sending frames to the kernel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 42 ++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 8d494ac..aaba126 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3010,8 +3010,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
 	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
-	    !info->attrs[HWSIM_ATTR_SIGNAL])
+	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: Missing required attribute\n");
 		goto out;
+	}
 
 	dst = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
@@ -3019,29 +3022,50 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
-	if (skb == NULL)
-		goto err;
+	if (skb == NULL) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
+			       frame_data_len);
+		goto out;
+	}
 
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
-		goto err;
+	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: data lenth error: %d  max: %d\n",
+			       frame_data_len, IEEE80211_MAX_DATA_LEN);
+		goto out;
+	}
 
 	/* Copy the data */
 	memcpy(skb_put(skb, frame_data_len), frame_data, frame_data_len);
 
 	data2 = get_hwsim_data_ref_from_addr(dst);
-	if (!data2)
+
+	if (!data2) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: Cannot find radio %pM\n",
+			       dst);
 		goto out;
+	}
 
 	if (hwsim_net_get_netgroup(genl_info_net(info)) != data2->netgroup)
 		goto out;
 
-	if (info->snd_portid != data2->wmediumd)
+	if (info->snd_portid != data2->wmediumd) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: portid mismatch, snd_portid: %d  portid %d\n",
+			       info->snd_portid, data2->wmediumd);
 		goto out;
+	}
 
 	/* check if radio is configured properly */
 
-	if (data2->idle || !data2->started)
+	if (data2->idle || !data2->started) {
+		if (net_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d\n",
+			       dst, data2->idle, !data2->started);
 		goto out;
+	}
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
@@ -3084,8 +3108,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	ieee80211_rx_irqsafe(data2->hw, skb);
 
 	return 0;
-err:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
-- 
2.4.11
