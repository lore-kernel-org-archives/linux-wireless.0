Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3220 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab1HLNft (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:49 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/14] staging: brcm80211: remove unused func parameter
 in wl_cfg80211 of fullmac
Date: Fri, 12 Aug 2011 15:35:01 +0200
Message-ID: <1313156101-16817-15-git-send-email-arend@broadcom.com> (sfid-20110812_154257_120441_22A8DF26)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Get rid of some unused void *data parameter

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   24 +++++++++++-----------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index def1f77..6c604cf 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -117,7 +117,7 @@ static void brcmf_init_eloop_handler(struct brcmf_cfg80211_event_loop *el);
 static struct brcmf_cfg80211_event_q *
 brcmf_deq_event(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 type,
-			  const struct brcmf_event_msg *msg, void *data);
+			  const struct brcmf_event_msg *msg);
 static void brcmf_put_event(struct brcmf_cfg80211_event_q *e);
 static void brcmf_wakeup_event(struct brcmf_cfg80211_priv *cfg_priv);
 static s32 brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
@@ -134,11 +134,11 @@ static s32 brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 				    void *data);
 static s32 brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 				  struct net_device *ndev,
-				  const struct brcmf_event_msg *e, void *data,
+				  const struct brcmf_event_msg *e,
 				  bool completed);
 static s32 brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 				  struct net_device *ndev,
-				  const struct brcmf_event_msg *e, void *data);
+				  const struct brcmf_event_msg *e);
 static s32 brcmf_notify_mic_status(struct brcmf_cfg80211_priv *cfg_priv,
 				   struct net_device *ndev,
 				   const struct brcmf_event_msg *e, void *data);
@@ -2631,7 +2631,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
 			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 			set_bit(WL_STATUS_CONNECTED, &cfg_priv->status);
 		} else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, data, true);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
 	} else if (brcmf_is_linkdown(cfg_priv, e)) {
 		WL_CONN("Linkdown\n");
 		if (brcmf_is_ibssmode(cfg_priv)) {
@@ -2640,7 +2640,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
 				&cfg_priv->status))
 				brcmf_link_down(cfg_priv);
 		} else {
-			brcmf_bss_connect_done(cfg_priv, ndev, e, data, false);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
 			if (test_and_clear_bit(WL_STATUS_CONNECTED,
 				&cfg_priv->status)) {
 				cfg80211_disconnected(ndev, 0, NULL, 0,
@@ -2653,7 +2653,7 @@ brcmf_notify_connect_status(struct brcmf_cfg80211_priv *cfg_priv,
 		if (brcmf_is_ibssmode(cfg_priv))
 			clear_bit(WL_STATUS_CONNECTING, &cfg_priv->status);
 		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, data, false);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, false);
 	}
 
 	return err;
@@ -2670,9 +2670,9 @@ brcmf_notify_roaming_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	if (event == BRCMF_E_ROAM && status == BRCMF_E_STATUS_SUCCESS) {
 		if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status))
-			brcmf_bss_roaming_done(cfg_priv, ndev, e, data);
+			brcmf_bss_roaming_done(cfg_priv, ndev, e);
 		else
-			brcmf_bss_connect_done(cfg_priv, ndev, e, data, true);
+			brcmf_bss_connect_done(cfg_priv, ndev, e, true);
 	}
 
 	return err;
@@ -2883,7 +2883,7 @@ update_bss_info_out:
 static s32
 brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       struct net_device *ndev,
-		       const struct brcmf_event_msg *e, void *data)
+		       const struct brcmf_event_msg *e)
 {
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	struct wiphy *wiphy = cfg_to_wiphy(cfg_priv);
@@ -2927,7 +2927,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 static s32
 brcmf_bss_connect_done(struct brcmf_cfg80211_priv *cfg_priv,
 		       struct net_device *ndev, const struct brcmf_event_msg *e,
-		       void *data, bool completed)
+		       bool completed)
 {
 	struct brcmf_cfg80211_connect_info *conn_info = cfg_to_conn(cfg_priv);
 	s32 err = 0;
@@ -3587,7 +3587,7 @@ brcmf_cfg80211_event(struct net_device *ndev,
 	u32 event_type = be32_to_cpu(e->event_type);
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 
-	if (likely(!brcmf_enq_event(cfg_priv, event_type, e, data)))
+	if (likely(!brcmf_enq_event(cfg_priv, event_type, e)))
 		brcmf_wakeup_event(cfg_priv);
 }
 
@@ -3637,7 +3637,7 @@ static struct brcmf_cfg80211_event_q *brcmf_deq_event(
 
 static s32
 brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
-		const struct brcmf_event_msg *msg, void *data)
+		const struct brcmf_event_msg *msg)
 {
 	struct brcmf_cfg80211_event_q *e;
 	s32 err = 0;
-- 
1.7.4.1


