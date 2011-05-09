Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3418 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab1EIOdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/10] staging: brcm80211: make use of fls bit operation
 in wlc_phy_compute_dB
Date: Mon, 9 May 2011 16:33:27 +0200
Message-ID: <1304951609-2493-8-git-send-email-arend@broadcom.com> (sfid-20110509_163741_764946_A1A1F9CC)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_phy_compute_dB converts absolute power value to dB implementing
a fixed point calculation for 10*log10(x). It does this by determining
the most significant bit for value x. This can be done using the fls()
bit operation, which has arch specific and possibly more efficient
implementation.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 446dc84..6cba4df 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -18,10 +18,12 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <bcmdefs.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+
+#include <bcmdefs.h>
 #include <bcmnvram.h>
 #include <sbchipc.h>
 #include <bcmdevs.h>
@@ -2746,20 +2748,15 @@ s8 lcnphy_gain_index_offset_for_pkt_rssi[] = {
 
 void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 {
-	u8 shift_ct, lsb, msb, secondmsb, i;
+	u8 msb, secondmsb, i;
 	u32 tmp;
 
 	for (i = 0; i < core; i++) {
+		secondmsb = 0;
 		tmp = cmplx_pwr[i];
-		shift_ct = msb = secondmsb = 0;
-		while (tmp != 0) {
-			tmp = tmp >> 1;
-			shift_ct++;
-			lsb = (u8) (tmp & 1);
-			if (lsb == 1)
-				msb = shift_ct;
-		}
-		secondmsb = (u8) ((cmplx_pwr[i] >> (msb - 1)) & 1);
+		msb = fls(tmp);
+		if (msb)
+			secondmsb = (u8) ((tmp >> (--msb - 1)) & 1);
 		p_cmplx_pwr_dB[i] = (s8) (3 * msb + 2 * secondmsb);
 	}
 }
-- 
1.7.4.1


