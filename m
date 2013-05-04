Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:61035 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761696Ab3EDS3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 14:29:52 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LxIeK-1UX8dQ0xT8-016zU1 for
 <linux-wireless@vger.kernel.org>; Sat, 04 May 2013 20:29:50 +0200
Message-ID: <51855397.1020802@rempel-privat.de> (sfid-20130504_202956_523260_96274133)
Date: Sat, 04 May 2013 20:29:43 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: Felix Fietkau <nbd@openwrt.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org> <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com> <5184AFC2.8060101@rempel-privat.de> <5184DCCF.9010009@openwrt.org> <5184EC19.9060206@rempel-privat.de> <5184EE0B.1030605@openwrt.org> <CAJ-Vmok_kAfoO0DEwGCsmiqeokEnURNoaLU-860X1EgENGMogQ@mail.gmail.com>
In-Reply-To: <CAJ-Vmok_kAfoO0DEwGCsmiqeokEnURNoaLU-860X1EgENGMogQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070506010900080503020608"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070506010900080503020608
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 04.05.2013 19:50, schrieb Adrian Chadd:
> I've just reviewed it myself:
>
> * oan->stbc is enabled only if the hardware itself supports STBC; so
> it's an extra sanity check in case the firmware is told to enable STBC
> in the WMI capflag field.

all STBC parts are not compiled for AR9271. Currently firmware will do 
sanity check on htc_7010.fw and always return 1, and wont do any check 
on htc_9271.fw (this part is just not compiled).

> * is oan->htinfo used anywhere that may involve STBC?

hmm...oan->htinfo?

> * .. we should check whether ath9k_htc ever set the STBC flags on
> AR9271, or we'd end up confusing the hardware.

no, never. there are legion guardians ;) last on is on preparing tx 
descriptor.

> * .. I don't think that is important though, as we weren't _doing_ STBC, right?

correct, currently STBC is not working on linux ath9k_htc

> * Why are the ATH_RC_* flags used in newassoc_11n? This comes from the
> WMI WMI_RC_STATE_CHANGE_CMDID capflag field; where are _those_
> defined?

they are in target_firmware/wlan/if_athrate.h
and well, there are a bit more problems thin them.
See attachment :) Attached patch can go on top of my merge request for 
firmware. So, i will probably need to make Patch_v5 for ath9k_htc... since.

Felix,
> In addition to that, using the WLAN_RC_* flags is wrong, you need to use
> the ATH_RC_* flags,...
After some firmware cleaning i will need to use WLAN_RC_* flags :)
WLAN_RC_* have same values like ATH_RC_*...

> Grr, so many things to tidy up.

-- 
Regards,
Oleksij

--------------070506010900080503020608
Content-Type: text/x-patch;
 name="tmp_2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tmp_2.diff"

diff --git a/target_firmware/wlan/ratectrl11n.h b/target_firmware/wlan/ratectrl11n.h
index 64d0197..00fd156 100755
--- a/target_firmware/wlan/ratectrl11n.h
+++ b/target_firmware/wlan/ratectrl11n.h
@@ -156,20 +156,6 @@ typedef struct {
 } RATE_TABLE_11N;
 
 /*
- *  Update the SIB's rate control information
- *
- *  This should be called when the supported rates change
- *  (e.g. SME operation, wireless mode change)
- *
- *  It will determine which rates are valid for use.
- */
-void rcSibUpdate_11n(struct ath_softc_tgt *,
-		     struct ath_node_target *,
-		     A_UINT32 capflag, 
-		     A_BOOL keepState,
-		     struct ieee80211_rate *rs);
-
-/*
  * Determines and returns the new Tx rate index.
  */ 
 void rcRateFind_11n(struct ath_softc_tgt *sc,
diff --git a/target_firmware/wlan/ratectrl_11n_ln.c b/target_firmware/wlan/ratectrl_11n_ln.c
index 52c1fc7..e64b254 100755
--- a/target_firmware/wlan/ratectrl_11n_ln.c
+++ b/target_firmware/wlan/ratectrl_11n_ln.c
@@ -429,19 +429,7 @@ rcSibUpdate_ht(struct ath_softc_tgt *sc, struct ath_node_target *an,
 	rcSortValidRates(pRateTable, pRc);
 }
 
-void 
-rcSibUpdate_11n(struct ath_softc_tgt *sc, struct ath_node_target *pSib, 
-		A_UINT32 capflag, A_BOOL keepState, struct ieee80211_rate  *pRateSet)
-{
-	rcSibUpdate_ht(sc, 
-		       pSib, 
-		       ((capflag & ATH_RC_DS_FLAG)   ? WLAN_RC_DS_FLAG  : 0) |
-		       ((capflag & ATH_RC_HT40_SGI_FLAG)  ? WLAN_RC_HT40_SGI_FLAG : 0) | 
-		       ((capflag & ATH_RC_HT_FLAG)   ? WLAN_RC_HT_FLAG  : 0) |
-		       ((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG  : 0),
-		       keepState,
-		       pRateSet);
-}
+
 
 /*
  * Return the median of three numbers
@@ -1212,17 +1200,11 @@ ath_rate_newassoc_11n(struct ath_softc_tgt *sc, struct ath_node_target *an, int
 	if (isnew) {
 		struct atheros_node *oan = ATH_NODE_ATHEROS(an);
 
-		oan->htcap = ((capflag & ATH_RC_DS_FLAG) ? WLAN_RC_DS_FLAG : 0) |
-			((capflag & ATH_RC_HT40_SGI_FLAG) ? WLAN_RC_HT40_SGI_FLAG : 0) | 
-			((capflag & ATH_RC_HT_FLAG)  ? WLAN_RC_HT_FLAG : 0) |
-			((capflag & ATH_RC_CW40_FLAG) ? WLAN_RC_40_FLAG : 0) |
-			((capflag & ATH_RC_WEP_TKIP_FLAG) ? WLAN_RC_WEP_TKIP_FLAG : 0);    
-    
 #ifdef MAGPIE_MERLIN
 		/* Only MERLIN can send STBC */
 		oan->stbc = (capflag & ATH_RC_RX_STBC_FLAG) ? 1 : 0;
 #endif
-		rcSibUpdate_11n(sc, an, oan->htcap, 0, rs);
+		rcSibUpdate_ht(sc, an, capflag, 0, rs);
 	}
 }
 

--------------070506010900080503020608--
