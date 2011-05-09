Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3216 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab1EIOdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 05/10] staging: brcm80211: remove unused function from
 wlc_phy_cmn.c
Date: Mon, 9 May 2011 16:33:24 +0200
Message-ID: <1304951609-2493-5-git-send-email-arend@broadcom.com> (sfid-20110509_163742_394223_3C168BCB)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function wlc_phy_qdiv_roundup() was not used and has been
removed.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   25 --------------------
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    2 -
 2 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index e9f3972..f35a18c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -3312,31 +3312,6 @@ wlc_phy_get_pwrdet_offsets(phy_info_t *pi, s8 *cckoffset, s8 *ofdmoffset)
 	*ofdmoffset = 0;
 }
 
-u32 wlc_phy_qdiv_roundup(u32 dividend, u32 divisor, u8 precision)
-{
-	u32 quotient, remainder, roundup, rbit;
-
-	quotient = dividend / divisor;
-	remainder = dividend % divisor;
-	rbit = divisor & 1;
-	roundup = (divisor >> 1) + rbit;
-
-	while (precision--) {
-		quotient <<= 1;
-		if (remainder >= roundup) {
-			quotient++;
-			remainder = ((remainder - roundup) << 1) + rbit;
-		} else {
-			remainder <<= 1;
-		}
-	}
-
-	if (remainder >= roundup)
-		quotient++;
-
-	return quotient;
-}
-
 s8 wlc_phy_upd_rssi_offset(phy_info_t *pi, s8 rssi, chanspec_t chanspec)
 {
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 3d1cd34..77c6106 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -1094,8 +1094,6 @@ extern void wlc_lcnphy_epa_switch(phy_info_t *pi, bool mode);
 extern void wlc_2064_vco_cal(phy_info_t *pi);
 
 extern void wlc_phy_txpower_recalc_target(phy_info_t *pi);
-extern u32 wlc_phy_qdiv_roundup(u32 dividend, u32 divisor,
-				   u8 precision);
 
 #define LCNPHY_TBL_ID_PAPDCOMPDELTATBL	0x18
 #define LCNPHY_TX_POWER_TABLE_SIZE	128
-- 
1.7.4.1


