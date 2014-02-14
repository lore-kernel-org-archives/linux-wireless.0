Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:55896 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaBNEZK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 23:25:10 -0500
Received: by mail-pa0-f43.google.com with SMTP id rd3so11703872pab.16
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 20:25:09 -0800 (PST)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@qca.qualcomm.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH v2] ath10k: implement drv_get_tsf for ibss merging
Date: Fri, 14 Feb 2014 12:24:55 +0800
Message-Id: <1392351895-20495-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140214_052520_321800_C593C270)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the get TSF by simply returning 0 so that IBSS
merging is happening. Otherwise, IBSS nodes that have similar
SSID naming won't merge. This is simply fooling the mac80211
that the TSF in the received beacon is higher than the local TSF.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
v2: simplify without mutex (Kalle Valo)

 drivers/net/wireless/ath/ath10k/mac.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index afa1226..f39d1b0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4049,6 +4049,15 @@ static void ath10k_sta_rc_update(struct ieee80211_hw *hw,
 	ieee80211_queue_work(hw, &arsta->update_wk);
 }
 
+static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+	/* FIXME: Return 0 for time being. Need to figure out whether FW has
+	 * the API to fetch 64-bit local TSF
+	 */
+
+	return 0;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -4074,6 +4083,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
 	.channel_switch_beacon		= ath10k_channel_switch_beacon,
 	.sta_rc_update			= ath10k_sta_rc_update,
+	.get_tsf			= ath10k_get_tsf,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
-- 
1.7.9.5

