Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2DHTNJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Apr 2012 15:13:09 -0400
Received: by mail-iy0-f174.google.com with SMTP id z16so5092406iag.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Apr 2012 12:13:09 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Forest Bond <forest.bond@rapidrollout.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/2 V3] rtl8192de: Clean up and fix 92D cut version constants and macros.
Date: Sun,  8 Apr 2012 14:12:33 -0500
Message-Id: <1333912354-16983-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120408_211340_144129_5B5CE6DD)
In-Reply-To: <1333912354-16983-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1333912354-16983-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Forest Bond <forest.bond@rapidrollout.com>

The previous definitions included both {B,C,D,E}_CUT_VERSION and
CHIP_92D_{C,D}_CUT with conflicting values for the C and D cut versions,
and literal hex values were used in the IS_92D_{C,D,E}_CUT macros.  So
we clean all this up and in doing so enable cut-specific code paths for
cuts C and D, which would not have been executed because the
CHIP_92D_{C,D}_CUT constants were wrong and the cut version was thus
recorded incorrectly.

Signed-off-by: Forest Bond <forest.bond@rapidrollout.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/def.h |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/def.h b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
index eafdf76..939c905 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/def.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/def.h
@@ -151,9 +151,6 @@ enum version_8192d {
 
 /* for 92D */
 #define CHIP_92D_SINGLEPHY		BIT(9)
-#define C_CUT_VERSION			BIT(13)
-#define D_CUT_VERSION			((BIT(12)|BIT(13)))
-#define E_CUT_VERSION			BIT(14)
 
 /* Chip specific */
 #define CHIP_BONDING_IDENTIFIER(_value)	(((_value)>>22)&0x3)
@@ -173,7 +170,10 @@ enum version_8192d {
 #define RF_TYPE_1T2R			BIT(4)
 #define RF_TYPE_2T2R			BIT(5)
 #define CHIP_VENDOR_UMC			BIT(7)
-#define B_CUT_VERSION			BIT(12)
+#define CHIP_92D_B_CUT			BIT(12)
+#define CHIP_92D_C_CUT			BIT(13)
+#define CHIP_92D_D_CUT			(BIT(13)|BIT(12))
+#define CHIP_92D_E_CUT			BIT(14)
 
 /* MASK */
 #define IC_TYPE_MASK			(BIT(0)|BIT(1)|BIT(2))
@@ -205,15 +205,13 @@ enum version_8192d {
 					 CHIP_92D) ? true : false)
 #define IS_92D_C_CUT(version)		((IS_92D(version)) ?		\
 				 ((GET_CVID_CUT_VERSION(version) ==	\
-				 0x2000) ? true : false) : false)
+				 CHIP_92D_C_CUT) ? true : false) : false)
 #define IS_92D_D_CUT(version)			((IS_92D(version)) ?	\
 				 ((GET_CVID_CUT_VERSION(version) ==	\
-				 0x3000) ? true : false) : false)
+				 CHIP_92D_D_CUT) ? true : false) : false)
 #define IS_92D_E_CUT(version)		((IS_92D(version)) ?		\
 				 ((GET_CVID_CUT_VERSION(version) ==	\
-				 0x4000) ? true : false) : false)
-#define CHIP_92D_C_CUT			BIT(10)
-#define CHIP_92D_D_CUT			BIT(11)
+				 CHIP_92D_E_CUT) ? true : false) : false)
 
 enum rf_optype {
 	RF_OP_BY_SW_3WIRE = 0,
-- 
1.7.10

