Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1665 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162008Ab3DEI6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:09 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/16] brcmfmac: remove use of unconditional access of
 struct wireless_dev::netdev
Date: Fri, 5 Apr 2013 10:57:47 +0200
Message-ID: <1365152274-4252-10-git-send-email-arend@broadcom.com> (sfid-20130405_105817_242920_AF855BA5)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the introduction of the P2P_DEVICE interface type an instance of
struct wireless_dev does not always have a netdev assigned to it. Better
use container_of() construct to obtain internal structure and go from
there.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index beba7f6..56359e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3868,13 +3868,13 @@ brcmf_cfg80211_mgmt_frame_register(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   u16 frame_type, bool reg)
 {
-	struct brcmf_if *ifp = netdev_priv(wdev->netdev);
-	struct brcmf_cfg80211_vif *vif = ifp->vif;
+	struct brcmf_cfg80211_vif *vif;
 	u16 mgmt_type;
 
 	brcmf_dbg(TRACE, "Enter, frame_type %04x, reg=%d\n", frame_type, reg);
 
 	mgmt_type = (frame_type & IEEE80211_FCTL_STYPE) >> 4;
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 	if (reg)
 		vif->mgmt_rx_reg |= BIT(mgmt_type);
 	else
@@ -3890,7 +3890,6 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	const struct ieee80211_mgmt *mgmt;
-	struct brcmf_if *ifp;
 	struct brcmf_cfg80211_vif *vif;
 	s32 err = 0;
 	s32 ie_offset;
@@ -3926,8 +3925,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		ie_offset =  DOT11_MGMT_HDR_LEN +
 			     DOT11_BCN_PRB_FIXED_LEN;
 		ie_len = len - ie_offset;
-		ifp = netdev_priv(wdev->netdev);
-		vif = ifp->vif;
+		vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 		if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif)
 			vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
 		err = brcmf_vif_set_mgmt_ie(vif,
@@ -3962,7 +3960,7 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  *cookie, le16_to_cpu(action_frame->len),
 			  chan->center_freq);
 
-		ack = brcmf_p2p_send_action_frame(cfg, wdev->netdev,
+		ack = brcmf_p2p_send_action_frame(cfg, cfg_to_ndev(cfg),
 						  af_params);
 
 		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, ack,
-- 
1.7.10.4


