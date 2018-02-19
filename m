Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:47998 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932341AbeBSXOe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 18:14:34 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: move brcmf_attach() function in core.c
Date: Tue, 20 Feb 2018 00:14:22 +0100
Message-Id: <1519082065-10128-6-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180220_001441_012330_068CCD79)
In-Reply-To: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving the function in preparation of subsequent patch.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 98 +++++++++++-----------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index e553d1a..9eab7a9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -914,55 +914,6 @@ static int brcmf_inet6addr_changed(struct notifier_block *nb,
 }
 #endif
 
-int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
-{
-	struct brcmf_pub *drvr = NULL;
-	int ret = 0;
-	int i;
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	/* Allocate primary brcmf_info */
-	drvr = kzalloc(sizeof(struct brcmf_pub), GFP_ATOMIC);
-	if (!drvr)
-		return -ENOMEM;
-
-	for (i = 0; i < ARRAY_SIZE(drvr->if2bss); i++)
-		drvr->if2bss[i] = BRCMF_BSSIDX_INVALID;
-
-	mutex_init(&drvr->proto_block);
-
-	/* Link to bus module */
-	drvr->hdrlen = 0;
-	drvr->bus_if = dev_get_drvdata(dev);
-	drvr->bus_if->drvr = drvr;
-	drvr->settings = settings;
-
-	/* attach debug facilities */
-	brcmf_debug_attach(drvr);
-
-	/* Attach and link in the protocol */
-	ret = brcmf_proto_attach(drvr);
-	if (ret != 0) {
-		brcmf_err("brcmf_prot_attach failed\n");
-		goto fail;
-	}
-
-	/* Attach to events important for core code */
-	brcmf_fweh_register(drvr, BRCMF_E_PSM_WATCHDOG,
-			    brcmf_psm_watchdog_notify);
-
-	/* attach firmware event handler */
-	brcmf_fweh_attach(drvr);
-
-	return ret;
-
-fail:
-	brcmf_detach(dev);
-
-	return ret;
-}
-
 static int brcmf_revinfo_read(struct seq_file *s, void *data)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(s->private);
@@ -1093,6 +1044,55 @@ int brcmf_bus_started(struct device *dev)
 	return ret;
 }
 
+int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
+{
+	struct brcmf_pub *drvr = NULL;
+	int ret = 0;
+	int i;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	/* Allocate primary brcmf_info */
+	drvr = kzalloc(sizeof(*drvr), GFP_ATOMIC);
+	if (!drvr)
+		return -ENOMEM;
+
+	for (i = 0; i < ARRAY_SIZE(drvr->if2bss); i++)
+		drvr->if2bss[i] = BRCMF_BSSIDX_INVALID;
+
+	mutex_init(&drvr->proto_block);
+
+	/* Link to bus module */
+	drvr->hdrlen = 0;
+	drvr->bus_if = dev_get_drvdata(dev);
+	drvr->bus_if->drvr = drvr;
+	drvr->settings = settings;
+
+	/* attach debug facilities */
+	brcmf_debug_attach(drvr);
+
+	/* Attach and link in the protocol */
+	ret = brcmf_proto_attach(drvr);
+	if (ret != 0) {
+		brcmf_err("brcmf_prot_attach failed\n");
+		goto fail;
+	}
+
+	/* Attach to events important for core code */
+	brcmf_fweh_register(drvr, BRCMF_E_PSM_WATCHDOG,
+			    brcmf_psm_watchdog_notify);
+
+	/* attach firmware event handler */
+	brcmf_fweh_attach(drvr);
+
+	return ret;
+
+fail:
+	brcmf_detach(dev);
+
+	return ret;
+}
+
 void brcmf_bus_add_txhdrlen(struct device *dev, uint len)
 {
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
-- 
1.9.1
