Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2511 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab1FIOpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/21] staging: brcm80211: fix checkpatch errors from
 main.c
Date: Thu, 9 Jun 2011 16:44:59 +0200
Message-ID: <1307630701-9170-20-git-send-email-rvossen@broadcom.com> (sfid-20110609_164529_428795_73290FAB)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The softmac source file main.c was passed through checkpatch to see
what issues against coding style are still present. This patch removes
the checkpatch errors listed below.

ERROR: trailing whitespace
+^Imemcpy(wlc->default_bss->rateset.rates, rs.rates, $
--
ERROR: spaces required around that ':' (ctx:VxV)
+       pval = arg ? (int *)arg:NULL;
--

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e2d8d23..611873c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -278,7 +278,7 @@ const u8 wme_fifo2ac[] = { AC_BK, AC_BE, AC_VI, AC_VO, AC_BE, AC_BE };
 /* WME/802.1E Access Category to TX FIFO number */
 static const u8 wme_ac2fifo[] = { 1, 0, 2, 3 };
 
-static bool in_send_q = false;
+static bool in_send_q;
 
 /* Shared memory location index for various AC params */
 #define wme_shmemacindex(ac)	wme_ac2fifo[ac]
@@ -2363,7 +2363,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	/* Set default bss rateset */
 	wlc->default_bss->rateset.count = rs.count;
-	memcpy(wlc->default_bss->rateset.rates, rs.rates, 
+	memcpy(wlc->default_bss->rateset.rates, rs.rates,
 	       sizeof(wlc->default_bss->rateset.rates));
 
 	return ret;
@@ -2556,7 +2556,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	}
 
 	/* default argument is generic integer */
-	pval = arg ? (int *)arg:NULL;
+	pval = arg ? (int *)arg : NULL;
 
 	/* This will prevent the misaligned access */
 	if (pval && (u32) len >= sizeof(val))
-- 
1.7.4.1


