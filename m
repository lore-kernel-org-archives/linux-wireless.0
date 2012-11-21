Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57222 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab2KUPYl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 10:24:41 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 1/2] brcmsmac: Remove unused wlc_prio2prec_map and _BRCMS_PREC_* constants
Date: Wed, 21 Nov 2012 09:24:30 -0600
Message-Id: <1353511471-5994-2-git-send-email-seth.forshee@canonical.com> (sfid-20121121_162445_030668_C61B68F0)
In-Reply-To: <1353511471-5994-1-git-send-email-seth.forshee@canonical.com>
References: <1353511471-5994-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes sparse warning:
drivers/net/wireless/brcm80211/brcmsmac/main.c:308:10: sparse: symbol 'wlc_prio2prec_map' was not declared. Should it be static?

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |   27 ------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 50c87d0..c21cee3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -123,21 +123,6 @@
 
 #define BRCMS_TEMPSENSE_PERIOD		10	/* 10 second timeout */
 
-/* precedences numbers for wlc queues. These are twice as may levels as
- * 802.1D priorities.
- * Odd numbers are used for HI priority traffic at same precedence levels
- * These constants are used ONLY by wlc_prio2prec_map.  Do not use them
- * elsewhere.
- */
-#define _BRCMS_PREC_NONE		0	/* None = - */
-#define _BRCMS_PREC_BK			2	/* BK - Background */
-#define _BRCMS_PREC_BE			4	/* BE - Best-effort */
-#define _BRCMS_PREC_EE			6	/* EE - Excellent-effort */
-#define _BRCMS_PREC_CL			8	/* CL - Controlled Load */
-#define _BRCMS_PREC_VI			10	/* Vi - Video */
-#define _BRCMS_PREC_VO			12	/* Vo - Voice */
-#define _BRCMS_PREC_NC			14	/* NC - Network Control */
-
 /* synthpu_dly times in us */
 #define SYNTHPU_DLY_APHY_US		3700
 #define SYNTHPU_DLY_BPHY_US		1050
@@ -301,18 +286,6 @@ static const u8 wme_ac2fifo[] = {
 	TX_AC_BK_FIFO
 };
 
-/* 802.1D Priority to precedence queue mapping */
-const u8 wlc_prio2prec_map[] = {
-	_BRCMS_PREC_BE,		/* 0 BE - Best-effort */
-	_BRCMS_PREC_BK,		/* 1 BK - Background */
-	_BRCMS_PREC_NONE,		/* 2 None = - */
-	_BRCMS_PREC_EE,		/* 3 EE - Excellent-effort */
-	_BRCMS_PREC_CL,		/* 4 CL - Controlled Load */
-	_BRCMS_PREC_VI,		/* 5 Vi - Video */
-	_BRCMS_PREC_VO,		/* 6 Vo - Voice */
-	_BRCMS_PREC_NC,		/* 7 NC - Network Control */
-};
-
 static const u16 xmtfifo_sz[][NFIFO] = {
 	/* corerev 17: 5120, 49152, 49152, 5376, 4352, 1280 */
 	{20, 192, 192, 21, 17, 5},
-- 
1.7.9.5

