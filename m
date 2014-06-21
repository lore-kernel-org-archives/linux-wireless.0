Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:53686 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934540AbaFUKLZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2014 06:11:25 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Kim <dekim@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 7/8] brcmfmac: Don't control mpc setting during scan operation
Date: Sat, 21 Jun 2014 12:11:18 +0200
Message-ID: <1403345479-13467-8-git-send-email-arend@broadcom.com> (sfid-20140621_121131_585573_09F37BF9)
In-Reply-To: <1403345479-13467-1-git-send-email-arend@broadcom.com>
References: <1403345479-13467-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Kim <dekim@broadcom.com>

Instead of controlling mpc setting during scan operation, initialize
mpc setting and then let firmware take care of it.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Daniel Kim <dekim@broadcom.com>
[arend@broadcom.com: keep mpc setting for bcm4329]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    7 +++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   16 +++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index ed3e32c..d991f8e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -282,6 +282,13 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	ptr = strrchr(buf, ' ') + 1;
 	strlcpy(ifp->drvr->fwver, ptr, sizeof(ifp->drvr->fwver));
 
+	/* set mpc */
+	err = brcmf_fil_iovar_int_set(ifp, "mpc", 1);
+	if (err) {
+		brcmf_err("failed setting mpc\n");
+		goto done;
+	}
+
 	/*
 	 * Setup timeout if Beacons are lost and roam is off to report
 	 * link down
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index f534bf2..d412a18 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -590,6 +590,12 @@ static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
 	}
 }
 
+static void brcmf_scan_config_mpc(struct brcmf_if *ifp, int mpc)
+{
+	if ((brcmf_get_chip_info(ifp) >> 4) == 0x4329)
+		brcmf_set_mpc(ifp, mpc);
+}
+
 void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
 {
 	s32 err = 0;
@@ -643,7 +649,7 @@ s32 brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 			brcmf_err("Scan abort  failed\n");
 	}
 
-	brcmf_set_mpc(ifp, 1);
+	brcmf_scan_config_mpc(ifp, 1);
 
 	/*
 	 * e-scan can be initiated by scheduled scan
@@ -922,7 +928,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 		brcmf_err("error (%d)\n", err);
 		return err;
 	}
-	brcmf_set_mpc(ifp, 0);
+	brcmf_scan_config_mpc(ifp, 0);
 	results = (struct brcmf_scan_results *)cfg->escan_info.escan_buf;
 	results->version = 0;
 	results->count = 0;
@@ -930,7 +936,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 
 	err = escan->run(cfg, ifp, request, WL_ESCAN_ACTION_START);
 	if (err)
-		brcmf_set_mpc(ifp, 1);
+		brcmf_scan_config_mpc(ifp, 1);
 	return err;
 }
 
@@ -1021,7 +1027,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 			brcmf_err("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
-		brcmf_set_mpc(ifp, 0);
+		brcmf_scan_config_mpc(ifp, 0);
 		err = brcmf_fil_cmd_data_set(ifp, BRCMF_C_SCAN,
 					     &sr->ssid_le, sizeof(sr->ssid_le));
 		if (err) {
@@ -1031,7 +1037,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 			else
 				brcmf_err("WLC_SCAN error (%d)\n", err);
 
-			brcmf_set_mpc(ifp, 1);
+			brcmf_scan_config_mpc(ifp, 1);
 			goto scan_out;
 		}
 	}
-- 
1.7.9.5

