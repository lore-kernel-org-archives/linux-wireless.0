Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2232 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1FIOp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/21] staging: brcm80211: remove regs variable from
 brcms_ioctl function
Date: Thu, 9 Jun 2011 16:44:46 +0200
Message-ID: <1307630701-9170-7-git-send-email-rvossen@broadcom.com> (sfid-20110609_164534_384336_3ADCA5B9)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

This variable was declared and initialized but never used so it has
been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c8d6679..28ae741 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -2515,7 +2515,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	int val, *pval;
 	bool bool_val;
 	int bcmerror;
-	d11regs_t *regs;
 	struct scb *nextscb;
 	bool ta_ok;
 	uint band;
@@ -2551,7 +2550,6 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	/* bool conversion to avoid duplication below */
 	bool_val = val != 0;
 	bcmerror = 0;
-	regs = wlc->regs;
 
 	if ((arg == NULL) || (len <= 0)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Command %d needs arguments\n",
-- 
1.7.4.1


