Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3745 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817Ab1ILKPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:23 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 15/20] staging: brcm80211: removed unused softmac struct
 brcms_c_if
Date: Mon, 12 Sep 2011 12:14:59 +0200
Message-ID: <1315822504-24210-16-git-send-email-rvossen@broadcom.com> (sfid-20110912_121606_351009_15692671)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nothing useful was done with this struct.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    4 ++--
 drivers/staging/brcm80211/brcmsmac/main.c        |   12 +++++-------
 drivers/staging/brcm80211/brcmsmac/main.h        |   22 +---------------------
 drivers/staging/brcm80211/brcmsmac/pub.h         |    3 +--
 drivers/staging/brcm80211/brcmsmac/types.h       |    1 -
 5 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 23001c2..d003786 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -510,7 +510,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		/* retrieve the current rates */
 		LOCK(wl);
 		error = brcms_c_ioctl(wl->wlc, BRCM_GET_CURR_RATESET,
-				  &rs, sizeof(rs), NULL);
+				  &rs, sizeof(rs));
 		UNLOCK(wl);
 		if (error) {
 			wiphy_err(wiphy, "%s: retrieve rateset failed: %d\n",
@@ -530,7 +530,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* update the rate set */
 		LOCK(wl);
-		brcms_c_ioctl(wl->wlc, BRCM_SET_RATESET, &rs, sizeof(rs), NULL);
+		brcms_c_ioctl(wl->wlc, BRCM_SET_RATESET, &rs, sizeof(rs));
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7ebe060..13f6cd4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -6060,13 +6060,13 @@ brcms_c_set_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs_arg)
 /* simplified integer set interface for common ioctl handler */
 int brcms_c_set(struct brcms_c_info *wlc, int cmd, int arg)
 {
-	return brcms_c_ioctl(wlc, cmd, (void *)&arg, sizeof(arg), NULL);
+	return brcms_c_ioctl(wlc, cmd, (void *)&arg, sizeof(arg));
 }
 
 /* simplified integer get interface for common ioctl handler */
 int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg)
 {
-	return brcms_c_ioctl(wlc, cmd, arg, sizeof(int), NULL);
+	return brcms_c_ioctl(wlc, cmd, arg, sizeof(int));
 }
 
 static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
@@ -6086,8 +6086,7 @@ static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 
 /* common ioctl handler. return: 0=ok, -1=error, positive=particular error */
 static int
-_brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-	       struct brcms_c_if *wlcif)
+_brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len)
 {
 	int val, *pval;
 	bool bool_val;
@@ -6335,10 +6334,9 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 }
 
 int
-brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-	      struct brcms_c_if *wlcif)
+brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len)
 {
-	return _brcms_c_ioctl(wlc, cmd, arg, len, wlcif);
+	return _brcms_c_ioctl(wlc, cmd, arg, len);
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 4e576e5..d418686 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -320,8 +320,7 @@ struct modulecb {
 	 */
 	int (*iovar_fn)(void *handle, const struct brcmu_iovar *vi,
 			u32 actionid, const char *name, void *params,
-			uint plen, void *arg, int alen, int vsize,
-			struct brcms_c_if *wlcif);
+			uint plen, void *arg, int alen, int vsize);
 
 	int (*down_fn)(void *handle); /* down handler. Note: the int returned
 				       * by the down function is a count of the
@@ -347,25 +346,6 @@ struct wme_param_ie {
 	struct edcf_acparam acparam[AC_COUNT];
 } __packed;
 
-/* virtual interface */
-struct brcms_c_if {
-	struct brcms_c_if *next;
-	u8 type;	/* BSS or WDS */
-	u8 index;	/* assigned in wl_add_if(), index of the wlif if any,
-			 * not necessarily corresponding to bsscfg._idx or
-			 * AID2PVBMAP(scb).
-			 */
-	u8 flags;		/* flags for the interface */
-	struct brcms_if *wlif;		/* pointer to wlif */
-	struct brcms_txq_info *qi;	/* pointer to associated tx queue */
-	union {
-		/* pointer to scb if WDS */
-		struct scb *scb;
-		/* pointer to bsscfg if BSS */
-		struct brcms_bss_cfg *bsscfg;
-	} u;
-};
-
 struct brcms_hw_band {
 	int bandtype;		/* BRCM_BAND_2G, BRCM_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index da63364..33e7ebe 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -327,8 +327,7 @@ extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
 extern void brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
 				     struct sk_buff *sdu,
 				     struct ieee80211_hw *hw);
-extern int brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-			 struct brcms_c_if *wlcif);
+extern int brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len);
 extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);
 
 /* helper functions */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 0ae3d83..ace210c 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -334,7 +334,6 @@ struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
 struct brcms_hardware;
-struct brcms_c_if;
 struct brcmu_strbuf;
 struct brcms_txq_info;
 struct brcms_band;
-- 
1.7.4.1


