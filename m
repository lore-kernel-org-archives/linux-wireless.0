Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2289 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1ECJhE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:37:04 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 61/61] staging: brcm80211: removed function wlc_calloc()
Date: Tue, 3 May 2011 11:36:01 +0200
Message-ID: <1304415361-7813-62-git-send-email-arend@broadcom.com> (sfid-20110503_114019_950436_6BFC5A3A)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. After the previous patches, this function does not have
any added value anymore.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.c |   62 +++++++++--------------
 drivers/staging/brcm80211/brcmsmac/wlc_alloc.h |    2 -
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |    2 +-
 3 files changed, 25 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
index dc43227..d02364b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.c
@@ -43,14 +43,6 @@ static struct wlc_pub *wlc_pub_malloc(uint unit,
 static void wlc_pub_mfree(struct wlc_pub *pub);
 static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid);
 
-void *wlc_calloc(uint unit, uint size)
-{
-	void *item;
-
-	item = kzalloc(size, GFP_ATOMIC);
-	return item;
-}
-
 void wlc_tunables_init(wlc_tunables_t *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
@@ -73,14 +65,13 @@ static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
 {
 	struct wlc_pub *pub;
 
-	pub = wlc_calloc(unit, sizeof(struct wlc_pub));
+	pub = kzalloc(sizeof(struct wlc_pub), GFP_ATOMIC);
 	if (pub == NULL) {
 		*err = 1001;
 		goto fail;
 	}
 
-	pub->tunables = wlc_calloc(unit,
-		sizeof(wlc_tunables_t));
+	pub->tunables = kzalloc(sizeof(wlc_tunables_t), GFP_ATOMIC);
 	if (pub->tunables == NULL) {
 		*err = 1028;
 		goto fail;
@@ -89,12 +80,11 @@ static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
 	/* need to init the tunables now */
 	wlc_tunables_init(pub->tunables, devid);
 
-	pub->_cnt = wlc_calloc(unit, sizeof(struct wl_cnt));
+	pub->_cnt =  kzalloc(sizeof(struct wl_cnt), GFP_ATOMIC);
 	if (pub->_cnt == NULL)
 		goto fail;
 
-	pub->multicast = (u8 *)wlc_calloc(unit,
-		(ETH_ALEN * MAXMULTILIST));
+	pub->multicast = kzalloc(ETH_ALEN * MAXMULTILIST, GFP_ATOMIC);
 	if (pub->multicast == NULL) {
 		*err = 1003;
 		goto fail;
@@ -122,12 +112,11 @@ static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit)
 {
 	struct wlc_bsscfg *cfg;
 
-	cfg = (struct wlc_bsscfg *) wlc_calloc(unit, sizeof(struct wlc_bsscfg));
+	cfg = kzalloc(sizeof(struct wlc_bsscfg), GFP_ATOMIC);
 	if (cfg == NULL)
 		goto fail;
 
-	cfg->current_bss = (wlc_bss_info_t *)wlc_calloc(unit,
-		sizeof(wlc_bss_info_t));
+	cfg->current_bss = kzalloc(sizeof(wlc_bss_info_t), GFP_ATOMIC);
 	if (cfg->current_bss == NULL)
 		goto fail;
 
@@ -161,7 +150,7 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 {
 	struct wlc_info *wlc;
 
-	wlc = (struct wlc_info *) wlc_calloc(unit, sizeof(struct wlc_info));
+	wlc = kzalloc(sizeof(struct wlc_info), GFP_ATOMIC);
 	if (wlc == NULL) {
 		*err = 1002;
 		goto fail;
@@ -179,16 +168,15 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 
 	/* allocate struct wlc_hw_info state structure */
 
-	wlc->hw = (struct wlc_hw_info *)wlc_calloc(unit,
-			sizeof(struct wlc_hw_info));
+	wlc->hw = kzalloc(sizeof(struct wlc_hw_info), GFP_ATOMIC);
 	if (wlc->hw == NULL) {
 		*err = 1005;
 		goto fail;
 	}
 	wlc->hw->wlc = wlc;
 
-	wlc->hw->bandstate[0] = wlc_calloc(unit,
-		(sizeof(struct wlc_hwband) * MAXBANDS));
+	wlc->hw->bandstate[0] =
+		kzalloc(sizeof(struct wlc_hwband) * MAXBANDS, GFP_ATOMIC);
 	if (wlc->hw->bandstate[0] == NULL) {
 		*err = 1006;
 		goto fail;
@@ -202,15 +190,14 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		}
 	}
 
-	wlc->modulecb = wlc_calloc(unit,
-		sizeof(struct modulecb) * WLC_MAXMODULES);
+	wlc->modulecb =
+		kzalloc(sizeof(struct modulecb) * WLC_MAXMODULES, GFP_ATOMIC);
 	if (wlc->modulecb == NULL) {
 		*err = 1009;
 		goto fail;
 	}
 
-	wlc->default_bss = (wlc_bss_info_t *)wlc_calloc(unit,
-		sizeof(wlc_bss_info_t));
+	wlc->default_bss = kzalloc(sizeof(wlc_bss_info_t), GFP_ATOMIC);
 	if (wlc->default_bss == NULL) {
 		*err = 1010;
 		goto fail;
@@ -223,15 +210,16 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	}
 	wlc_bsscfg_ID_assign(wlc, wlc->cfg);
 
-	wlc->pkt_callback = wlc_calloc(unit,
-		(sizeof(struct pkt_cb) * (wlc->pub->tunables->maxpktcb + 1)));
+	wlc->pkt_callback = kzalloc(sizeof(struct pkt_cb) *
+				    (wlc->pub->tunables->maxpktcb + 1),
+				    GFP_ATOMIC);
 	if (wlc->pkt_callback == NULL) {
 		*err = 1013;
 		goto fail;
 	}
 
-	wlc->wsec_def_keys[0] = (wsec_key_t *)wlc_calloc(unit,
-		(sizeof(wsec_key_t) * WLC_DEFAULT_KEYS));
+	wlc->wsec_def_keys[0] =
+		kzalloc(sizeof(wsec_key_t) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
 	if (wlc->wsec_def_keys[0] == NULL) {
 		*err = 1015;
 		goto fail;
@@ -244,21 +232,20 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		}
 	}
 
-	wlc->protection = wlc_calloc(unit,
-		sizeof(struct wlc_protection));
+	wlc->protection = kzalloc(sizeof(struct wlc_protection), GFP_ATOMIC);
 	if (wlc->protection == NULL) {
 		*err = 1016;
 		goto fail;
 	}
 
-	wlc->stf = wlc_calloc(unit, sizeof(struct wlc_stf));
+	wlc->stf = kzalloc(sizeof(struct wlc_stf), GFP_ATOMIC);
 	if (wlc->stf == NULL) {
 		*err = 1017;
 		goto fail;
 	}
 
-	wlc->bandstate[0] = (struct wlcband *)wlc_calloc(unit,
-				(sizeof(struct wlcband)*MAXBANDS));
+	wlc->bandstate[0] =
+		kzalloc(sizeof(struct wlcband)*MAXBANDS, GFP_ATOMIC);
 	if (wlc->bandstate[0] == NULL) {
 		*err = 1025;
 		goto fail;
@@ -272,15 +259,14 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		}
 	}
 
-	wlc->corestate = (struct wlccore *)wlc_calloc(unit,
-						      sizeof(struct wlccore));
+	wlc->corestate = kzalloc(sizeof(struct wlccore), GFP_ATOMIC);
 	if (wlc->corestate == NULL) {
 		*err = 1026;
 		goto fail;
 	}
 
 	wlc->corestate->macstat_snapshot =
-		(macstat_t *)wlc_calloc(unit, sizeof(macstat_t));
+		kzalloc(sizeof(macstat_t), GFP_ATOMIC);
 	if (wlc->corestate->macstat_snapshot == NULL) {
 		*err = 1027;
 		goto fail;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.h b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.h
index 1fb7430..95f951e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_alloc.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_alloc.h
@@ -14,7 +14,5 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-extern void *wlc_calloc(uint unit, uint size);
-
 extern struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid);
 extern void wlc_detach_mfree(struct wlc_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 6edaa09..4d8fa34 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -8040,7 +8040,7 @@ static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
 {
 	struct wlc_txq_info *qi, *p;
 
-	qi = wlc_calloc(wlc->pub->unit, sizeof(struct wlc_txq_info));
+	qi = kzalloc(sizeof(struct wlc_txq_info), GFP_ATOMIC);
 	if (qi != NULL) {
 		/*
 		 * Have enough room for control packets along with HI watermark
-- 
1.7.4.1


