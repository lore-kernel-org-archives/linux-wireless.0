Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3578 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab3FFI4H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 04:56:07 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: stable@vger.kernel.org
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] brcmfmac: Turn off ARP offloading when configured for
 AP.
Date: Thu, 6 Jun 2013 10:55:57 +0200
Message-ID: <1370508957-12709-1-git-send-email-arend@broadcom.com> (sfid-20130606_105614_190322_96BE2F5D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

[backport of upstream commit b3657453f16a7b84eab9b93bb9a9a2901ffc70af]

ARP offloading should only be used in STA or P2P client mode. It
is currently configured once at init. When being configured for AP
ARP offloading should be turned off and when AP mode is left it can
be turned back on.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   18 ---------
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |    6 +++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   40 +++++++++++++++++++-
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 4544342..9480e19 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -26,7 +26,6 @@
 #include "fwil.h"
 
 #define PKTFILTER_BUF_SIZE		128
-#define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
 #define BRCMF_DEFAULT_BCN_TIMEOUT	3
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
@@ -337,23 +336,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
-	/* Try to set and enable ARP offload feature, this may fail */
-	err = brcmf_fil_iovar_int_set(ifp, "arp_ol", BRCMF_ARPOL_MODE);
-	if (err) {
-		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, err = %d\n",
-			  BRCMF_ARPOL_MODE, err);
-		err = 0;
-	} else {
-		err = brcmf_fil_iovar_int_set(ifp, "arpoe", 1);
-		if (err) {
-			brcmf_dbg(TRACE, "failed to enable ARP offload err = %d\n",
-				  err);
-			err = 0;
-		} else
-			brcmf_dbg(TRACE, "successfully enabled ARP offload to 0x%x\n",
-				  BRCMF_ARPOL_MODE);
-	}
-
 	/* Setup packet filter */
 	brcmf_c_pktfilter_offload_set(ifp, BRCMF_DEFAULT_PACKET_FILTER);
 	brcmf_c_pktfilter_offload_enable(ifp, BRCMF_DEFAULT_PACKET_FILTER,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 0f2c83b..665ef69 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -23,6 +23,12 @@
 
 #define BRCMF_FIL_ACTION_FRAME_SIZE	1800
 
+/* ARP Offload feature flags for arp_ol iovar */
+#define BRCMF_ARP_OL_AGENT		0x00000001
+#define BRCMF_ARP_OL_SNOOP		0x00000002
+#define BRCMF_ARP_OL_HOST_AUTO_REPLY	0x00000004
+#define BRCMF_ARP_OL_PEER_AUTO_REPLY	0x00000008
+
 
 enum brcmf_fil_p2p_if_types {
 	BRCMF_FIL_P2P_IF_CLIENT,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 78da3ef..d5c4e24 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -505,6 +505,38 @@ send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
 	return err;
 }
 
+static s32
+brcmf_configure_arp_offload(struct brcmf_if *ifp, bool enable)
+{
+	s32 err;
+	u32 mode;
+
+	if (enable)
+		mode = BRCMF_ARP_OL_AGENT | BRCMF_ARP_OL_PEER_AUTO_REPLY;
+	else
+		mode = 0;
+
+	/* Try to set and enable ARP offload feature, this may fail, then it  */
+	/* is simply not supported and err 0 will be returned                 */
+	err = brcmf_fil_iovar_int_set(ifp, "arp_ol", mode);
+	if (err) {
+		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, err = %d\n",
+			  mode, err);
+		err = 0;
+	} else {
+		err = brcmf_fil_iovar_int_set(ifp, "arpoe", enable);
+		if (err) {
+			brcmf_dbg(TRACE, "failed to configure (%d) ARP offload err = %d\n",
+				  enable, err);
+			err = 0;
+		} else
+			brcmf_dbg(TRACE, "successfully configured (%d) ARP offload to 0x%x\n",
+				  enable, mode);
+	}
+
+	return err;
+}
+
 static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 						     const char *name,
 						     enum nl80211_iftype type,
@@ -3709,6 +3741,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	brcmf_set_mpc(ndev, 0);
+	brcmf_configure_arp_offload(ifp, false);
 
 	/* find the RSN_IE */
 	rsn_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
@@ -3815,8 +3848,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 exit:
-	if (err)
+	if (err) {
 		brcmf_set_mpc(ndev, 1);
+		brcmf_configure_arp_offload(ifp, true);
+	}
 	return err;
 }
 
@@ -3857,6 +3892,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			brcmf_err("bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ndev, 1);
+	brcmf_configure_arp_offload(ifp, true);
 	set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
@@ -4995,6 +5031,8 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	if (err)
 		goto default_conf_out;
 
+	brcmf_configure_arp_offload(ifp, true);
+
 	cfg->dongle_up = true;
 default_conf_out:
 
-- 
1.7.10.4


