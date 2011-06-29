Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2069 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757974Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 032/119] staging: brcm80211: reorg
 brcms_c_validboardtype for clarity
Date: Wed, 29 Jun 2011 16:46:56 -0700
Message-ID: <1309391303-22741-33-git-send-email-frankyl@broadcom.com> (sfid-20110630_015026_786783_6EAD7376)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

The structure of the function made it difficult to understand, so reorganize it
to make it clearer.

Reported-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/bmac.c |   35 ++++++++++++++++------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index f44f581..4a220d4 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -1905,28 +1905,33 @@ static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw)
 	return true;
 }
 
+/* Validate some board info parameters */
 static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
 {
-	bool goodboard = true;
 	uint boardrev = wlc_hw->boardrev;
 
+	/* 4 bits each for board type, major, minor, and tiny version */
+	uint brt = (boardrev & 0xf000) >> 12;
+	uint b0 = (boardrev & 0xf00) >> 8;
+	uint b1 = (boardrev & 0xf0) >> 4;
+	uint b2 = boardrev & 0xf;
+
+	/* voards from other vendors are always considered valid */
+	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
+		return true;
+
+	/* do some boardrev sanity checks when boardvendor is Broadcom */
 	if (boardrev == 0)
-		goodboard = false;
-	else if (boardrev > 0xff) {
-		uint brt = (boardrev & 0xf000) >> 12;
-		uint b0 = (boardrev & 0xf00) >> 8;
-		uint b1 = (boardrev & 0xf0) >> 4;
-		uint b2 = boardrev & 0xf;
+		return false;
 
-		if ((brt > 2) || (brt == 0) || (b0 > 9) || (b0 == 0) || (b1 > 9)
-		    || (b2 > 9))
-			goodboard = false;
-	}
+	if (boardrev <= 0xff)
+		return true;
 
-	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
-		return goodboard;
+	if ((brt > 2) || (brt == 0) || (b0 > 9) || (b0 == 0) || (b1 > 9)
+		|| (b2 > 9))
+		return false;
 
-	return goodboard;
+	return true;
 }
 
 static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw)
-- 
1.7.1


