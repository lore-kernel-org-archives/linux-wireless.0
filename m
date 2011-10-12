Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4324 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/22] brcm80211: removed unused functions
Date: Wed, 12 Oct 2011 20:51:25 +0200
Message-ID: <1318445492-24207-16-git-send-email-arend@broadcom.com> (sfid-20111012_205153_538636_94F5ABCB)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Removed brcmu_bitcount, brcmu_mhz2channel, brcmu_chspec_ctlchan.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |    2 -
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   14 ---
 drivers/net/wireless/brcm80211/brcmutil/wifi.c     |   93 --------------------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    1 -
 .../net/wireless/brcm80211/include/brcmu_wifi.h    |   28 ------
 5 files changed, 0 insertions(+), 138 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/stf.c b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
index f1bd1bf..d8f528e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/stf.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/stf.c
@@ -30,8 +30,6 @@
 #define BRCMS_STF_SS_STBC_RX(wlc) (BRCMS_ISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
-#define BRCMS_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
-
 #define NSTS_1	1
 #define NSTS_2	2
 #define NSTS_3	3
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index e96bdbf..990cb2e 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -585,17 +585,3 @@ u8 brcmu_mw_to_qdbm(u16 mw)
 }
 EXPORT_SYMBOL(brcmu_mw_to_qdbm);
 
-uint brcmu_bitcount(u8 *bitmap, uint length)
-{
-	uint bitcount = 0, i;
-	u8 tmp;
-	for (i = 0; i < length; i++) {
-		tmp = bitmap[i];
-		while (tmp) {
-			bitcount++;
-			tmp &= (tmp - 1);
-		}
-	}
-	return bitcount;
-}
-EXPORT_SYMBOL(brcmu_bitcount);
diff --git a/drivers/net/wireless/brcm80211/brcmutil/wifi.c b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
index 509e25c..e8d3bf2 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/wifi.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
@@ -41,96 +41,3 @@ bool brcmu_chspec_malformed(u16 chanspec)
 	return false;
 }
 EXPORT_SYMBOL(brcmu_chspec_malformed);
-
-/*
- * This function returns the channel number that control traffic is being sent
- * on, for legacy channels this is just the channel number, for 40MHZ channels
- * it is the upper or lower 20MHZ sideband depending on the chanspec selected.
- */
-u8 brcmu_chspec_ctlchan(u16 chspec)
-{
-	u8 ctl_chan;
-
-	/* Is there a sideband ? */
-	if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_NONE) {
-		return CHSPEC_CHANNEL(chspec);
-	} else {
-		/*
-		 * we only support 40MHZ with sidebands. chanspec channel holds
-		 * the centre frequency, use that and the side band information
-		 * to reconstruct the control channel number
-		 */
-		if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_UPPER)
-			/*
-			 * control chan is the upper 20 MHZ SB of the
-			 * 40MHZ channel
-			 */
-			ctl_chan = upper_20_sb(CHSPEC_CHANNEL(chspec));
-		else
-			/*
-			 * control chan is the lower 20 MHZ SB of the
-			 * 40MHZ channel
-			 */
-			ctl_chan = lower_20_sb(CHSPEC_CHANNEL(chspec));
-	}
-
-	return ctl_chan;
-}
-EXPORT_SYMBOL(brcmu_chspec_ctlchan);
-
-/*
- * Return the channel number for a given frequency and base frequency.
- * The returned channel number is relative to the given base frequency.
- * If the given base frequency is zero, a base frequency of 5 GHz is assumed for
- * frequencies from 5 - 6 GHz, and 2.407 GHz is assumed for 2.4 - 2.5 GHz.
- *
- * Frequency is specified in MHz.
- * The base frequency is specified as (start_factor * 500 kHz).
- * Constants WF_CHAN_FACTOR_2_4_G, WF_CHAN_FACTOR_5_G are defined for
- * 2.4 GHz and 5 GHz bands.
- *
- * The returned channel will be in the range [1, 14] in the 2.4 GHz band
- * and [0, 200] otherwise.
- * -1 is returned if the start_factor is WF_CHAN_FACTOR_2_4_G and the
- * frequency is not a 2.4 GHz channel, or if the frequency is not and even
- * multiple of 5 MHz from the base frequency to the base plus 1 GHz.
- *
- * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
- */
-int brcmu_mhz2channel(uint freq, uint start_factor)
-{
-	int ch = -1;
-	uint base;
-	int offset;
-
-	/* take the default channel start frequency */
-	if (start_factor == 0) {
-		if (freq >= 2400 && freq <= 2500)
-			start_factor = WF_CHAN_FACTOR_2_4_G;
-		else if (freq >= 5000 && freq <= 6000)
-			start_factor = WF_CHAN_FACTOR_5_G;
-	}
-
-	if (freq == 2484 && start_factor == WF_CHAN_FACTOR_2_4_G)
-		return 14;
-
-	base = start_factor / 2;
-
-	/* check that the frequency is in 1GHz range of the base */
-	if ((freq < base) || (freq > base + 1000))
-		return -1;
-
-	offset = freq - base;
-	ch = offset / 5;
-
-	/* check that frequency is a 5MHz multiple from the base */
-	if (offset != (ch * 5))
-		return -1;
-
-	/* restricted channel range check for 2.4G */
-	if (start_factor == WF_CHAN_FACTOR_2_4_G && (ch < 1 || ch > 13))
-		return -1;
-
-	return ch;
-}
-EXPORT_SYMBOL(brcmu_mhz2channel);
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index a7d3df2..96f05d7 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -218,6 +218,5 @@ extern u8 brcmu_mw_to_qdbm(u16 mw);
 
 extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
-extern uint brcmu_bitcount(u8 *bitmap, uint bytelength);
 
 #endif				/* _BRCMU_UTILS_H_ */
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
index 452bd42..5b1aca7 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_wifi.h
@@ -176,34 +176,6 @@ static inline bool ac_bitmap_tst(u8 bitmap, int prec)
  */
 extern bool brcmu_chspec_malformed(u16 chanspec);
 
-/*
- * This function returns the channel number that control traffic is being sent
- * on, for legacy channels this is just the channel number, for 40MHZ channels
- * it is the upper or lower 20MHZ sideband depending on the chanspec selected.
- */
-extern u8 brcmu_chspec_ctlchan(u16 chspec);
-
-/*
- * Return the channel number for a given frequency and base frequency.
- * The returned channel number is relative to the given base frequency.
- * If the given base frequency is zero, a base frequency of 5 GHz is assumed for
- * frequencies from 5 - 6 GHz, and 2.407 GHz is assumed for 2.4 - 2.5 GHz.
- *
- * Frequency is specified in MHz.
- * The base frequency is specified as (start_factor * 500 kHz).
- * Constants WF_CHAN_FACTOR_2_4_G, WF_CHAN_FACTOR_5_G are defined for
- * 2.4 GHz and 5 GHz bands.
- *
- * The returned channel will be in the range [1, 14] in the 2.4 GHz band
- * and [0, 200] otherwise.
- * -1 is returned if the start_factor is WF_CHAN_FACTOR_2_4_G and the
- * frequency is not a 2.4 GHz channel, or if the frequency is not and even
- * multiple of 5 MHz from the base frequency to the base plus 1 GHz.
- *
- * Reference 802.11 REVma, section 17.3.8.3, and 802.11B section 18.4.6.2
- */
-extern int brcmu_mhz2channel(uint freq, uint start_factor);
-
 /* Enumerate crypto algorithms */
 #define	CRYPTO_ALGO_OFF			0
 #define	CRYPTO_ALGO_WEP1		1
-- 
1.7.4.1


