Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:33794 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750945AbdAGWn4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 7 Jan 2017 17:43:56 -0500
Received: by mail-lf0-f66.google.com with SMTP id q89so2676977lfi.1
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2017 14:43:55 -0800 (PST)
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
Subject: [PATCH] brcmfmac: make brcmf_of_probe more generic
Date: Sat,  7 Jan 2017 23:43:45 +0100
Message-Id: <20170107224345.3079-1-zajec5@gmail.com> (sfid-20170107_234400_123899_43F2AE82)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

We may want to use Open Firmware for other devices than just SDIO ones.
In future we may want to support more Broadcom properties so there is
really no reason for such limitation.

Call brcmf_of_probe for all kind of devices & move extra conditions to
the body of that funcion.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c | 8 +++-----
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c     | 7 +++++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.h     | 6 ++++--
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 3e15d64..b1f574f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -299,11 +299,9 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 			}
 		}
 	}
-	if ((bus_type == BRCMF_BUSTYPE_SDIO) && (!found)) {
-		/* No platform data for this device. In case of SDIO try OF
-		 * (Open Firwmare) Device Tree.
-		 */
-		brcmf_of_probe(dev, &settings->bus.sdio);
+	if (!found) {
+		/* No platform data for this device, try OF (Open Firwmare) */
+		brcmf_of_probe(dev, bus_type, settings);
 	}
 	return settings;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 425c41d..aee6e59 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -23,14 +23,17 @@
 #include "common.h"
 #include "of.h"
 
-void brcmf_of_probe(struct device *dev, struct brcmfmac_sdio_pd *sdio)
+void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
+		    struct brcmf_mp_device *settings)
 {
+	struct brcmfmac_sdio_pd *sdio = &settings->bus.sdio;
 	struct device_node *np = dev->of_node;
 	int irq;
 	u32 irqf;
 	u32 val;
 
-	if (!np || !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
+	if (!np || bus_type != BRCMF_BUSTYPE_SDIO ||
+	    !of_device_is_compatible(np, "brcm,bcm4329-fmac"))
 		return;
 
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.h
index a9d94c1..95b7032 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.h
@@ -14,9 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #ifdef CONFIG_OF
-void brcmf_of_probe(struct device *dev, struct brcmfmac_sdio_pd *sdio);
+void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
+		    struct brcmf_mp_device *settings);
 #else
-static void brcmf_of_probe(struct device *dev, struct brcmfmac_sdio_pd *sdio)
+static void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
+			   struct brcmf_mp_device *settings)
 {
 }
 #endif /* CONFIG_OF */
-- 
2.10.1
