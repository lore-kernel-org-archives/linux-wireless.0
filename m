Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:16177 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab0DNHKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 03:10:45 -0400
From: Holger Schurig <holgerschurig@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Survey mode volunteers
Date: Wed, 14 Apr 2010 09:11:11 +0200
Cc: Anton Puolakka <Anton.Puolakka@7signal.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local> <0290AB2F0A8E124B9FFC144088A1A95609D6096AB9@EX-MBS04.nbl.local> <20100412180424.GB2920@tux>
In-Reply-To: <20100412180424.GB2920@tux>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004140911.11459.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've some preliminary patch for ath5k.

---
Subject: [ath5k] add noise reporting to survey

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
 drivers/net/wireless/ath/ath5k/base.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- compat-wireless-2010-03-15.orig/drivers/net/wireless/ath/ath5k/base.c
+++ compat-wireless-2010-03-15/drivers/net/wireless/ath/ath5k/base.c
@@ -273,6 +273,8 @@ static int ath5k_set_key(struct ieee8021
 		struct ieee80211_key_conf *key);
 static int ath5k_get_stats(struct ieee80211_hw *hw,
 		struct ieee80211_low_level_stats *stats);
+static int ath5k_get_survey(struct ieee80211_hw *hw,
+		int idx, struct survey_info *survey);
 static u64 ath5k_get_tsf(struct ieee80211_hw *hw);
 static void ath5k_set_tsf(struct ieee80211_hw *hw, u64 tsf);
 static void ath5k_reset_tsf(struct ieee80211_hw *hw);
@@ -298,6 +300,7 @@ static const struct ieee80211_ops ath5k_
 	.configure_filter = ath5k_configure_filter,
 	.set_key 	= ath5k_set_key,
 	.get_stats 	= ath5k_get_stats,
+	.get_survey	= ath5k_get_survey,
 	.conf_tx 	= NULL,
 	.get_tsf 	= ath5k_get_tsf,
 	.set_tsf 	= ath5k_set_tsf,
@@ -3250,6 +3253,22 @@ ath5k_get_stats(struct ieee80211_hw *hw,
 
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
http://www.holgerschurig.de
