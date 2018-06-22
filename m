Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:35530 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934307AbeFVSnd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Jun 2018 14:43:33 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: fallback mechanism to determine monitor mode features
Date: Fri, 22 Jun 2018 20:43:24 +0200
Message-Id: <1529693004-20569-7-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180622_204348_508537_EDD91D63)
In-Reply-To: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1529693004-20569-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmwares may not provide all monitor mode features in the "cap" iovar.
For those this fallback mechanism uses "sta_monitor" iovar. If firmware
is compiled with stamon, this iovar will fail with BCME_NOTUP; Otherwise
it fails with BCME_UNSUPPORTED.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c  | 15 +++++++++++++++
 .../broadcom/brcm80211/brcmfmac/fwil_types.h        | 21 +++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
index f70fec6..cb57a4a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/feature.c
@@ -207,6 +207,7 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 	struct brcmf_if *ifp = brcmf_get_ifp(drvr, 0);
 	struct brcmf_pno_macaddr_le pfn_mac;
 	struct brcmf_gscan_config gscan_cfg;
+	struct brcmf_stamon_sta_config stamon_cfg;
 	u32 wowl_cap;
 	s32 err;
 
@@ -217,6 +218,20 @@ void brcmf_feat_attach(struct brcmf_pub *drvr)
 		brcmf_feat_iovar_data_set(ifp, BRCMF_FEAT_GSCAN,
 					  "pfn_gscan_cfg",
 					  &gscan_cfg, sizeof(gscan_cfg));
+
+	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_MONITOR) ||
+	    !brcmf_feat_is_enabled(ifp, BRCMF_FEAT_RADIOTAP)) {
+		ifp->fwil_fwerr = true;
+		memset(&stamon_cfg, 0, sizeof(stamon_cfg));
+		/* fails either way as firmware stack is not up yet */
+		err = brcmf_fil_iovar_data_set(ifp, "sta_monitor", &stamon_cfg,
+					       sizeof(stamon_cfg));
+		if (err != BRCMF_FW_UNSUPPORTED) {
+			ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_MONITOR);
+			ifp->drvr->feat_flags |= BIT(BRCMF_FEAT_RADIOTAP);
+		}
+		ifp->fwil_fwerr = false;
+	}
 	brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_PNO, "pfn");
 	if (drvr->bus_if->wowl_supported)
 		brcmf_feat_iovar_int_get(ifp, BRCMF_FEAT_WOWL, "wowl");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index 4b29070..db56c81 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -963,4 +963,25 @@ struct brcmf_gscan_config {
 	struct brcmf_gscan_bucket_config bucket[1];
 };
 
+/**
+ * struct brcmf_stamon_sta_config - configuration data for sta monitor.
+ *
+ * @cmd: subcommand for this configuration.
+ * @mac: mac address of STA for which @cmd is intended.
+ * @version: version of this configuration structure.
+ * @length: number of bytes following this field.
+ * @chanspec: channel of the STA.
+ * @mon_time: time for which STA's are monitored (ms).
+ * @offchan_time: timer for which off-channel STA's are monitored.
+ */
+struct brcmf_stamon_sta_config {
+	__le32 cmd;
+	u8 mac[ETH_ALEN];
+	__le16 version;
+	__le16 length;
+	__le16 chanspec;
+	__le32 monitor_time;
+	__le32 offchan_time;
+};
+
 #endif /* FWIL_TYPES_H_ */
-- 
1.9.1
