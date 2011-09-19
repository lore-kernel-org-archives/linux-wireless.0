Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4551 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932490Ab1ISV0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 17:26:31 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 13/20] staging: brcm80211: removed two fullmac sparse
 spinlock warnings
Date: Mon, 19 Sep 2011 14:26:01 -0700
Message-ID: <1316467568-27683-14-git-send-email-frankyl@broadcom.com> (sfid-20110919_232830_913765_78D0831D)
In-Reply-To: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
References: <1316467568-27683-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

By deleting three redundant functions. The spinlock was related to
event queue operation. Event queue data members were also renamed
to make their function more clear.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   49 ++++++++--------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    6 +-
 2 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2dd28a2..0bda00c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3181,21 +3181,6 @@ init_priv_mem_out:
 	return -ENOMEM;
 }
 
-static void brcmf_lock_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_lock_irq(&cfg_priv->eq_lock);
-}
-
-static void brcmf_unlock_eq(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_unlock_irq(&cfg_priv->eq_lock);
-}
-
-static void brcmf_init_eq_lock(struct brcmf_cfg80211_priv *cfg_priv)
-{
-	spin_lock_init(&cfg_priv->eq_lock);
-}
-
 /*
 * retrieve first queued event from head
 */
@@ -3205,13 +3190,13 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 {
 	struct brcmf_cfg80211_event_q *e = NULL;
 
-	brcmf_lock_eq(cfg_priv);
-	if (likely(!list_empty(&cfg_priv->eq_list))) {
-		e = list_first_entry(&cfg_priv->eq_list,
-				     struct brcmf_cfg80211_event_q, eq_list);
-		list_del(&e->eq_list);
+	spin_lock_irq(&cfg_priv->evt_q_lock);
+	if (likely(!list_empty(&cfg_priv->evt_q_list))) {
+		e = list_first_entry(&cfg_priv->evt_q_list,
+				     struct brcmf_cfg80211_event_q, evt_q_list);
+		list_del(&e->evt_q_list);
 	}
-	brcmf_unlock_eq(cfg_priv);
+	spin_unlock_irq(&cfg_priv->evt_q_lock);
 
 	return e;
 }
@@ -3236,9 +3221,9 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	e->etype = event;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
 
-	brcmf_lock_eq(cfg_priv);
-	list_add_tail(&e->eq_list, &cfg_priv->eq_list);
-	brcmf_unlock_eq(cfg_priv);
+	spin_lock_irq(&cfg_priv->evt_q_lock);
+	list_add_tail(&e->evt_q_list, &cfg_priv->evt_q_list);
+	spin_unlock_irq(&cfg_priv->evt_q_lock);
 
 	return err;
 }
@@ -3276,22 +3261,22 @@ static void brcmf_cfg80211_event_handler(struct work_struct *work)
 
 static void brcmf_init_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
-	brcmf_init_eq_lock(cfg_priv);
-	INIT_LIST_HEAD(&cfg_priv->eq_list);
+	spin_lock_init(&cfg_priv->evt_q_lock);
+	INIT_LIST_HEAD(&cfg_priv->evt_q_list);
 }
 
 static void brcmf_flush_eq(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	struct brcmf_cfg80211_event_q *e;
 
-	brcmf_lock_eq(cfg_priv);
-	while (!list_empty(&cfg_priv->eq_list)) {
-		e = list_first_entry(&cfg_priv->eq_list,
-				     struct brcmf_cfg80211_event_q, eq_list);
-		list_del(&e->eq_list);
+	spin_lock_irq(&cfg_priv->evt_q_lock);
+	while (!list_empty(&cfg_priv->evt_q_list)) {
+		e = list_first_entry(&cfg_priv->evt_q_list,
+				     struct brcmf_cfg80211_event_q, evt_q_list);
+		list_del(&e->evt_q_list);
 		kfree(e);
 	}
-	brcmf_unlock_eq(cfg_priv);
+	spin_unlock_irq(&cfg_priv->evt_q_lock);
 }
 
 static s32 wl_init_priv(struct brcmf_cfg80211_priv *cfg_priv)
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 79806c0..14a32e1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -199,7 +199,7 @@ struct brcmf_cfg80211_ie {
 
 /* event queue for cfg80211 main event */
 struct brcmf_cfg80211_event_q {
-	struct list_head eq_list;
+	struct list_head evt_q_list;
 	u32 etype;
 	struct brcmf_event_msg emsg;
 	s8 edata[1];
@@ -282,8 +282,8 @@ struct brcmf_cfg80211_priv {
 	struct cfg80211_scan_request *scan_request;	/* scan request
 							 object */
 	struct brcmf_cfg80211_event_loop el;	/* main event loop */
-	struct list_head eq_list;	/* used for event queue */
-	spinlock_t eq_lock;	/* for event queue synchronization */
+	struct list_head evt_q_list;	/* used for event queue */
+	spinlock_t	 evt_q_lock;	/* for event queue synchronization */
 	struct mutex usr_sync;	/* maily for dongle up/down synchronization */
 	struct brcmf_scan_results *bss_list;	/* bss_list holding scanned
 						 ap information */
-- 
1.7.1


