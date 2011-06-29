Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1914 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757529Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 017/119] staging: brcm80211: change FOREACH_BSS macro to
 remove checkpatch error
Date: Wed, 29 Jun 2011 16:46:41 -0700
Message-ID: <1309391303-22741-18-git-send-email-frankyl@broadcom.com> (sfid-20110630_014902_642152_7A3C7E20)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro FOREACH_BSS did an assignment inside the if condition. The
macro has been modified to get rid of the error.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index f7ebaf1..9aa74df 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -254,8 +254,9 @@ const u8 wlc_prio2prec_map[] = {
 
 /* As above for all non-NULL BSS configs */
 #define FOREACH_BSS(wlc, idx, cfg) \
-	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
-		if ((cfg = (wlc)->bsscfg[idx]))
+	for (idx = 0, cfg = (wlc)->bsscfg[idx]; \
+	     idx < WLC_MAXBSSCFG; cfg = (wlc)->bsscfg[++idx]) \
+		if (cfg)
 
 /* Sanity check for tx_prec_map and fifo synchup
  * Either there are some packets pending for the fifo, else if fifo is empty then
-- 
1.7.1


