Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:52232 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753380AbaCAUR2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Mar 2014 15:17:28 -0500
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, sujith@msujith.org,
	linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 14/23] ath9k_htc: use ath9k_cmn_beacon_config_sta
Date: Sat,  1 Mar 2014 21:15:57 +0100
Message-Id: <1393704966-13985-15-git-send-email-linux@rempel-privat.de> (sfid-20140301_214709_913250_61C15715)
In-Reply-To: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c | 84 +------------------------
 1 file changed, 2 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index 9ff9e6e..fc16c10 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -62,97 +62,17 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	}
 }
 
-
 static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,
 					struct ath_beacon_config *bss_conf)
 {
-	struct ath_common *common = ath9k_hw_common(priv->ah);
 	struct ath9k_beacon_state bs;
 	enum ath9k_int imask = 0;
-	int dtimperiod, dtimcount;
-	int bmiss_timeout;
-	u32 nexttbtt = 0, intval, tsftu;
 	__be32 htc_imask = 0;
-	u64 tsf;
-	int num_beacons, offset, dtim_dec_count;
 	int ret __attribute__ ((unused));
 	u8 cmd_rsp;
 
-	memset(&bs, 0, sizeof(bs));
-
-	intval = bss_conf->beacon_interval;
-	bmiss_timeout = (ATH_DEFAULT_BMISS_LIMIT * bss_conf->beacon_interval);
-
-	/*
-	 * Setup dtim parameters according to
-	 * last beacon we received (which may be none).
-	 */
-	dtimperiod = bss_conf->dtim_period;
-	if (dtimperiod <= 0)		/* NB: 0 if not known */
-		dtimperiod = 1;
-	dtimcount = 1;
-	if (dtimcount >= dtimperiod)	/* NB: sanity check */
-		dtimcount = 0;
-
-	/*
-	 * Pull nexttbtt forward to reflect the current
-	 * TSF and calculate dtim state for the result.
-	 */
-	tsf = ath9k_hw_gettsf64(priv->ah);
-	tsftu = TSF_TO_TU(tsf>>32, tsf) + FUDGE;
-
-	num_beacons = tsftu / intval + 1;
-	offset = tsftu % intval;
-	nexttbtt = tsftu - offset;
-	if (offset)
-		nexttbtt += intval;
-
-	/* DTIM Beacon every dtimperiod Beacon */
-	dtim_dec_count = num_beacons % dtimperiod;
-	dtimcount -= dtim_dec_count;
-	if (dtimcount < 0)
-		dtimcount += dtimperiod;
-
-	bs.bs_intval = TU_TO_USEC(intval);
-	bs.bs_nexttbtt = TU_TO_USEC(nexttbtt);
-	bs.bs_dtimperiod = dtimperiod * bs.bs_intval;
-	bs.bs_nextdtim = bs.bs_nexttbtt + dtimcount * bs.bs_intval;
-
-	/*
-	 * Calculate the number of consecutive beacons to miss* before taking
-	 * a BMISS interrupt. The configuration is specified in TU so we only
-	 * need calculate based	on the beacon interval.  Note that we clamp the
-	 * result to at most 15 beacons.
-	 */
-	bs.bs_bmissthreshold = DIV_ROUND_UP(bmiss_timeout, intval);
-	if (bs.bs_bmissthreshold > 15)
-		bs.bs_bmissthreshold = 15;
-	else if (bs.bs_bmissthreshold <= 0)
-		bs.bs_bmissthreshold = 1;
-
-	/*
-	 * Calculate sleep duration. The configuration is given in ms.
-	 * We ensure a multiple of the beacon period is used. Also, if the sleep
-	 * duration is greater than the DTIM period then it makes senses
-	 * to make it a multiple of that.
-	 *
-	 * XXX fixed at 100ms
-	 */
-
-	bs.bs_sleepduration = TU_TO_USEC(roundup(IEEE80211_MS_TO_TU(100),
-						 intval));
-	if (bs.bs_sleepduration > bs.bs_dtimperiod)
-		bs.bs_sleepduration = bs.bs_dtimperiod;
-
-	/* TSF out of range threshold fixed at 1 second */
-	bs.bs_tsfoor_threshold = ATH9K_TSFOOR_THRESHOLD;
-
-	ath_dbg(common, CONFIG, "intval: %u tsf: %llu tsftu: %u\n",
-		intval, tsf, tsftu);
-	ath_dbg(common, CONFIG, "bmiss: %u sleep: %u\n",
-		bs.bs_bmissthreshold, bs.bs_sleepduration);
-
-	/* Set the computed STA beacon timers */
+	if (ath9k_cmn_beacon_config_sta(priv->ah, bss_conf, &bs) == -EPERM)
+		return;
 
 	WMI_CMD(WMI_DISABLE_INTR_CMDID);
 	ath9k_hw_set_sta_beacon_timers(priv->ah, &bs);
-- 
1.9.0

