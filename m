Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3786 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/20] staging: brcm80211: removed softmac files
 alloc.c/alloc.h
Date: Mon, 12 Sep 2011 12:15:03 +0200
Message-ID: <1315822504-24210-20-git-send-email-rvossen@broadcom.com> (sfid-20110912_121549_837384_40A3D59B)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alloc.c does not contain enough functionality anymore to warrant
its own file. Moved functionality into main.c

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/Makefile |    1 -
 drivers/staging/brcm80211/brcmsmac/alloc.c  |  181 ---------------------------
 drivers/staging/brcm80211/brcmsmac/alloc.h  |   19 ---
 drivers/staging/brcm80211/brcmsmac/main.c   |  159 +++++++++++++++++++++++-
 4 files changed, 158 insertions(+), 202 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/alloc.c
 delete mode 100644 drivers/staging/brcm80211/brcmsmac/alloc.h

diff --git a/drivers/staging/brcm80211/brcmsmac/Makefile b/drivers/staging/brcm80211/brcmsmac/Makefile
index eee2fe3..8fdca2e 100644
--- a/drivers/staging/brcm80211/brcmsmac/Makefile
+++ b/drivers/staging/brcm80211/brcmsmac/Makefile
@@ -23,7 +23,6 @@ ccflags-y :=				\
 BRCMSMAC_OFILES := \
 	mac80211_if.o \
 	ucode_loader.o \
