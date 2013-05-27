Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1145 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754170Ab3E0TKO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 May 2013 15:10:14 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>, stable@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH for 3.10 1/7] brcmfmac: Turn off ARP offloading when
 configured for AP.
Date: Mon, 27 May 2013 21:09:53 +0200
Message-ID: <1369681799-3163-2-git-send-email-arend@broadcom.com> (sfid-20130527_211019_967484_9BF4620A)
In-Reply-To: <1369681799-3163-1-git-send-email-arend@broadcom.com>
References: <1369681799-3163-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

ARP offloading should only be used in STA or P2P client mode. It
is currently configured once at init. When being configured for AP
ARP offloading should be turned off and when AP mode is left it can
be turned back on.

Cc: stable@vger.kernel.org
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   18 ---------
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |    6 +++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   40 +++++++++++++++++++-
 3 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index be0787c..9431af2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -27,7 +27,6 @@
 #include "tracepoint.h"
 
 #define PKTFILTER_BUF_SIZE		128
-#define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
 #define BRCMF_DEFAULT_BCN_TIMEOUT	3
 #define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
@@ -338,23 +337,6 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
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
index 761f501..94285f6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -459,6 +459,38 @@ send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
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
@@ -3683,6 +3715,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	brcmf_set_mpc(ifp, 0);
+	brcmf_configure_arp_offload(ifp, false);
 
 	/* find the RSN_IE */
 	rsn_ie = brcmf_parse_tlvs((u8 *)settings->beacon.tail,
@@ -3789,8 +3822,10 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	set_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
 exit:
-	if (err)
+	if (err) {
 		brcmf_set_mpc(ifp, 1);
+		brcmf_configure_arp_offload(ifp, true);
+	}
 	return err;
 }
 
@@ -3831,6 +3866,7 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 			brcmf_err("bss_enable config failed %d\n", err);
 	}
 	brcmf_set_mpc(ifp, 1);
+	brcmf_configure_arp_offload(ifp, true);
 	set_bit(BRCMF_VIF_STATUS_AP_CREATING, &ifp->vif->sme_state);
 	clear_bit(BRCMF_VIF_STATUS_AP_CREATED, &ifp->vif->sme_state);
 
@@ -5229,6 +5265,8 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 	if (err)
 		goto default_conf_out;
 
+	brcmf_configure_arp_offload(ifp, true);
+
 	cfg->dongle_up = true;
 default_conf_out:
 
-- 
1.7.10.4


