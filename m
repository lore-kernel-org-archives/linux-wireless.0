Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1664 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405Ab3DEI6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:58:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 14/16] brcmfmac: fix reception of P2P probe requests on
 P2P_DEVICE interface
Date: Fri, 5 Apr 2013 10:57:52 +0200
Message-ID: <1365152274-4252-15-git-send-email-arend@broadcom.com> (sfid-20130405_111304_955783_77F7A0EB)
In-Reply-To: <1365152274-4252-1-git-send-email-arend@broadcom.com>
References: <1365152274-4252-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The probe requests received on P2P_DEVICE interface were not sent
to wpa_supplicant, which makes the device not discoverable by peers.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c         |    6 +++---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index c3d9836..6f16556 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -1850,7 +1850,6 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 	struct brcmf_cfg80211_info *cfg = ifp->drvr->config;
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct afx_hdl *afx_hdl = &p2p->afx_hdl;
-	struct wireless_dev *wdev;
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	struct brcmf_rx_mgmt_data *rxframe = (struct brcmf_rx_mgmt_data *)data;
 	u16 chanspec = be16_to_cpu(rxframe->chanspec);
@@ -1893,8 +1892,9 @@ s32 brcmf_p2p_notify_rx_mgmt_p2p_probereq(struct brcmf_if *ifp,
 					      CHSPEC_IS2G(chanspec) ?
 					      IEEE80211_BAND_2GHZ :
 					      IEEE80211_BAND_5GHZ);
-	wdev = ifp->ndev->ieee80211_ptr;
-	cfg80211_rx_mgmt(wdev, freq, 0, mgmt_frame, mgmt_frame_len, GFP_ATOMIC);
+
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0, mgmt_frame, mgmt_frame_len,
+			 GFP_ATOMIC);
 
 	brcmf_dbg(INFO, "mgmt_frame_len (%d) , e->datalen (%d), chanspec (%04x), freq (%d)\n",
 		  mgmt_frame_len, e->datalen, chanspec, freq);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 68859e5..7eb01e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4112,6 +4112,11 @@ brcmf_txrx_stypes[NUM_NL80211_IFTYPES] = {
 		      BIT(IEEE80211_STYPE_AUTH >> 4) |
 		      BIT(IEEE80211_STYPE_DEAUTH >> 4) |
 		      BIT(IEEE80211_STYPE_ACTION >> 4)
+	},
+	[NL80211_IFTYPE_P2P_DEVICE] = {
+		.tx = 0xffff,
+		.rx = BIT(IEEE80211_STYPE_ACTION >> 4) |
+		      BIT(IEEE80211_STYPE_PROBE_REQ >> 4)
 	}
 };
 
-- 
1.7.10.4