-	alloc.o \
 	ampdu.o \
 	antsel.o \
 	channel.o \
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
deleted file mode 100644
index b99087d..0000000
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ /dev/null
@@ -1,181 +0,0 @@
-#/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-#include <brcmu_utils.h>
-#include "types.h"
-#include "pub.h"
-#include "main.h"
-#include "alloc.h"
-
-static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
-{
-	if (cfg == NULL)
-		return;
-
-	kfree(cfg->current_bss);
-	kfree(cfg);
-}
-
-static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
-{
-	struct brcms_bss_cfg *cfg;
-
-	cfg = kzalloc(sizeof(struct brcms_bss_cfg), GFP_ATOMIC);
-	if (cfg == NULL)
-		goto fail;
-
-	cfg->current_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
-	if (cfg->current_bss == NULL)
-		goto fail;
-
-	return cfg;
-
- fail:
-	brcms_c_bsscfg_mfree(cfg);
-	return NULL;
-}
-
-/*
- * The common driver entry routine. Error codes should be unique
- */
-struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
-{
-	struct brcms_c_info *wlc;
-
-	wlc = kzalloc(sizeof(struct brcms_c_info), GFP_ATOMIC);
-	if (wlc == NULL) {
-		*err = 1002;
-		goto fail;
-	}
-
-	/* allocate struct brcms_c_pub state structure */
-	wlc->pub = kzalloc(sizeof(struct brcms_pub), GFP_ATOMIC);
-	if (wlc->pub == NULL) {
-		*err = 1003;
-		goto fail;
-	}
-	wlc->pub->wlc = wlc;
-
-	/* allocate struct brcms_hardware state structure */
-
-	wlc->hw = kzalloc(sizeof(struct brcms_hardware), GFP_ATOMIC);
-	if (wlc->hw == NULL) {
-		*err = 1005;
-		goto fail;
-	}
-	wlc->hw->wlc = wlc;
-
-	wlc->hw->bandstate[0] =
-		kzalloc(sizeof(struct brcms_hw_band) * MAXBANDS, GFP_ATOMIC);
-	if (wlc->hw->bandstate[0] == NULL) {
-		*err = 1006;
-		goto fail;
-	} else {
-		int i;
-
-		for (i = 1; i < MAXBANDS; i++)
-			wlc->hw->bandstate[i] = (struct brcms_hw_band *)
-			    ((unsigned long)wlc->hw->bandstate[0] +
-			     (sizeof(struct brcms_hw_band) * i));
-	}
-
-	wlc->modulecb =
-		kzalloc(sizeof(struct modulecb) * BRCMS_MAXMODULES, GFP_ATOMIC);
-	if (wlc->modulecb == NULL) {
-		*err = 1009;
-		goto fail;
-	}
-
-	wlc->default_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
-	if (wlc->default_bss == NULL) {
-		*err = 1010;
-		goto fail;
-	}
-
-	wlc->cfg = brcms_c_bsscfg_malloc(unit);
-	if (wlc->cfg == NULL) {
-		*err = 1011;
-		goto fail;
-	}
-
-	wlc->protection = kzalloc(sizeof(struct brcms_protection),
-				  GFP_ATOMIC);
-	if (wlc->protection == NULL) {
-		*err = 1016;
-		goto fail;
-	}
-
-	wlc->stf = kzalloc(sizeof(struct brcms_stf), GFP_ATOMIC);
-	if (wlc->stf == NULL) {
-		*err = 1017;
-		goto fail;
-	}
-
-	wlc->bandstate[0] =
-		kzalloc(sizeof(struct brcms_band)*MAXBANDS, GFP_ATOMIC);
-	if (wlc->bandstate[0] == NULL) {
-		*err = 1025;
-		goto fail;
-	} else {
-		int i;
-
-		for (i = 1; i < MAXBANDS; i++)
-			wlc->bandstate[i] = (struct brcms_band *)
-				((unsigned long)wlc->bandstate[0]
-				+ (sizeof(struct brcms_band)*i));
-	}
-
-	wlc->corestate = kzalloc(sizeof(struct brcms_core), GFP_ATOMIC);
-	if (wlc->corestate == NULL) {
-		*err = 1026;
-		goto fail;
-	}
-
-	wlc->corestate->macstat_snapshot =
-		kzalloc(sizeof(struct macstat), GFP_ATOMIC);
-	if (wlc->corestate->macstat_snapshot == NULL) {
-		*err = 1027;
-		goto fail;
-	}
-
-	return wlc;
-
- fail:
-	brcms_c_detach_mfree(wlc);
-	return NULL;
-}
-
-void brcms_c_detach_mfree(struct brcms_c_info *wlc)
-{
-	if (wlc == NULL)
-		return;
-
-	brcms_c_bsscfg_mfree(wlc->cfg);
-	kfree(wlc->pub);
-	kfree(wlc->modulecb);
-	kfree(wlc->default_bss);
-	kfree(wlc->protection);
-	kfree(wlc->stf);
-	kfree(wlc->bandstate[0]);
-	kfree(wlc->corestate->macstat_snapshot);
-	kfree(wlc->corestate);
-	kfree(wlc->hw->bandstate[0]);
-	kfree(wlc->hw);
-
-	/* free the wlc */
-	kfree(wlc);
-	wlc = NULL;
-}
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.h b/drivers/staging/brcm80211/brcmsmac/alloc.h
deleted file mode 100644
index f465d30..0000000
--- a/drivers/staging/brcm80211/brcmsmac/alloc.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-
-extern struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err,
-						  uint devid);
-extern void brcms_c_detach_mfree(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index a1f5e24..2b5d4de 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -27,7 +27,6 @@
 #include "antsel.h"
 #include "stf.h"
 #include "ampdu.h"
-#include "alloc.h"
 #include "mac80211_if.h"
 #include "ucode_loader.h"
 #include "main.h"
@@ -503,6 +502,164 @@ static const char fifo_names[6][0];
 static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
+static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
+{
+	if (cfg == NULL)
+		return;
+
+	kfree(cfg->current_bss);
+	kfree(cfg);
+}
+
+static void brcms_c_detach_mfree(struct brcms_c_info *wlc)
+{
+	if (wlc == NULL)
+		return;
+
+	brcms_c_bsscfg_mfree(wlc->cfg);
+	kfree(wlc->pub);
+	kfree(wlc->modulecb);
+	kfree(wlc->default_bss);
+	kfree(wlc->protection);
+	kfree(wlc->stf);
+	kfree(wlc->bandstate[0]);
+	kfree(wlc->corestate->macstat_snapshot);
+	kfree(wlc->corestate);
+	kfree(wlc->hw->bandstate[0]);
+	kfree(wlc->hw);
+
+	/* free the wlc */
+	kfree(wlc);
+	wlc = NULL;
+}
+
+static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
+{
+	struct brcms_bss_cfg *cfg;
+
+	cfg = kzalloc(sizeof(struct brcms_bss_cfg), GFP_ATOMIC);
+	if (cfg == NULL)
+		goto fail;
+
+	cfg->current_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
+	if (cfg->current_bss == NULL)
+		goto fail;
+
+	return cfg;
+
+ fail:
+	brcms_c_bsscfg_mfree(cfg);
+	return NULL;
+}
+
+static struct brcms_c_info *
+brcms_c_attach_malloc(uint unit, uint *err, uint devid)
+{
+	struct brcms_c_info *wlc;
+
+	wlc = kzalloc(sizeof(struct brcms_c_info), GFP_ATOMIC);
+	if (wlc == NULL) {
+		*err = 1002;
+		goto fail;
+	}
+
+	/* allocate struct brcms_c_pub state structure */
+	wlc->pub = kzalloc(sizeof(struct brcms_pub), GFP_ATOMIC);
+	if (wlc->pub == NULL) {
+		*err = 1003;
+		goto fail;
+	}
+	wlc->pub->wlc = wlc;
+
+	/* allocate struct brcms_hardware state structure */
+
+	wlc->hw = kzalloc(sizeof(struct brcms_hardware), GFP_ATOMIC);
+	if (wlc->hw == NULL) {
+		*err = 1005;
+		goto fail;
+	}
+	wlc->hw->wlc = wlc;
+
+	wlc->hw->bandstate[0] =
+		kzalloc(sizeof(struct brcms_hw_band) * MAXBANDS, GFP_ATOMIC);
+	if (wlc->hw->bandstate[0] == NULL) {
+		*err = 1006;
+		goto fail;
+	} else {
+		int i;
+
+		for (i = 1; i < MAXBANDS; i++)
+			wlc->hw->bandstate[i] = (struct brcms_hw_band *)
+			    ((unsigned long)wlc->hw->bandstate[0] +
+			     (sizeof(struct brcms_hw_band) * i));
+	}
+
+	wlc->modulecb =
+		kzalloc(sizeof(struct modulecb) * BRCMS_MAXMODULES, GFP_ATOMIC);
+	if (wlc->modulecb == NULL) {
+		*err = 1009;
+		goto fail;
+	}
+
+	wlc->default_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
+	if (wlc->default_bss == NULL) {
+		*err = 1010;
+		goto fail;
+	}
+
+	wlc->cfg = brcms_c_bsscfg_malloc(unit);
+	if (wlc->cfg == NULL) {
+		*err = 1011;
+		goto fail;
+	}
+
+	wlc->protection = kzalloc(sizeof(struct brcms_protection),
+				  GFP_ATOMIC);
+	if (wlc->protection == NULL) {
+		*err = 1016;
+		goto fail;
+	}
+
+	wlc->stf = kzalloc(sizeof(struct brcms_stf), GFP_ATOMIC);
+	if (wlc->stf == NULL) {
+		*err = 1017;
+		goto fail;
+	}
+
+	wlc->bandstate[0] =
+		kzalloc(sizeof(struct brcms_band)*MAXBANDS, GFP_ATOMIC);
+	if (wlc->bandstate[0] == NULL) {
+		*err = 1025;
+		goto fail;
+	} else {
+		int i;
+
+		for (i = 1; i < MAXBANDS; i++)
+			wlc->bandstate[i] = (struct brcms_band *)
+				((unsigned long)wlc->bandstate[0]
+				+ (sizeof(struct brcms_band)*i));
+	}
+
+	wlc->corestate = kzalloc(sizeof(struct brcms_core), GFP_ATOMIC);
+	if (wlc->corestate == NULL) {
+		*err = 1026;
+		goto fail;
+	}
+
+	wlc->corestate->macstat_snapshot =
+		kzalloc(sizeof(struct macstat), GFP_ATOMIC);
+	if (wlc->corestate->macstat_snapshot == NULL) {
+		*err = 1027;
+		goto fail;
+	}
+
+	return wlc;
+
+ fail:
+	brcms_c_detach_mfree(wlc);
+	return NULL;
+}
+
 /*
  * Update the slot timing for standard 11b/g (20us slots)
  * or shortslot 11g (9us slots)
-- 
1.7.4.1


