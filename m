Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367AbaFPR5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 13:57:34 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 2/4] brcmfmac: add device tree support for SDIO devices
Date: Mon, 16 Jun 2014 19:56:45 +0200
Message-Id: <1402941407-8210-3-git-send-email-hdegoede@redhat.com> (sfid-20140616_195737_318704_30BCF433)
In-Reply-To: <1402941407-8210-1-git-send-email-hdegoede@redhat.com>
References: <1402941407-8210-1-git-send-email-hdegoede@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chen-Yu Tsai <wens@csie.org>

brcmfmac devices can use an out-of-band interrupt on a GPIO line.
Currently this is specified using platform data. Add support for
specifying out-of-band interrupt via device tree.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
[arend@broadcom.com: conditionalize more of-code, use driver debug routines]
Signed-off-by: Arend van Spriel <arend@broadcom.com>
[hdegoede@redhat.com: drop clk / reg_on gpio handling, as there is no consensus
 on how to handle this yet]
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile |  2 +
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |  4 ++
 drivers/net/wireless/brcm80211/brcmfmac/of.c     | 56 ++++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/of.h     | 22 ++++++++++
 4 files changed, 84 insertions(+)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/of.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/of.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 98e67c1..e2752cb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -44,3 +44,5 @@ brcmfmac-$(CONFIG_BRCMDBG) += \
 		dhd_dbg.o
 brcmfmac-$(CONFIG_BRCM_TRACING) += \
 		tracepoint.o
+brcmfmac-$(CONFIG_OF) += \
+		of.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
index a16e644..0fc707c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c
@@ -43,6 +43,7 @@
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 #include "sdio_host.h"
+#include "of.h"
 
 #define SDIOH_API_ACCESS_RETRY_LIMIT	2
 
@@ -1043,6 +1044,9 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 	sdiodev->dev = &sdiodev->func[1]->dev;
 	sdiodev->pdata = brcmfmac_sdio_pdata;
 
+	if (!sdiodev->pdata)
+		brcmf_of_probe(sdiodev);
+
 	atomic_set(&sdiodev->suspend, false);
 	init_waitqueue_head(&sdiodev->request_word_wait);
 	init_waitqueue_head(&sdiodev->request_buffer_wait);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
new file mode 100644
index 0000000..78ff906
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -0,0 +1,56 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/init.h>
+#include <linux/of.h>
+#include <linux/of_irq.h>
+#include <linux/mmc/card.h>
+#include <linux/platform_data/brcmfmac-sdio.h>
+#include <linux/mmc/sdio_func.h>
+
+#include <defs.h>
+#include "dhd_dbg.h"
+#include "sdio_host.h"
+
+void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
+{
+	struct device *dev = sdiodev->dev;
+	struct device_node *np = dev->of_node;
+	int irq;
+	u32 irqf;
+	u32 val;
+
+	if (!np || !of_device_is_compatible(np, "brcm,bcm43xx-fmac"))
+		return;
+
+	sdiodev->pdata = devm_kzalloc(dev, sizeof(*sdiodev->pdata), GFP_KERNEL);
+	if (!sdiodev->pdata)
+		return;
+
+	irq = irq_of_parse_and_map(np, 0);
+	if (irq < 0) {
+		brcmf_err("interrupt could not be mapped: err=%d\n", irq);
+		devm_kfree(dev, sdiodev->pdata);
+		return;
+	}
+	irqf = irqd_get_trigger_type(irq_get_irq_data(irq));
+
+	sdiodev->pdata->oob_irq_supported = true;
+	sdiodev->pdata->oob_irq_nr = irq;
+	sdiodev->pdata->oob_irq_flags = irqf;
+
+	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
+		sdiodev->pdata->drive_strength = val;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.h b/drivers/net/wireless/brcm80211/brcmfmac/of.h
new file mode 100644
index 0000000..5f7c355
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.h
@@ -0,0 +1,22 @@
+/*
+ * Copyright (c) 2014 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifdef CONFIG_OF
+void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev);
+#else
+static void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
+{
+}
+#endif /* CONFIG_OF */
-- 
2.0.0

