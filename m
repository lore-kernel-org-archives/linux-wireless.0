Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3763 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760199Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/27] brcmfmac: add p2p change vif routines.
Date: Fri, 8 Feb 2013 15:53:44 +0100
Message-ID: <1360335242-12608-10-git-send-email-arend@broadcom.com> (sfid-20130208_163816_355039_B5C63181)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Add support for changing existing interface into p2p go
interface.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  106 +++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |    2 +
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   23 ++++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |    4 +
 5 files changed, 119 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b469bd1..451b89c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -26,6 +26,7 @@
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
+#include "fwil_types.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index d2cefb4..fa0127e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -718,24 +718,105 @@ void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
 	memset(p2p, 0, sizeof(*p2p));
 }
 
-static int brcmf_p2p_request_p2p_if(struct brcmf_if *ifp, u8 ea[ETH_ALEN],
-				    enum brcmf_fil_p2p_if_types iftype)
+/**
+ * brcmf_p2p_get_current_chanspec() - Get current operation channel.
+ *
+ * @p2p: P2P specific data.
+ * @chanspec: chanspec to be returned.
+ */
+static void brcmf_p2p_get_current_chanspec(struct brcmf_p2p_info *p2p,
+					   u16 *chanspec)
 {
-	struct brcmf_fil_p2p_if_le if_request;
+	struct brcmf_if *ifp;
 	struct brcmf_fil_chan_info_le ci;
-	u16 chanspec = 11 & WL_CHANSPEC_CHAN_MASK;
-	int err;
+	s32 err;
+
+	ifp = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif->ifp;
+
+	*chanspec = 11 & WL_CHANSPEC_CHAN_MASK;
 
-	/* we need a default channel */
 	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CHANNEL, &ci, sizeof(ci));
 	if (!err) {
-		chanspec = le32_to_cpu(ci.hw_channel) & WL_CHANSPEC_CHAN_MASK;
-		if (chanspec < CH_MAX_2G_CHANNEL)
-			chanspec |= WL_CHANSPEC_BAND_2G;
+		*chanspec = le32_to_cpu(ci.hw_channel) & WL_CHANSPEC_CHAN_MASK;
+		if (*chanspec < CH_MAX_2G_CHANNEL)
+			*chanspec |= WL_CHANSPEC_BAND_2G;
 		else
-			chanspec |= WL_CHANSPEC_BAND_5G;
+			*chanspec |= WL_CHANSPEC_BAND_5G;
+	}
+	*chanspec |= WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE;
+}
+
+/**
+ * Change a P2P Role.
+ * Parameters:
+ * @mac: MAC address of the BSS to change a role
+ * Returns 0 if success.
+ */
+int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
+		       enum brcmf_fil_p2p_if_types if_type)
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_fil_p2p_if_le if_request;
+	s32 err;
+	u16 chanspec;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
+	if (!vif) {
+		brcmf_err("vif for P2PAPI_BSSCFG_PRIMARY does not exist\n");
+		return -EPERM;
 	}
-	chanspec |= WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE;
+	brcmf_notify_escan_complete(cfg, vif->ifp->ndev, true, true);
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
+	if (!vif) {
+		brcmf_err("vif for P2PAPI_BSSCFG_CONNECTION does not exist\n");
+		return -EPERM;
+	}
+	brcmf_set_mpc(vif->ifp->ndev, 0);
+
+	/* In concurrency case, STA may be already associated in a particular */
+	/* channel. so retrieve the current channel of primary interface and  */
+	/* then start the virtual interface on that.                          */
+	brcmf_p2p_get_current_chanspec(p2p, &chanspec);
+
+	if_request.type = cpu_to_le16((u16)if_type);
+	if_request.chspec = cpu_to_le16(chanspec);
+	memcpy(if_request.addr, p2p->int_addr, sizeof(if_request.addr));
+
+	brcmf_cfg80211_arm_vif_event(cfg, vif);
+	err = brcmf_fil_iovar_data_set(vif->ifp, "p2p_ifupd", &if_request,
+				       sizeof(if_request));
+	if (err) {
+		brcmf_err("p2p_ifupd FAILED, err=%d\n", err);
+		brcmf_cfg80211_arm_vif_event(cfg, NULL);
+		return err;
+	}
+	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_CHANGE,
+						    msecs_to_jiffies(1500));
+	brcmf_cfg80211_arm_vif_event(cfg, NULL);
+	if (!err)  {
+		brcmf_err("No BRCMF_E_IF_CHANGE event received\n");
+		return -EIO;
+	}
+
+	err = brcmf_fil_cmd_int_set(vif->ifp, BRCMF_C_SET_SCB_TIMEOUT,
+				    BRCMF_SCB_TIMEOUT_VALUE);
+
+	return err;
+}
+
+static int brcmf_p2p_request_p2p_if(struct brcmf_p2p_info *p2p,
+				    struct brcmf_if *ifp, u8 ea[ETH_ALEN],
+				    enum brcmf_fil_p2p_if_types iftype)
+{
+	struct brcmf_fil_p2p_if_le if_request;
+	int err;
+	u16 chanspec;
+
+	/* we need a default channel */
+	brcmf_p2p_get_current_chanspec(p2p, &chanspec);
 
 	/* fill the firmware request */
 	memcpy(if_request.addr, ea, ETH_ALEN);
@@ -813,7 +894,8 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 		return (struct wireless_dev *)vif;
 	brcmf_cfg80211_arm_vif_event(cfg, vif);
 
-	err = brcmf_p2p_request_p2p_if(ifp, cfg->p2p.int_addr, iftype);
+	err = brcmf_p2p_request_p2p_if(&cfg->p2p, ifp, cfg->p2p.int_addr,
+				       iftype);
 	if (err) {
 		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		goto fail;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
index 1f97afd..1bf57c1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -108,6 +108,8 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 				       enum nl80211_iftype type, u32 *flags,
 				       struct vif_params *params);
 int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev);
