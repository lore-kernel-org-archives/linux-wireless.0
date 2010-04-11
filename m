Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:4162 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab0DKMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:25 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 1/9] rt2x00: Let RF chipset decide the RF channel switch method to use in rt2800.
Date: Sun, 11 Apr 2010 14:31:07 +0200
Message-Id: <1270989075-2267-2-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It seems that the distinction between RF channel switch method is solely based
on the RF chipset that is used.
Refactor the channel switch decision to just take the RF chipset into account,
thereby greatly simplifying the check.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index ec3ec78..6fdec15 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -717,10 +717,10 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	rt2x00dev->lna_gain = lna_gain;
 }
 
-static void rt2800_config_channel_rt2x(struct rt2x00_dev *rt2x00dev,
-				       struct ieee80211_conf *conf,
-				       struct rf_channel *rf,
-				       struct channel_info *info)
+static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
 {
 	rt2x00_set_field32(&rf->rf4, RF4_FREQ_OFFSET, rt2x00dev->freq_offset);
 
@@ -786,10 +786,10 @@ static void rt2800_config_channel_rt2x(struct rt2x00_dev *rt2x00dev,
 	rt2800_rf_write(rt2x00dev, 4, rf->rf4);
 }
 
-static void rt2800_config_channel_rt3x(struct rt2x00_dev *rt2x00dev,
-				       struct ieee80211_conf *conf,
-				       struct rf_channel *rf,
-				       struct channel_info *info)
+static void rt2800_config_channel_rf3xxx(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
 {
 	u8 rfcsr;
 
@@ -826,16 +826,13 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	unsigned int tx_pin;
 	u8 bbp;
 
-	if ((rt2x00_rt(rt2x00dev, RT3070) ||
-	     rt2x00_rt(rt2x00dev, RT3090) ||
-	     rt2x00_rt(rt2x00dev, RT2872)) &&
-	    (rt2x00_rf(rt2x00dev, RF2020) ||
-	     rt2x00_rf(rt2x00dev, RF3020) ||
-	     rt2x00_rf(rt2x00dev, RF3021) ||
-	     rt2x00_rf(rt2x00dev, RF3022)))
-		rt2800_config_channel_rt3x(rt2x00dev, conf, rf, info);
+	if (rt2x00_rf(rt2x00dev, RF2020) ||
+	    rt2x00_rf(rt2x00dev, RF3020) ||
+	    rt2x00_rf(rt2x00dev, RF3021) ||
+	    rt2x00_rf(rt2x00dev, RF3022))
+		rt2800_config_channel_rf3xxx(rt2x00dev, conf, rf, info);
 	else
-		rt2800_config_channel_rt2x(rt2x00dev, conf, rf, info);
+		rt2800_config_channel_rf2xxx(rt2x00dev, conf, rf, info);
 
 	/*
 	 * Change BBP settings
-- 
1.7.0.4

