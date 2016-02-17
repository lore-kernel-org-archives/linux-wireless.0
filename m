Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:33107
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161099AbcBQK1Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:24 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 01/21] brcmfmac: change function name for brcmf_cfg80211_wait_vif_event_timeout()
Date: Wed, 17 Feb 2016 11:26:50 +0100
Message-Id: <1455704830-10088-2-git-send-email-arend@broadcom.com> (sfid-20160217_112834_682510_2BC74866)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dropping the '_timeout' from the function name as the fact that a timeout
value is passed makes it obvious a timeout is used. Also helps to keep code
lines a bit shorter and easier to stick to 80 char boundary.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c  |  9 +++++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h  |  4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c   | 16 ++++++++--------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index d00c5c1..5a4a0c4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -564,8 +564,8 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 	}
 
 	/* wait for firmware event */
-	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
-						    BRCMF_VIF_EVENT_TIMEOUT);
+	err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_ADD,
+					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
 		brcmf_err("timeout occurred\n");
@@ -6395,8 +6395,9 @@ bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg)
 
 	return armed;
 }
-int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
-					  u8 action, ulong timeout)
+
+int brcmf_cfg80211_wait_vif_event(struct brcmf_cfg80211_info *cfg,
+				  u8 action, ulong timeout)
 {
 	struct brcmf_cfg80211_vif_event *event = &cfg->vif_event;
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 40efb53..97c327d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -402,8 +402,8 @@ bool brcmf_get_vif_state_any(struct brcmf_cfg80211_info *cfg,
 void brcmf_cfg80211_arm_vif_event(struct brcmf_cfg80211_info *cfg,
 				  struct brcmf_cfg80211_vif *vif);
 bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
-int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
-					  u8 action, ulong timeout);
+int brcmf_cfg80211_wait_vif_event(struct brcmf_cfg80211_info *cfg,
+				  u8 action, ulong timeout);
 s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 				struct brcmf_if *ifp, bool aborted,
 				bool fw_abort);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index 821b649..de5892a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -1988,8 +1988,8 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		return err;
 	}
-	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_CHANGE,
-						    BRCMF_VIF_EVENT_TIMEOUT);
+	err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_CHANGE,
+					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err)  {
 		brcmf_err("No BRCMF_E_IF_CHANGE event received\n");
@@ -2090,8 +2090,8 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 	}
 
 	/* wait for firmware event */
-	err = brcmf_cfg80211_wait_vif_event_timeout(p2p->cfg, BRCMF_E_IF_ADD,
-						    BRCMF_VIF_EVENT_TIMEOUT);
+	err = brcmf_cfg80211_wait_vif_event(p2p->cfg, BRCMF_E_IF_ADD,
+					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 	brcmf_fweh_p2pdev_setup(pri_ifp, false);
 	if (!err) {
@@ -2180,8 +2180,8 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	}
 
 	/* wait for firmware event */
-	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
-						    BRCMF_VIF_EVENT_TIMEOUT);
+	err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_ADD,
+					    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
 		brcmf_err("timeout occurred\n");
@@ -2272,8 +2272,8 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	}
 	if (!err) {
 		/* wait for firmware event */
-		err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
-							BRCMF_VIF_EVENT_TIMEOUT);
+		err = brcmf_cfg80211_wait_vif_event(cfg, BRCMF_E_IF_DEL,
+						    BRCMF_VIF_EVENT_TIMEOUT);
 		if (!err)
 			err = -EIO;
 		else
-- 
1.9.1

