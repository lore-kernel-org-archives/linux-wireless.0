Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4245 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755548Ab2JVUz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 16:55:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/12] brcmfmac: store IEs per virtual interface
Date: Mon, 22 Oct 2012 13:55:41 -0700
Message-ID: <1350939341-17687-13-git-send-email-frankyl@broadcom.com> (sfid-20121022_225624_912674_4A139C7A)
In-Reply-To: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
References: <1350939341-17687-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

For AP feature the IEs are stored in global structure. For future
functionality like P2P-GO it needs to be stored per virtual interface
so better store it in the virtual interface structure.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   16 ++++++++--------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   16 ++++++++++++++++
 2 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 62b155e..cbad772 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3774,6 +3774,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 			u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct vif_saved_ie *saved_ie = &ifp->vif->saved_ie;
 	s32 err = 0;
 	u8  *iovar_ie_buf;
 	u8  *curr_ie_buf;
@@ -3796,18 +3797,17 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	if (!iovar_ie_buf)
 		return -ENOMEM;
 	curr_ie_buf = iovar_ie_buf;
-	if (test_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state) ||
-	    test_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state)) {
+	if (ifp->vif->mode == WL_MODE_AP) {
 		switch (pktflag) {
 		case VNDR_IE_PRBRSP_FLAG:
-			mgmt_ie_buf = cfg->ap_info->probe_res_ie;
-			mgmt_ie_len = &cfg->ap_info->probe_res_ie_len;
-			mgmt_ie_buf_len = sizeof(cfg->ap_info->probe_res_ie);
+			mgmt_ie_buf = saved_ie->probe_res_ie;
+			mgmt_ie_len = &saved_ie->probe_res_ie_len;
+			mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
 			break;
 		case VNDR_IE_BEACON_FLAG:
-			mgmt_ie_buf = cfg->ap_info->beacon_ie;
-			mgmt_ie_len = &cfg->ap_info->beacon_ie_len;
-			mgmt_ie_buf_len = sizeof(cfg->ap_info->beacon_ie);
+			mgmt_ie_buf = saved_ie->beacon_ie;
+			mgmt_ie_len = &saved_ie->beacon_ie_len;
+			mgmt_ie_buf_len = sizeof(saved_ie->beacon_ie);
 			break;
 		default:
 			err = -EPERM;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 85f3adf..1dd96f1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -232,6 +232,21 @@ enum brcmf_vif_status {
 };
 
 /**
+ * struct vif_saved_ie - holds saved IEs for a virtual interface.
+ *
+ * @probe_res_ie: IE info for probe response.
+ * @beacon_ie: IE info for beacon frame.
+ * @probe_res_ie_len: IE info length for probe response.
+ * @beacon_ie_len: IE info length for beacon frame.
+ */
+struct vif_saved_ie {
+	u8  probe_res_ie[IE_MAX_LEN];
+	u8  beacon_ie[IE_MAX_LEN];
+	u32 probe_res_ie_len;
+	u32 beacon_ie_len;
+};
+
+/**
  * struct brcmf_cfg80211_vif - virtual interface specific information.
  *
  * @ifp: lower layer interface pointer
@@ -251,6 +266,7 @@ struct brcmf_cfg80211_vif {
 	s32 roam_off;
 	unsigned long sme_state;
 	bool pm_block;
+	struct vif_saved_ie saved_ie;
 	struct list_head list;
 };
 
-- 
1.7.9.5


