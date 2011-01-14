Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47455 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab1ANUEO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jan 2011 15:04:14 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 14 Jan 2011 12:03:56 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linux-wireless@vger.kernel.org>
CC: Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k_htc: keep calibrated noise floor value for oper channel
Date: Sat, 15 Jan 2011 01:33:28 +0530
Message-ID: <1295035408-12507-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k_hw assumes that caldata is valid only for
oper channel. But with ath9k_htc case, the caldata is
passed for all channels on hw_reset though we are not doing
calibration on that channel. So the oper channel's nf history
got cleared to default due to mismatch in channel flags.
This patch also saves some space.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc.h          |    2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |    7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 1ce506f..c976600 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -366,7 +366,7 @@ struct ath9k_htc_priv {
 	u16 seq_no;
 	u32 bmiss_cnt;
 
-	struct ath9k_hw_cal_data caldata[ATH9K_NUM_CHANNELS];
+	struct ath9k_hw_cal_data caldata;
 
 	spinlock_t beacon_lock;
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index f4d576b..187af5b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -121,7 +121,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	struct ath_hw *ah = priv->ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_channel *channel = priv->hw->conf.channel;
-	struct ath9k_hw_cal_data *caldata;
+	struct ath9k_hw_cal_data *caldata = NULL;
 	enum htc_phymode mode;
 	__be16 htc_mode;
 	u8 cmd_rsp;
@@ -139,7 +139,7 @@ void ath9k_htc_reset(struct ath9k_htc_priv *priv)
 	WMI_CMD(WMI_DRAIN_TXQ_ALL_CMDID);
 	WMI_CMD(WMI_STOP_RECV_CMDID);
 
-	caldata = &priv->caldata[channel->hw_value];
+	caldata = &priv->caldata;
 	ret = ath9k_hw_reset(ah, ah->curchan, caldata, false);
 	if (ret) {
 		ath_err(common,
@@ -202,7 +202,8 @@ static int ath9k_htc_set_channel(struct ath9k_htc_priv *priv,
 		channel->center_freq, conf_is_ht(conf), conf_is_ht40(conf),
 		fastcc);
 
-	caldata = &priv->caldata[channel->hw_value];
+	if (!fastcc)
+		caldata = &priv->caldata;
 	ret = ath9k_hw_reset(ah, hchan, caldata, fastcc);
 	if (ret) {
 		ath_err(common,
-- 
1.7.3.5

