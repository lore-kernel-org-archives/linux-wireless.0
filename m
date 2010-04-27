Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60558 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757006Ab0D0VXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 17:23:33 -0400
Received: by pvb32 with SMTP id 32so33007pvb.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Apr 2010 14:23:33 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Subject: [RFT] ar9170: implement get_survey
Date: Tue, 27 Apr 2010 23:23:21 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201004272323.22107.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds a basic get_survey for ar9170.

Survey data from wlan1
	frequency:	2412 MHz
	noise:		-85 dBm

TODO:
  Currently, the noise level is updated only by a channel change.
  Now, we could simply add another ar9170_set_channel to always get
  a fresh result, but then we risk a RF lockup.
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index dc662b7..26fa31e 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -198,7 +198,7 @@ struct ar9170 {
 
 	/* PHY */
 	struct ieee80211_channel *channel;
-	int noise[4];
+	int noise[6];
 
 	/* power calibration data */
 	u8 power_5G_leg[4];
@@ -302,5 +302,5 @@ int ar9170_init_phy(struct ar9170 *ar, enum ieee80211_band band);
 int ar9170_init_rf(struct ar9170 *ar);
 int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		       enum ar9170_rf_init_mode rfi, enum ar9170_bw bw);
-
+int ar9170_get_noisefloor(struct ar9170 *ar);
 #endif /* __AR9170_H */
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 3247db8..1e422ed 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -2485,6 +2485,25 @@ static int ar9170_ampdu_action(struct ieee80211_hw *hw,
 	return 0;
 }
 
+static int ar9170_op_get_survey(struct ieee80211_hw *hw, int idx,
+				struct survey_info *survey)
+{
+	struct ar9170 *ar = hw->priv;
+	int err;
+
+	if (idx != 0)
+		return -ENOENT;
+
+	err = ar9170_get_noisefloor(ar);
+	if (err)
+		return err;
+
+	survey->channel = ar->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = ar->noise[0];
+	return 0;
+}
+
 static const struct ieee80211_ops ar9170_ops = {
 	.start			= ar9170_op_start,
 	.stop			= ar9170_op_stop,
@@ -2501,6 +2520,7 @@ static const struct ieee80211_ops ar9170_ops = {
 	.sta_add		= ar9170_sta_add,
 	.sta_remove		= ar9170_sta_remove,
 	.get_stats		= ar9170_get_stats,
+	.get_survey		= ar9170_op_get_survey,
 	.ampdu_action		= ar9170_ampdu_action,
 };
 
diff --git a/drivers/net/wireless/ath/ar9170/phy.c b/drivers/net/wireless/ath/ar9170/phy.c
index 45a415e..31ff163 100644
--- a/drivers/net/wireless/ath/ar9170/phy.c
+++ b/drivers/net/wireless/ath/ar9170/phy.c
@@ -1584,6 +1584,31 @@ static int ar9170_calc_noise_dbm(u32 raw_noise)
 		return (raw_noise & 0xff) >> 1;
 }
 
+int ar9170_get_noisefloor(struct ar9170 *ar)
+{
+	static const u32 phy_regs[] = {
+		0x1c5864, 0x1c6864, 0x1c7864,
+		0x1c59bc, 0x1c69bc, 0x1c79bc };
+	u32 phy_res[ARRAY_SIZE(phy_regs)];
+	int err, i;
+
+	BUILD_BUG_ON(ARRAY_SIZE(phy_regs) != ARRAY_SIZE(ar->noise));
+
+	err = ar9170_read_mreg(ar, ARRAY_SIZE(phy_regs), phy_regs, phy_res);
+	if (err)
+		return err;
+
+	for (i = 0; i < ARRAY_SIZE(phy_regs); i++) {
+		ar->noise[i] = ar9170_calc_noise_dbm(
+			(phy_res[i] >> 19) & 0x1ff);
+
+		ar->noise[i + 3] = ar9170_calc_noise_dbm(
+			(phy_res[i + 3] >> 23) & 0x1ff);
+	}
+
+	return 0;
+}
+
 int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		       enum ar9170_rf_init_mode rfi, enum ar9170_bw bw)
 {
@@ -1708,12 +1733,12 @@ int ar9170_set_channel(struct ar9170 *ar, struct ieee80211_channel *channel,
 		}
 	}
 
-	for (i = 0; i < 2; i++) {
+	for (i = 0; i < 3; i++) {
 		ar->noise[i] = ar9170_calc_noise_dbm(
-				(le32_to_cpu(vals[2 + i]) >> 19) & 0x1ff);
+				(le32_to_cpu(vals[i + 1]) >> 19) & 0x1ff);
 
-		ar->noise[i + 2] = ar9170_calc_noise_dbm(
-				    (le32_to_cpu(vals[5 + i]) >> 23) & 0x1ff);
+		ar->noise[i + 3] = ar9170_calc_noise_dbm(
+				    (le32_to_cpu(vals[i + 4]) >> 23) & 0x1ff);
 	}
 
 	ar->channel = channel;
