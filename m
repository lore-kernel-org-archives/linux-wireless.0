Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1145 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896Ab1FALqv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/83] staging: brcm80211: removed unused timeout fields
 in wlc_protection
Date: Wed, 1 Jun 2011 13:44:49 +0200
Message-ID: <1306928768-7501-4-git-send-email-rvossen@broadcom.com> (sfid-20110601_134751_105072_666AB06B)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The structure definition wlc_protection contained a numbers of timeout
fields that were not used in the driver. These have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_main.h |   13 -------------
 1 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 193f73a..4d45972 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -208,19 +208,6 @@ struct wlc_protection {
 	s8 nongf_override;	/* override for use of GF protection */
 	s8 n_pam_override;	/* override for preamble: MM or GF */
 	bool n_obss;		/* indicated OBSS Non-HT STA present */
-
-	uint longpre_detect_timeout;	/* #sec until long preamble bcns gone */
-	uint barker_detect_timeout;	/* #sec until bcns signaling Barker long preamble */
-	/* only is gone */
-	uint ofdm_ibss_timeout;	/* #sec until ofdm IBSS beacons gone */
-	uint ofdm_ovlp_timeout;	/* #sec until ofdm overlapping BSS bcns gone */
-	uint nonerp_ibss_timeout;	/* #sec until nonerp IBSS beacons gone */
-	uint nonerp_ovlp_timeout;	/* #sec until nonerp overlapping BSS bcns gone */
-	uint g_ibss_timeout;	/* #sec until bcns signaling Use_Protection gone */
-	uint n_ibss_timeout;	/* #sec until bcns signaling Use_OFDM_Protection gone */
-	uint ht20in40_ovlp_timeout;	/* #sec until 20MHz overlapping OPMODE gone */
-	uint ht20in40_ibss_timeout;	/* #sec until 20MHz-only HT station bcns gone */
-	uint non_gf_ibss_timeout;	/* #sec until non-GF bcns gone */
 };
 
 /* anything affects the single/dual streams/antenna operation */
-- 
1.7.4.1