+int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
+		       enum brcmf_fil_p2p_if_types if_type);
 int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev);
 int brcmf_p2p_scan_prep(struct wiphy *wiphy,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c57c1db..27436f2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -26,6 +26,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "fwil_types.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
@@ -445,7 +446,7 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 }
 
-static void brcmf_set_mpc(struct net_device *ndev, int mpc)
+void brcmf_set_mpc(struct net_device *ndev, int mpc)
 {
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	s32 err = 0;
@@ -460,7 +461,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	}
 }
 
-static s32
+s32
 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 			    struct net_device *ndev,
 			    bool aborted, bool fw_abort)
@@ -567,6 +568,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
 			 struct vif_params *params)
 {
+	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_if *ifp = netdev_priv(ndev);
 	struct brcmf_cfg80211_vif *vif = ifp->vif;
 	s32 infra = 0;
@@ -590,6 +592,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		infra = 1;
 		break;
 	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
 		vif->mode = WL_MODE_AP;
 		ap = 1;
 		break;
@@ -599,8 +602,14 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	if (ap) {
-		set_bit(BRCMF_VIF_STATUS_AP_CREATING, &vif->sme_state);
-		brcmf_dbg(INFO, "IF Type = AP\n");
+		if (type == NL80211_IFTYPE_P2P_GO) {
+			brcmf_dbg(INFO, "IF Type = P2P GO\n");
+			err = brcmf_p2p_ifchange(cfg, BRCMF_FIL_P2P_IF_GO);
+		}
+		if (!err) {
+			set_bit(BRCMF_VIF_STATUS_AP_CREATING, &vif->sme_state);
+			brcmf_dbg(INFO, "IF Type = AP\n");
+		}
 	} else {
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_INFRA, infra);
 		if (err) {
@@ -4422,7 +4431,6 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 		  ifevent->action, ifevent->flags, ifevent->ifidx,
 		  ifevent->bssidx);
 
-
 	mutex_lock(&event->vif_event_lock);
 	event->action = ifevent->action;
 	vif = event->vif;
@@ -4453,6 +4461,11 @@ static s32 brcmf_notify_vif_event(struct brcmf_if *ifp,
 			wake_up(&event->vif_wq);
 		return 0;
 
+	case BRCMF_E_IF_CHANGE:
+		mutex_unlock(&event->vif_event_lock);
+		wake_up(&event->vif_wq);
+		return 0;
+
 	default:
 		mutex_unlock(&event->vif_event_lock);
 		break;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index 5068188..2155308 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -492,5 +492,9 @@ bool brcmf_cfg80211_vif_event_armed(struct brcmf_cfg80211_info *cfg);
 int brcmf_cfg80211_wait_vif_event_timeout(struct brcmf_cfg80211_info *cfg,
 					  u8 action, ulong timeout);
 void brcmf_cfg80211_vif_complete(struct brcmf_cfg80211_info *info);
+s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
+				struct net_device *ndev,
+				bool aborted, bool fw_abort);
+void brcmf_set_mpc(struct net_device *ndev, int mpc);
 
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.10.4


