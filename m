Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:11054 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab0DSIYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 04:24:03 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 1C70A3A009
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:24:02 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y60GDnnJdcyh for <linux-wireless@vger.kernel.org>;
	Mon, 19 Apr 2010 10:24:02 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F800E.dip0.t-ipconnect.de [217.95.128.14])
	by mx51.mymxserver.com (Postfix) with ESMTP id 74F563A00A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:24:01 +0200 (CEST)
Received: from mnz66.localnet (schurig.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 03A921E0036
	for <linux-wireless@vger.kernel.org>; Mon, 19 Apr 2010 10:24:01 +0200 (CEST)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] ath5k: basic support for survey
Date: Mon, 19 Apr 2010 10:24:22 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201004191024.22550.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds the first element of survey data, the noise floor figure.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- linux-wl.orig/drivers/net/wireless/ath/ath5k/base.c
+++ linux-wl/drivers/net/wireless/ath/ath5k/base.c
@@ -242,6 +242,8 @@ static int ath5k_set_key(struct ieee8021
 		struct ieee80211_key_conf *key);
 static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats);
+static int ath5k_get_survey(struct ieee80211_hw *hw,
+		int idx, struct survey_info *survey);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
@@ -267,6 +269,7 @@ static const struct ieee80211_ops ath5k_
 	.configure_filter = ath5k_configure_filter,
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
+	.get_survey	= ath5k_get_survey,
 	.conf_tx 	= NULL,
 	.get_tsf 	= ath5k_get_tsf,
 	.set_tsf 	= ath5k_set_tsf,
@@ -3294,6 +3297,22 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 
 	return 0;
 }
+
+static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
+		struct survey_info *survey)
+{
+	struct ath5k_softc *sc = hw->priv;
+	struct ieee80211_conf *conf = &hw->conf;
+
+	 if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = sc->ah->ah_noise_floor;
+
+	return 0;
+}
 
 static u64
 ath5k_get_tsf(struct ieee80211_hw *hw)

-- 
DH3HS, http://www.holgerschurig.de
