Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3693 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab1HZNTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Aug 2011 09:19:51 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 03/13] staging: brcm80211: remove usage of macro
 WL11N_20MHZONLY
Date: Fri, 26 Aug 2011 15:19:30 +0200
Message-ID: <1314364780-9462-4-git-send-email-rvossen@broadcom.com> (sfid-20110826_152045_400456_4B8EE9C1)
In-Reply-To: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
References: <1314364780-9462-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro WL11N_20MHZONLY is never defined so code #ifdef'ed by
it has been removed.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/include/brcmu_wifi.h |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/brcm80211/include/brcmu_wifi.h b/drivers/staging/brcm80211/include/brcmu_wifi.h
index 717d885..0ab432d 100644
--- a/drivers/staging/brcm80211/include/brcmu_wifi.h
+++ b/drivers/staging/brcm80211/include/brcmu_wifi.h
@@ -96,18 +96,6 @@
 #define CHSPEC_CHANNEL(chspec)	((u8)((chspec) & WL_CHANSPEC_CHAN_MASK))
 #define CHSPEC_BAND(chspec)	((chspec) & WL_CHANSPEC_BAND_MASK)
 
-#ifdef WL11N_20MHZONLY
-
-#define CHSPEC_CTL_SB(chspec)	WL_CHANSPEC_CTL_SB_NONE
-#define CHSPEC_BW(chspec)	WL_CHANSPEC_BW_20
-#define CHSPEC_IS10(chspec)	0
-#define CHSPEC_IS20(chspec)	1
-#ifndef CHSPEC_IS40
-#define CHSPEC_IS40(chspec)	0
-#endif
-
-#else				/* !WL11N_20MHZONLY */
-
 #define CHSPEC_CTL_SB(chspec)	((chspec) & WL_CHANSPEC_CTL_SB_MASK)
 #define CHSPEC_BW(chspec)	((chspec) & WL_CHANSPEC_BW_MASK)
 
@@ -122,8 +110,6 @@
 	(((chspec) & WL_CHANSPEC_BW_MASK) == WL_CHANSPEC_BW_40)
 #endif
 
-#endif				/* !WL11N_20MHZONLY */
-
 #define CHSPEC_IS5G(chspec) \
 	(((chspec) & WL_CHANSPEC_BAND_MASK) == WL_CHANSPEC_BAND_5G)
 
-- 
1.7.4.1


