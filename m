Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1975 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889Ab2IMTM0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2012 15:12:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 10/10] brcmfmac: simplify handling e-scan result
 firmware event
Date: Thu, 13 Sep 2012 21:12:06 +0200
Message-ID: <1347563526-12513-11-git-send-email-arend@broadcom.com> (sfid-20120913_212552_076537_CEB2D065)
In-Reply-To: <1347563526-12513-1-git-send-email-arend@broadcom.com>
References: <1347563526-12513-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon handling an e-scan result event from the firmware in
brcmf_cfg80211_escan_handler() the status may indicate e-scan
is completed or aborted. If so brcmf_notify_escan_complete()
is called. However, that function and brcmf_cfg80211_escan_handler()
both log the same debug message and both enable MPC flag in the
firmware.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 32ee052..200a6c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2873,6 +2873,7 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 	u32 bi_length;
 	struct brcmf_scan_results *list;
 	u32 i;
+	bool aborted;
 
 	status = be32_to_cpu(e->status);
 
@@ -2945,16 +2946,9 @@ brcmf_cfg80211_escan_handler(struct brcmf_cfg80211_priv *cfg_priv,
 			cfg_priv->bss_list = (struct brcmf_scan_results *)
 				cfg_priv->escan_info.escan_buf;
 			brcmf_inform_bss(cfg_priv);
-			if (status == BRCMF_E_STATUS_SUCCESS) {
-				WL_SCAN("ESCAN Completed\n");
-				brcmf_notify_escan_complete(cfg_priv, ndev,
-					false, false);
-			} else {
-				WL_ERR("ESCAN Aborted, Event 0x%x\n", status);
-				brcmf_notify_escan_complete(cfg_priv, ndev,
-					true, false);
-			}
-			brcmf_set_mpc(ndev, 1);
+			aborted = status != BRCMF_E_STATUS_SUCCESS;
+			brcmf_notify_escan_complete(cfg_priv, ndev, aborted,
+						    false);
 		} else
 			WL_ERR("Unexpected scan result 0x%x\n", status);
 	}
-- 
1.7.9.5


