Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3217 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1EIOdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Arend van Spriel" <arend@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/10] staging: brcm80211: local used function made
 static
Date: Mon, 9 May 2011 16:33:21 +0200
Message-ID: <1304951609-2493-2-git-send-email-arend@broadcom.com> (sfid-20110509_163742_699246_2E3DEE15)
In-Reply-To: <1304951609-2493-1-git-send-email-arend@broadcom.com>
References: <1304951609-2493-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In wlc_alloc.c function for setting ID field in struct wlc_bsscfg
was only used locally. It has been made static and removed from
header file.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Roland Vossen <rvossen@broadcoom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c  |    4 ++--
 drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h |    3 ---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index d02364b..f9fc644 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -43,7 +43,7 @@ static struct wlc_pub *wlc_pub_malloc(uint unit,
 static void wlc_pub_mfree(struct wlc_pub *pub);
 static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid);
 
-void wlc_tunables_init(wlc_tunables_t *tunables, uint devid)
+static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
 	tunables->nrxd = NRXD;
@@ -137,7 +137,7 @@ static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg)
 	kfree(cfg);
 }
 
-void wlc_bsscfg_ID_assign(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg)
+static void wlc_bsscfg_ID_assign(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg)
 {
 	bsscfg->ID = wlc->next_bsscfg_ID;
 	wlc->next_bsscfg_ID++;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h b/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
index bbcff4f..2572541 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bsscfg.h
@@ -122,9 +122,6 @@ struct wlc_bsscfg {
 #define HWBCN_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_BCN) != 0)
 #define HWPRB_ENAB(cfg)		(((cfg)->flags & WLC_BSSCFG_HW_PRB) != 0)
 
-extern void wlc_bsscfg_ID_assign(struct wlc_info *wlc,
-				 struct wlc_bsscfg *bsscfg);
-
 /* Extend N_ENAB to per-BSS */
 #define BSS_N_ENAB(wlc, cfg) \
 	(N_ENAB((wlc)->pub) && !((cfg)->flags & WLC_BSSCFG_11N_DISABLE))
-- 
1.7.4.1


