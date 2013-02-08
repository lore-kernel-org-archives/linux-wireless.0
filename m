Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3763 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760219Ab3BHO4p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/27] brcmfmac: update p2p add and delete vif routines.
Date: Fri, 8 Feb 2013 15:53:43 +0100
Message-ID: <1360335242-12608-9-git-send-email-arend@broadcom.com> (sfid-20130208_160736_631949_2F649815)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Improve exception handling. Store and removed created vif
in cfg.p2p.bss array. Fix big endian bug. Fix msec jiffies bug.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   |    2 +-
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |   33 ++++++++++++++------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index d21d9b2..7707194 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -29,7 +29,7 @@ enum brcmf_fil_p2p_if_types {
 
 struct brcmf_fil_p2p_if_le {
 	u8 addr[ETH_ALEN];
-	enum brcmf_fil_p2p_if_types type;
+	__le16 type;
 	__le16 chspec;
 };
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
index aef0287..d2cefb4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -739,7 +739,7 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_if *ifp, u8 ea[ETH_ALEN],
 
 	/* fill the firmware request */
 	memcpy(if_request.addr, ea, ETH_ALEN);
-	if_request.type = iftype;
+	if_request.type = cpu_to_le16((u16)iftype);
 	if_request.chspec = cpu_to_le16(chanspec);
 
 	err = brcmf_fil_iovar_data_set(ifp, "p2p_ifadd", &if_request,
@@ -747,11 +747,6 @@ static int brcmf_p2p_request_p2p_if(struct brcmf_if *ifp, u8 ea[ETH_ALEN],
 	if (err)
 		return err;
 
-	if (iftype == BRCMF_FIL_P2P_IF_GO) {
-		/* set station timeout for p2p */
-		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCB_TIMEOUT,
-					    BRCMF_SCB_TIMEOUT_VALUE);
-	}
 	return err;
 }
 
@@ -814,11 +809,15 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	}
 
 	vif = brcmf_alloc_vif(cfg, type, false);
+	if (IS_ERR(vif))
+		return (struct wireless_dev *)vif;
 	brcmf_cfg80211_arm_vif_event(cfg, vif);
 
 	err = brcmf_p2p_request_p2p_if(ifp, cfg->p2p.int_addr, iftype);
-	if (err)
+	if (err) {
+		brcmf_cfg80211_arm_vif_event(cfg, NULL);
 		goto fail;
+	}
 
 	/* wait for firmware event */
 	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
@@ -835,10 +834,19 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 	if (!ifp) {
 		brcmf_err("no if pointer provided\n");
 		err = -ENOENT;
+		goto fail;
 	}
 
 	strncpy(ifp->ndev->name, name, sizeof(ifp->ndev->name) - 1);
 	brcmf_cfg80211_vif_complete(cfg);
+	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = vif;
+	/* Disable firmware roaming for P2P interface  */
+	brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
+	if (iftype == BRCMF_FIL_P2P_IF_GO) {
+		/* set station timeout for p2p */
+		brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCB_TIMEOUT,
+				      BRCMF_SCB_TIMEOUT_VALUE);
+	}
 	return &ifp->vif->wdev;
 
 fail:
@@ -883,18 +891,25 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	}
 
 	if (wait_for_disable)
-		wait_for_completion_timeout(&cfg->vif_disabled, 500);
+		wait_for_completion_timeout(&cfg->vif_disabled,
+					    msecs_to_jiffies(500));
 
 	brcmf_vif_clear_mgmt_ies(vif);
 
 	brcmf_cfg80211_arm_vif_event(cfg, vif);
 	err = brcmf_p2p_release_p2p_if(vif);
-	if (!err)
+	if (!err) {
 		/* wait for firmware event */
 		err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
 							    jiffie_timeout);
+		if (!err)
+			err = -EIO;
+		else
+			err = 0;
+	}
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	brcmf_free_vif(vif);
+	cfg->p2p.bss_idx[P2PAPI_BSSCFG_CONNECTION].vif = NULL;
 
 	return err;
 }
-- 
1.7.10.4


