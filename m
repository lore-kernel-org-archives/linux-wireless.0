Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ex-fe04.nebula.fi ([83.145.252.49]:19476 "EHLO ex07.nebula.fi"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752518Ab0DOLVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 07:21:24 -0400
From: Anton Puolakka <Anton.Puolakka@7signal.com>
To: Holger Schurig <holgerschurig@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 15 Apr 2010 14:15:54 +0300
Subject: RE: Survey mode volunteers
Message-ID: <0290AB2F0A8E124B9FFC144088A1A95609D6097401@EX-MBS04.nbl.local>
References: <0290AB2F0A8E124B9FFC144088A1A95609D6029647@EX-MBS04.nbl.local>
 <0290AB2F0A8E124B9FFC144088A1A95609D6096AB9@EX-MBS04.nbl.local>
 <20100412180424.GB2920@tux> <201004140911.11459.holgerschurig@gmail.com>
In-Reply-To: <201004140911.11459.holgerschurig@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,

and thanks for this.

We checked the most recent wireless-testing and saw no related patch on mac80211 yet. So, Holger, do You have one for that, too? Or anyone else on the mailing-list? Could You please share?


Kind regards,
Anton




-----Original Message-----
From: Holger Schurig [mailto:holgerschurig@gmail.com] 
Sent: 14. huhtikuuta 2010 10:11
To: Luis R. Rodriguez
Cc: Anton Puolakka; Luis Rodriguez; linux-wireless@vger.kernel.org
Subject: Re: Survey mode volunteers

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
