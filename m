Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:52760 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935178AbcKWK1E (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:27:04 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 09/12] brcmfmac: use provided channels for scheduled scan
Date: Wed, 23 Nov 2016 10:25:28 +0000
Message-Id: <1479896731-5091-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161123_112747_127488_D3200E96)
In-Reply-To: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1479896731-5091-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

User-space can provide list of channels in the schedule scan request.
This was ignored so all channels supported and allowed by the device
were used. This patch configures the device to use the channels as
listed in the request.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       | 16 +++++++++++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 26 +++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
index a4118c0..64aed2d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h
@@ -131,6 +131,7 @@
 #define BRCMF_TXBF_MU_BFR_CAP		BIT(1)
 
 #define	BRCMF_MAXPMKID			16	/* max # PMKID cache entries */
+#define BRCMF_NUMCHANNELS		64
 
 #define BRCMF_PFN_MACADDR_CFG_VER	1
 #define BRCMF_PFN_MAC_OUI_ONLY		BIT(0)
@@ -719,6 +720,21 @@ struct brcmf_pno_param_le {
 };
 
 /**
+ * struct brcmf_pno_config_le - PNO channel configuration.
+ *
+ * @reporttype: determines what is reported.
+ * @channel_num: number of channels specified in @channel_list.
+ * @channel_list: channels to use in PNO scan.
+ * @flags: reserved.
+ */
+struct brcmf_pno_config_le {
+	__le32  reporttype;
+	__le32  channel_num;
+	__le16  channel_list[BRCMF_NUMCHANNELS];
+	__le32  flags;
+};
+
+/**
  * struct brcmf_pno_net_param_le - scan parameters per preferred network.
  *
  * @ssid: ssid name and its length.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
index d16e89e..bc33bdc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pno.c
@@ -18,9 +18,10 @@
 
 #include "core.h"
 #include "debug.h"
-#include "pno.h"
 #include "fwil.h"
 #include "fwil_types.h"
+#include "cfg80211.h"
+#include "pno.h"
 
 #define BRCMF_PNO_VERSION		2
 #define BRCMF_PNO_REPEAT		4
@@ -34,6 +35,15 @@
 #define BRCMF_PNO_HIDDEN_BIT		2
 #define BRCMF_PNO_SCHED_SCAN_PERIOD	30
 
+static int brcmf_pno_channel_config(struct brcmf_if *ifp,
+				    struct brcmf_pno_config_le *cfg)
+{
+	cfg->reporttype = 0;
+	cfg->flags = 0;
+
+	return brcmf_fil_iovar_data_set(ifp, "pfn_cfg", cfg, sizeof(*cfg));
+}
+
 static int brcmf_pno_config(struct brcmf_if *ifp, u32 scan_freq,
 			    u32 mscan, u32 bestn)
 {
@@ -167,7 +177,10 @@ int brcmf_pno_clean(struct brcmf_if *ifp)
 int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			       struct cfg80211_sched_scan_request *req)
 {
+	struct brcmu_d11inf *d11inf;
+	struct brcmf_pno_config_le pno_cfg;
 	struct cfg80211_ssid *ssid;
+	u16 chan;
 	int i, ret;
 
 	/* clean up everything */
@@ -190,6 +203,17 @@ int brcmf_pno_start_sched_scan(struct brcmf_if *ifp,
 			return ret;
 	}
 
+	/* configure channels to use */
+	d11inf = &ifp->drvr->config->d11inf;
+	for (i = 0; i < req->n_channels; i++) {
+		chan = req->channels[i]->hw_value;
+		pno_cfg.channel_list[i] = cpu_to_le16(chan);
+	}
+	if (req->n_channels) {
+		pno_cfg.channel_num = cpu_to_le32(req->n_channels);
+		brcmf_pno_channel_config(ifp, &pno_cfg);
+	}
+
 	/* configure each match set */
 	for (i = 0; i < req->n_match_sets; i++) {
 		ssid = &req->match_sets[i].ssid;
-- 
1.9.1
