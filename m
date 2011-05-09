Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3452 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1EIOdn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:43 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 10/10] staging: brcm80211: fix checkpatch issue
 introduced in wlc_alloc.c
Date: Mon, 9 May 2011 16:33:29 +0200
Message-ID: <1304951609-2493-10-git-send-email-arend@broadcom.com> (sfid-20110509_163742_233518_DD240E8F)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "[59807ce] local used function made static" introduced a new
checkpatch warning which is fixed with this patch.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index f9fc644..d91cf5a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -137,7 +137,8 @@ static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg)
 	kfree(cfg);
 }
 
-static void wlc_bsscfg_ID_assign(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg)
+static void wlc_bsscfg_ID_assign(struct wlc_info *wlc,
+				 struct wlc_bsscfg *bsscfg)
 {
 	bsscfg->ID = wlc->next_bsscfg_ID;
 	wlc->next_bsscfg_ID++;
-- 
1.7.4.1


