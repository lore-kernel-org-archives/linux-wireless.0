Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDEDC64EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F07E2087D
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 12:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F07E2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbeJIUEx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 16:04:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51340 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbeJIUEw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 16:04:52 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4DF9B7FDE4;
        Tue,  9 Oct 2018 12:48:05 +0000 (UTC)
Received: from shalem.localdomain.com (unknown [10.36.118.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8D74610840C0;
        Tue,  9 Oct 2018 12:48:03 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH 4/6] brcmfmac: Set board_type used for nvram file selection to machine-compatible
Date:   Tue,  9 Oct 2018 14:47:53 +0200
Message-Id: <20181009124755.25402-4-hdegoede@redhat.com>
In-Reply-To: <20181009124755.25402-1-hdegoede@redhat.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Oct 2018 12:48:05 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For of/devicetree using machines, set the board_type used for nvram file
selection to the first string listed in the top-level's node compatible
string, aka the machine-compatible as used by of_machine_is_compatible().

The board_type setting is used to load the board-specific nvram file with
a board-specific name so that we can ship files for each supported board
in linux-firmware.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/common.h |  1 +
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 11 ++++++++++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   |  1 +
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c   |  1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index a34642cb4d2f..e63a273642e9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -59,6 +59,7 @@ struct brcmf_mp_device {
 	bool		iapp;
 	bool		ignore_probe_fail;
 	struct brcmfmac_pd_cc *country_codes;
+	const char	*board_type;
 	union {
 		struct brcmfmac_sdio_pd sdio;
 	} bus;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index aee6e5937c41..84e3373289eb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -27,11 +27,20 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
 		    struct brcmf_mp_device *settings)
 {
 	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
-	struct device_node *np = dev->of_node;
+	struct device_node *root, *np = dev->of_node;
+	struct property *prop;
 	int irq;
 	u32 irqf;
 	u32 val;
 
+	/* Set board-type to the first string of the machine compatible prop */
+	root = of_find_node_by_path("/");
+	if (root) {
+		prop = of_find_property(root, "compatible", NULL);
+		settings->board_type = of_prop_next_string(prop, NULL);
+		of_node_put(root);
+	}
+
 	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
 	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 4fffa6988087..b12f3e0ee69c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -1785,6 +1785,7 @@ brcmf_pcie_prepare_fw_request(struct brcmf_pciedev_info *devinfo)
 	fwreq->items[BRCMF_PCIE_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
 	fwreq->items[BRCMF_PCIE_FW_NVRAM].flags = BRCMF_FW_REQF_OPTIONAL;
+	fwreq->board_type = devinfo->settings->board_type;
 	/* NVRAM reserves PCI domain 0 for Broadcom's SDK faked bus */
 	fwreq->domain_nr = pci_domain_nr(devinfo->pdev->bus) + 1;
 	fwreq->bus_nr = devinfo->pdev->bus->number;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index a907d7b065fa..3dbbbb117563 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4177,6 +4177,7 @@ brcmf_sdio_prepare_fw_request(struct brcmf_sdio *bus)
 
 	fwreq->items[BRCMF_SDIO_FW_CODE].type = BRCMF_FW_TYPE_BINARY;
 	fwreq->items[BRCMF_SDIO_FW_NVRAM].type = BRCMF_FW_TYPE_NVRAM;
+	fwreq->board_type = bus->sdiodev->settings->board_type;
 
 	return fwreq;
 }
-- 
2.19.0

