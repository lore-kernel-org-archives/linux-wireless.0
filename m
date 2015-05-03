Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:6861 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbbECP0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 May 2015 11:26:22 -0400
Message-ID: <55463E19.7070709@linux.intel.com> (sfid-20150503_172652_654148_2902CAE4)
Date: Sun, 03 May 2015 23:26:17 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
MIME-Version: 1.0
To: "brudley@broadcom.com" <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	"meuleman@broadcom.com" <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	"pieterpg@broadcom.com" <pieterpg@broadcom.com>,
	"hdegoede@redhat.com" <hdegoede@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] brcmfmac: prohibit ACPI power management for brcmfmac
 driver
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ACPI will manage WiFi chip's power state during suspend/resume
process on some tablet platforms(such as ASUS T100TA). This is
not supported by brcmfmac driver now, and the context of WiFi
chip will be damaged after resume. This patch informs ACPI not
to manage WiFi chip's power state.

Signed-off-by: Zhonghui Fu <zhonghui.fu@linux.intel.com>
---
Changes in v2:
- Another implementation.

 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index 9b508bd..6c519e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -33,6 +33,7 @@
 #include <linux/suspend.h>
 #include <linux/errno.h>
 #include <linux/module.h>
+#include <linux/acpi.h>
 #include <net/cfg80211.h>
 
 #include <defs.h>
@@ -1114,6 +1115,8 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	int err;
 	struct brcmf_sdio_dev *sdiodev;
 	struct brcmf_bus *bus_if;
+	struct device *dev;
+	struct acpi_device *adev;
 
 	brcmf_dbg(SDIO, "Enter\n");
 	brcmf_dbg(SDIO, "Class=%x\n", func->class);
@@ -1121,6 +1124,11 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	brcmf_dbg(SDIO, "sdio device ID: 0x%04x\n", func->device);
 	brcmf_dbg(SDIO, "Function#: %d\n", func->num);
 
+	/* prohibit ACPI power management for this device */
+	dev = &func->dev;
+	if (adev = ACPI_COMPANION(dev))
+		adev->flags.power_manageable = 0;
+
 	/* Consume func num 1 but dont do anything with it. */
 	if (func->num == 1)
 		return 0;
-- 1.7.1

