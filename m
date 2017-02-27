Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37274 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751395AbdB1Ece (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 23:32:34 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 3/4] mac80211-hwsim: add rate-limited debugging for rx-netlink
Date: Mon, 27 Feb 2017 13:56:32 -0800
Message-Id: <1488232593-2552-3-git-send-email-greearb@candelatech.com> (sfid-20170228_053241_839152_328ADC4B)
In-Reply-To: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
References: <1488232593-2552-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This makes it easier to understand why wmediumd (or similar)
is getting errors when sending frames to the kernel.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v2:  Add and use hwsim_ratelimit() instead of net_ratelimit.
     Squash two patches into this one.

 drivers/net/wireless/mac80211_hwsim.c | 55 +++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 635ad03..c259b99 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -137,6 +137,12 @@ static int regtest = HWSIM_REGTEST_DISABLED;
 module_param(regtest, int, 0444);
 MODULE_PARM_DESC(regtest, "The type of regulatory test we want to run");
 
+DEFINE_RATELIMIT_STATE(hwsim_ratelimit_state, 5 * HZ, 10);
+int hwsim_ratelimit(void)
+{
+	return __ratelimit(&hwsim_ratelimit_state);
+}
+
 static const char *hwsim_alpha2s[] = {
 	"FI",
 	"AL",
@@ -1641,7 +1647,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (conf->chandef.chan)
 		wiphy_debug(hw->wiphy,
-			    "%s (freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
+			    "%s (chandef-chan freq=%d(%d - %d)/%s idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    conf->chandef.chan->center_freq,
 			    conf->chandef.center_freq1,
@@ -1652,7 +1658,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 			    smps_modes[conf->smps_mode]);
 	else
 		wiphy_debug(hw->wiphy,
-			    "%s (freq=0 idle=%d ps=%d smps=%s)\n",
+			    "%s (no-chandef-chan freq=0 idle=%d ps=%d smps=%s)\n",
 			    __func__,
 			    !!(conf->flags & IEEE80211_CONF_IDLE),
 			    !!(conf->flags & IEEE80211_CONF_PS),
@@ -3018,8 +3024,11 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
 	    !info->attrs[HWSIM_ATTR_FRAME] ||
 	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
-	    !info->attrs[HWSIM_ATTR_SIGNAL])
+	    !info->attrs[HWSIM_ATTR_SIGNAL]) {
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: Missing required attribute\n");
 		goto out;
+	}
 
 	dst = (void *)nla_data(info->attrs[HWSIM_ATTR_ADDR_RECEIVER]);
 	frame_data_len = nla_len(info->attrs[HWSIM_ATTR_FRAME]);
@@ -3027,29 +3036,53 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* Allocate new skb here */
 	skb = alloc_skb(frame_data_len, GFP_KERNEL);
-	if (skb == NULL)
-		goto err;
+	if (skb == NULL) {
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: skb alloc failed, len: %d\n",
+			       frame_data_len);
+		goto out;
+	}
 
-	if (frame_data_len > IEEE80211_MAX_DATA_LEN)
-		goto err;
+	if (frame_data_len > IEEE80211_MAX_DATA_LEN) {
+		if (hwsim_ratelimit())
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
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: Cannot find radio %pM\n",
+			       dst);
 		goto out;
+	}
 
 	if (hwsim_net_get_netgroup(genl_info_net(info)) != data2->netgroup)
 		goto out;
 
-	if (info->snd_portid != data2->wmediumd)
+	if (info->snd_portid != data2->wmediumd) {
+		if (hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: portid mismatch, snd_portid: %d  portid %d\n",
+			       info->snd_portid, data2->wmediumd);
 		goto out;
+	}
 
 	/* check if radio is configured properly */
 
-	if (data2->idle || !data2->started)
+	if (data2->idle || !data2->started) {
+		static unsigned int cnt = 0;
+		/* This is fairly common, and usually not a bug.  So, print errors
+		   rarely. */
+		if (((cnt++ & 0x3FF) == 0x3FF) && hwsim_ratelimit())
+			printk(KERN_DEBUG " hwsim rx-nl: radio %pM idle: %d or not started: %d cnt: %d\n",
+			       dst, data2->idle, !data2->started, cnt);
 		goto out;
+	}
 
 	/* A frame is received from user space */
 	memset(&rx_status, 0, sizeof(rx_status));
@@ -3082,8 +3115,6 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	ieee80211_rx_irqsafe(data2->hw, skb);
 
 	return 0;
-err:
-	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 out:
 	dev_kfree_skb(skb);
 	return -EINVAL;
-- 
2.4.11
