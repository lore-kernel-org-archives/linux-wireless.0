Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:21336 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab1EUE2R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 May 2011 00:28:17 -0400
Received: from mail.atheros.com ([10.234.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 21:27:46 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sat, 21 May 2011 09:57:27 +0530
Subject: [PATCH 2/6] ath9k: Remove ATH9K_BEACON_PERIOD mask
Message-ID: <44EE5C37ADC36343B0625A05DD408C48517CFFED12@CHEXMB-01.global.atheros.com> (sfid-20110521_062820_841202_D421CFB5)
References: <1305894135-14036-1-git-send-email-rmanoharan@atheros.com>,<1305894135-14036-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1305894135-14036-2-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier beacon_interval is used to hold interval value and
some flags (ATH9K_BEACON_ENA &ATH9K_BEACON_PERIOD). So to
extract interval ATH9K_BEACON_PERIOD is used. Those flags
were completely removed. So masking beacon_interval is
not required.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c         |    6 +++---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    8 ++++----
 drivers/net/wireless/ath/ath9k/hw.c             |    6 +++---
 drivers/net/wireless/ath/ath9k/hw.h             |    1 -
 4 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index d4d8cec..8b85d7c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -496,7 +496,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
        u32 nexttbtt, intval;

        /* NB: the beacon interval is kept internally in TU's */
-       intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
+       intval = TU_TO_USEC(conf->beacon_interval);
        intval /= ATH_BCBUF;    /* for staggered beacons */
        nexttbtt = intval;

@@ -543,7 +543,7 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
        }

        memset(&bs, 0, sizeof(bs));
-       intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
+       intval = conf->beacon_interval;

        /*
         * Setup dtim and cfp parameters according to
@@ -657,7 +657,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
        ath9k_reset_beacon_status(sc);

        tsf = ath9k_hw_gettsf32(ah) + TU_TO_USEC(FUDGE);
-       intval = TU_TO_USEC(conf->beacon_interval & ATH9K_BEACON_PERIOD);
+       intval = TU_TO_USEC(conf->beacon_interval);

        if (!sc->beacon.bc_tstamp)
                nexttbtt = tsf + intval;
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index aa6a731..57fe22b 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -79,7 +79,7 @@ static void ath9k_htc_beacon_config_sta(struct ath9k_htc_priv *priv,

        memset(&bs, 0, sizeof(bs));

-       intval = bss_conf->beacon_interval & ATH9K_BEACON_PERIOD;
+       intval = bss_conf->beacon_interval;
        bmiss_timeout = (ATH_DEFAULT_BMISS_LIMIT * bss_conf->beacon_interval);

        /*
@@ -194,7 +194,7 @@ static void ath9k_htc_beacon_config_ap(struct ath9k_htc_priv *priv,
        u8 cmd_rsp;
        u64 tsf;

-       intval = bss_conf->beacon_interval & ATH9K_BEACON_PERIOD;
+       intval = bss_conf->beacon_interval;
        intval /= ATH9K_HTC_MAX_BCN_VIF;
        nexttbtt = intval;

@@ -250,7 +250,7 @@ static void ath9k_htc_beacon_config_adhoc(struct ath9k_htc_priv *priv,
        u8 cmd_rsp;
        u64 tsf;

-       intval = bss_conf->beacon_interval & ATH9K_BEACON_PERIOD;
+       intval = bss_conf->beacon_interval;
        nexttbtt = intval;

        /*
@@ -427,7 +427,7 @@ static int ath9k_htc_choose_bslot(struct ath9k_htc_priv *priv,
        u16 intval;
        int slot;

-       intval = priv->cur_beacon_conf.beacon_interval & ATH9K_BEACON_PERIOD;
+       intval = priv->cur_beacon_conf.beacon_interval;

        tsf = be64_to_cpu(swba->tsf);
        tsftu = TSF_TO_TU(tsf >> 32, tsf);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 72543ce..8300ed1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1782,16 +1782,16 @@ void ath9k_hw_set_sta_beacon_timers(struct ath_hw *ah,
        REG_WRITE(ah, AR_NEXT_TBTT_TIMER, TU_TO_USEC(bs->bs_nexttbtt));

        REG_WRITE(ah, AR_BEACON_PERIOD,
-                 TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
+                 TU_TO_USEC(bs->bs_intval));
        REG_WRITE(ah, AR_DMA_BEACON_PERIOD,
-                 TU_TO_USEC(bs->bs_intval & ATH9K_BEACON_PERIOD));
+                 TU_TO_USEC(bs->bs_intval));

        REGWRITE_BUFFER_FLUSH(ah);

        REG_RMW_FIELD(ah, AR_RSSI_THR,
                      AR_RSSI_THR_BM_THR, bs->bs_bmissthreshold);

-       beaconintval = bs->bs_intval & ATH9K_BEACON_PERIOD;
+       beaconintval = bs->bs_intval;

        if (bs->bs_sleepduration > beaconintval)
                beaconintval = bs->bs_sleepduration;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 57435ce..f8a626d 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -403,7 +403,6 @@ struct ath9k_beacon_state {
        u32 bs_nexttbtt;
        u32 bs_nextdtim;
        u32 bs_intval;
-#define ATH9K_BEACON_PERIOD       0x0000ffff
 #define ATH9K_TSFOOR_THRESHOLD    0x00004240 /* 16k us */
        u32 bs_dtimperiod;
        u16 bs_cfpperiod;
--
1.7.5.1

