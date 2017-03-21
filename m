Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35820 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756343AbdCUNoa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Mar 2017 09:44:30 -0400
Received: by mail-lf0-f67.google.com with SMTP id v2so13077305lfi.2
        for <linux-wireless@vger.kernel.org>; Tue, 21 Mar 2017 06:44:28 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: wrap brcmf_fws_(de)init into bcdc layer
Date: Tue, 21 Mar 2017 14:44:22 +0100
Message-Id: <20170321134422.888-1-zajec5@gmail.com> (sfid-20170321_144445_924194_98583F1B)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

fwsignal is only used by bcdc. Create new protocol interface functions
for core code to perform proto specific (de)initialization. This makes
core agnostic to the protocol which will allow further optimizations.
We will be able to avoid compiling unused protocols or modularize them.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c  | 12 ++++++++++++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c  |  7 +++----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h | 16 ++++++++++++++++
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
index 92eafccf087b..bb27a5f3cbdf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
@@ -106,6 +106,16 @@ struct brcmf_bcdc {
 };
 
 
+static int brcmf_proto_bcdc_init(struct brcmf_pub *pub)
+{
+	return brcmf_fws_init(pub);
+}
+
+static void brcmf_proto_bcdc_deinit(struct brcmf_pub *pub)
+{
+	return brcmf_fws_deinit(pub);
+}
+
 static int
 brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
 		     uint len, bool set)
@@ -431,6 +441,8 @@ int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
+	drvr->proto->init = brcmf_proto_bcdc_init;
+	drvr->proto->deinit = brcmf_proto_bcdc_deinit;
 	drvr->proto->hdrpull = brcmf_proto_bcdc_hdrpull;
 	drvr->proto->query_dcmd = brcmf_proto_bcdc_query_dcmd;
 	drvr->proto->set_dcmd = brcmf_proto_bcdc_set_dcmd;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 60c6c7839cc2..d2be20627b5c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -32,7 +32,6 @@
 #include "p2p.h"
 #include "cfg80211.h"
 #include "fwil.h"
-#include "fwsignal.h"
 #include "feature.h"
 #include "proto.h"
 #include "pcie.h"
@@ -986,7 +985,7 @@ int brcmf_bus_started(struct device *dev)
 	}
 	brcmf_feat_attach(drvr);
 
-	ret = brcmf_fws_init(drvr);
+	ret = brcmf_proto_init(drvr);
 	if (ret < 0)
 		goto fail;
 
@@ -1036,7 +1035,7 @@ int brcmf_bus_started(struct device *dev)
 	}
 	if (drvr->fws) {
 		brcmf_proto_del_if(ifp->drvr, ifp);
-		brcmf_fws_deinit(drvr);
+		brcmf_proto_deinit(drvr);
 	}
 	brcmf_net_detach(ifp->ndev, false);
 	if (p2p_ifp)
@@ -1103,7 +1102,7 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_cfg80211_detach(drvr->config);
 
-	brcmf_fws_deinit(drvr);
+	brcmf_proto_deinit(drvr);
 
 	brcmf_bus_stop(drvr->bus_if);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
index 3048ed529f95..2a5d691be562 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
@@ -27,6 +27,8 @@ struct brcmf_skb_reorder_data {
 };
 
 struct brcmf_proto {
+	int (*init)(struct brcmf_pub *pub);
+	void (*deinit)(struct brcmf_pub *pub);
 	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
 		       struct sk_buff *skb, struct brcmf_if **ifp);
 	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
@@ -54,6 +56,20 @@ struct brcmf_proto {
 int brcmf_proto_attach(struct brcmf_pub *drvr);
 void brcmf_proto_detach(struct brcmf_pub *drvr);
 
+static inline int brcmf_proto_init(struct brcmf_pub *pub)
+{
+	if (!pub->proto->init)
+		return 0;
+	return pub->proto->init(pub);
+}
+
+static inline void brcmf_proto_deinit(struct brcmf_pub *pub)
+{
+	if (!pub->proto->deinit)
+		return;
+	pub->proto->deinit(pub);
+}
+
 static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
 				      struct sk_buff *skb,
 				      struct brcmf_if **ifp)
-- 
2.11.0
