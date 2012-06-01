Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:42266 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965359Ab2FAQPq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jun 2012 12:15:46 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 03/10] brcm80211: smac: remove unused code for 40MHz channels
Date: Fri,  1 Jun 2012 11:15:29 -0500
Message-Id: <1338567336-12076-4-git-send-email-seth.forshee@canonical.com> (sfid-20120601_181550_343614_539CB5DF)
In-Reply-To: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
References: <1338567336-12076-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This code has been kept around in anticipation of adding support for
40MHz channels, but subsequent patches to better integrate with mac80211
regulatory support will render it completely broken. Therefore we should
go ahead and remove it.

Keep these changes separate from other cleanup patches in order to make
it easier to resurrect 40MHz channel support at some point in the
future.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  116 ---------------------
 1 file changed, 116 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 049d78f..089cc87 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -512,83 +512,6 @@ static const struct {
 	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
 };
 
-#ifdef SUPPORT_40MHZ
-/* 20MHz channel info for 40MHz pairing support */
-struct chan20_info {
-	u8 sb;
-	u8 adj_sbs;
-};
-
-/* indicates adjacent channels that are allowed for a 40 Mhz channel and
- * those that permitted by the HT
- */
-struct chan20_info chan20_info[] = {
-	/* 11b/11g */
-/* 0 */ {1, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 1 */ {2, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 2 */ {3, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 3 */ {4, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 4 */ {5, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 5 */ {6, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 6 */ {7, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 7 */ {8, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 8 */ {9, (CH_UPPER_SB | CH_LOWER_SB | CH_EWA_VALID)},
-/* 9 */ {10, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 10 */ {11, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 11 */ {12, (CH_LOWER_SB)},
-/* 12 */ {13, (CH_LOWER_SB)},
-/* 13 */ {14, (CH_LOWER_SB)},
-
-/* 11a japan high */
-/* 14 */ {34, (CH_UPPER_SB)},
-/* 15 */ {38, (CH_LOWER_SB)},
-/* 16 */ {42, (CH_LOWER_SB)},
-/* 17 */ {46, (CH_LOWER_SB)},
-
-/* 11a usa low */
-/* 18 */ {36, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 19 */ {40, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 20 */ {44, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 21 */ {48, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 22 */ {52, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 23 */ {56, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 24 */ {60, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 25 */ {64, (CH_LOWER_SB | CH_EWA_VALID)},
-
-/* 11a Europe */
-/* 26 */ {100, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 27 */ {104, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 28 */ {108, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 29 */ {112, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 30 */ {116, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 31 */ {120, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 32 */ {124, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 33 */ {128, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 34 */ {132, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 35 */ {136, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 36 */ {140, (CH_LOWER_SB)},
-
-/* 11a usa high, ref5 only */
-/* The 0x80 bit in pdiv means these are REF5, other entries are REF20 */
-/* 37 */ {149, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 38 */ {153, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 39 */ {157, (CH_UPPER_SB | CH_EWA_VALID)},
-/* 40 */ {161, (CH_LOWER_SB | CH_EWA_VALID)},
-/* 41 */ {165, (CH_LOWER_SB)},
-
-/* 11a japan */
-/* 42 */ {184, (CH_UPPER_SB)},
-/* 43 */ {188, (CH_LOWER_SB)},
-/* 44 */ {192, (CH_UPPER_SB)},
-/* 45 */ {196, (CH_LOWER_SB)},
-/* 46 */ {200, (CH_UPPER_SB)},
-/* 47 */ {204, (CH_LOWER_SB)},
-/* 48 */ {208, (CH_UPPER_SB)},
-/* 49 */ {212, (CH_LOWER_SB)},
-/* 50 */ {216, (CH_LOWER_SB)}
-};
-#endif				/* SUPPORT_40MHZ */
-
 static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table))
@@ -1449,45 +1372,6 @@ brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, u16 chspec,
 			return brcms_c_valid_channel20(wlc_cm->wlc->cmi,
 						       channel);
 	}
-#ifdef SUPPORT_40MHZ
-	/*
-	 * We know we are now checking a 40MHZ channel, so we should
-	 * only be here for NPHYS
-	 */
-	if (BRCMS_ISNPHY(wlc->band) || BRCMS_ISSSLPNPHY(wlc->band)) {
-		u8 upper_sideband = 0, idx;
-		u8 num_ch20_entries =
-		    sizeof(chan20_info) / sizeof(struct chan20_info);
-
-		if (!VALID_40CHANSPEC_IN_BAND(wlc, chspec_bandunit(chspec)))
-			return false;
-
-		if (dualband) {
-			if (!brcms_c_valid_channel20_db(wlc->cmi,
-							lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20_db(wlc->cmi,
-							upper_20_sb(channel)))
-				return false;
-		} else {
-			if (!brcms_c_valid_channel20(wlc->cmi,
-						     lower_20_sb(channel)) ||
-			    !brcms_c_valid_channel20(wlc->cmi,
-						     upper_20_sb(channel)))
-				return false;
-		}
-
-		/* find the lower sideband info in the sideband array */
-		for (idx = 0; idx < num_ch20_entries; idx++) {
-			if (chan20_info[idx].sb == lower_20_sb(channel))
-				upper_sideband = chan20_info[idx].adj_sbs;
-		}
-		/* check that the lower sideband allows an upper sideband */
-		if ((upper_sideband & (CH_UPPER_SB | CH_EWA_VALID)) ==
-		    (CH_UPPER_SB | CH_EWA_VALID))
-			return true;
-		return false;
-	}
-#endif				/* 40 MHZ */
 
 	return false;
 }
-- 
1.7.9.5

