Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1185 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/30] staging: brcm80211: removed static function
 declarations in alloc.c
Date: Thu, 1 Sep 2011 11:16:52 +0200
Message-ID: <1314868640-9425-3-git-send-email-rvossen@broadcom.com> (sfid-20110901_111750_750188_7B952B84)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c |   39 +++++++++++----------------
 1 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 7dc2875..52ca7e3 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -1,4 +1,4 @@
-/*
+#/*
  * Copyright (c) 2010 Broadcom Corporation
  *
  * Permission to use, copy, modify, and/or distribute this software for any
@@ -20,13 +20,6 @@
 #include "main.h"
 #include "alloc.h"
 
-static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit);
-static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg);
-static struct brcms_pub *brcms_c_pub_malloc(uint unit,
-				      uint *err, uint devid);
-static void brcms_c_pub_mfree(struct brcms_pub *pub);
-static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid);
-
 static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
@@ -45,6 +38,16 @@ static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
 	tunables->txsbnd = TXSBND;
 }
 
+static void brcms_c_pub_mfree(struct brcms_pub *pub)
+{
+	if (pub == NULL)
+		return;
+
+	kfree(pub->multicast);
+	kfree(pub->tunables);
+	kfree(pub);
+}
+
 static struct brcms_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 {
 	struct brcms_pub *pub;
@@ -77,14 +80,14 @@ static struct brcms_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 	return NULL;
 }
 
-static void brcms_c_pub_mfree(struct brcms_pub *pub)
+static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
 {
-	if (pub == NULL)
+	if (cfg == NULL)
 		return;
 
-	kfree(pub->multicast);
-	kfree(pub->tunables);
-	kfree(pub);
+	kfree(cfg->maclist);
+	kfree(cfg->current_bss);
+	kfree(cfg);
 }
 
 static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
@@ -106,16 +109,6 @@ static struct brcms_bss_cfg *brcms_c_bsscfg_malloc(uint unit)
 	return NULL;
 }
 
-static void brcms_c_bsscfg_mfree(struct brcms_bss_cfg *cfg)
-{
-	if (cfg == NULL)
-		return;
-
-	kfree(cfg->maclist);
-	kfree(cfg->current_bss);
-	kfree(cfg);
-}
-
 static void brcms_c_bsscfg_ID_assign(struct brcms_c_info *wlc,
 				 struct brcms_bss_cfg *bsscfg)
 {
-- 
1.7.4.1


