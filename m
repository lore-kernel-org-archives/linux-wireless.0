Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82CCCC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 49D122075C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49D122075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbeJJSW4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:22:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25991 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeJJSW4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:22:56 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DCA9130821FF;
        Wed, 10 Oct 2018 11:01:18 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1EAEF2E03B;
        Wed, 10 Oct 2018 11:01:16 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 5/6] brcmfmac: Set board_type from DMI on x86 based machines
Date:   Wed, 10 Oct 2018 13:01:02 +0200
Message-Id: <20181010110103.21857-5-hdegoede@redhat.com>
In-Reply-To: <20181010110103.21857-1-hdegoede@redhat.com>
References: <20181010110103.21857-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 10 Oct 2018 11:01:19 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

For x86 based machines, set the board_type used for nvram file selection
based on the DMI sys-vendor and product-name strings.

Since on some models these strings are too generic, this commit also adds
a quirk table overriding the strings for models listed in that table.

The board_type setting is used to load the board-specific nvram file with
a board-specific name so that we can ship files for each supported board
in linux-firmware.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Use full ISC text for now instead of SPDX tag, because the ISC is not
 yet listed under LICENSES
---
 .../broadcom/brcm80211/brcmfmac/Makefile      |   2 +
 .../broadcom/brcm80211/brcmfmac/common.c      |   3 +-
 .../broadcom/brcm80211/brcmfmac/common.h      |   7 ++
 .../broadcom/brcm80211/brcmfmac/dmi.c         | 116 ++++++++++++++++++
 4 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
index 1f5a9b948abf..22fd95a736a8 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
@@ -54,3 +54,5 @@ brcmfmac-$(CONFIG_BRCM_TRACING) += \
 		tracepoint.o
 brcmfmac-$(CONFIG_OF) += \
 		of.o
+brcmfmac-$(CONFIG_DMI) += \
+		dmi.o
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index cd3651069d0c..a4bcbd1a57ac 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -450,8 +450,9 @@ struct brcmf_mp_device *brcmf_get_module_param(struct device *dev,
 		}
 	}
 	if (!found) {
-		/* No platform data for this device, try OF (Open Firwmare) */
+		/* No platform data for this device, try OF and DMI data */
 		brcmf_of_probe(dev, bus_type, settings);
+		brcmf_dmi_probe(settings, chip, chiprev);
 	}
 	return settings;
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
index e63a273642e9..4ce56be90b74 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.h
@@ -75,4 +75,11 @@ void brcmf_release_module_param(struct brcmf_mp_device *module_param);
 /* Sets dongle media info (drv_version, mac address). */
 int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
+#ifdef CONFIG_DMI
+void brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev);
+#else
+static inline void
+brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev) {}
+#endif
+
 #endif /* BRCMFMAC_COMMON_H */
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
new file mode 100644
index 000000000000..51d76ac45075
--- /dev/null
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/dmi.c
@@ -0,0 +1,116 @@
+/*
+ * Copyright 2018 Hans de Goede <hdegoede@redhat.com>
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
+
+#include <linux/dmi.h>
+#include <linux/mod_devicetable.h>
+#include "core.h"
+#include "common.h"
+#include "brcm_hw_ids.h"
+
+/* The DMI data never changes so we can use a static buf for this */
+static char dmi_board_type[128];
+
+struct brcmf_dmi_data {
+	u32 chip;
+	u32 chiprev;
+	const char *board_type;
+};
+
+/* NOTE: Please keep all entries sorted alphabetically */
+
+static const struct brcmf_dmi_data gpd_win_pocket_data = {
+	BRCM_CC_4356_CHIP_ID, 2, "gpd-win-pocket"
+};
+
+static const struct brcmf_dmi_data jumper_ezpad_mini3_data = {
+	BRCM_CC_43430_CHIP_ID, 0, "jumper-ezpad-mini3"
+};
+
+static const struct brcmf_dmi_data meegopad_t08_data = {
+	BRCM_CC_43340_CHIP_ID, 2, "meegopad-t08"
+};
+
+static const struct dmi_system_id dmi_platform_data[] = {
+	{
+		/* Match for the GPDwin which unfortunately uses somewhat
+		 * generic dmi strings, which is why we test for 4 strings.
+		 * Comparing against 23 other byt/cht boards, board_vendor
+		 * and board_name are unique to the GPDwin, where as only one
+		 * other board has the same board_serial and 3 others have
+		 * the same default product_name. Also the GPDwin is the
+		 * only device to have both board_ and product_name not set.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Default string"),
+			DMI_MATCH(DMI_BOARD_SERIAL, "Default string"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
+		},
+		.driver_data = (void *)&gpd_win_pocket_data,
+	},
+	{
+		/* Jumper EZpad mini3 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CherryTrail"),
+			/* jumperx.T87.KFBNEEA02 with the version-nr dropped */
+			DMI_MATCH(DMI_BIOS_VERSION, "jumperx.T87.KFBNEEA"),
+		},
+		.driver_data = (void *)&jumper_ezpad_mini3_data,
+	},
+	{
+		/* Meegopad T08 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Default string"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Default string"),
+			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
+			DMI_MATCH(DMI_BOARD_VERSION, "V1.1"),
+		},
+		.driver_data = (void *)&meegopad_t08_data,
+	},
+	{}
+};
+
+void brcmf_dmi_probe(struct brcmf_mp_device *settings, u32 chip, u32 chiprev)
+{
+	const struct dmi_system_id *match;
+	const struct brcmf_dmi_data *data;
+	const char *sys_vendor;
+	const char *product_name;
+
+	/* Some models have DMI strings which are too generic, e.g.
+	 * "Default string", we use a quirk table for these.
+	 */
+	for (match = dmi_first_match(dmi_platform_data);
+	     match;
+	     match = dmi_first_match(match + 1)) {
+		data = match->driver_data;
+
+		if (data->chip == chip && data->chiprev == chiprev) {
+			settings->board_type = data->board_type;
+			return;
+		}
+	}
+
+	/* Not found in the quirk-table, use sys_vendor-product_name */
+	sys_vendor = dmi_get_system_info(DMI_SYS_VENDOR);
+	product_name = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (sys_vendor && product_name) {
+		snprintf(dmi_board_type, sizeof(dmi_board_type), "%s-%s",
+			 sys_vendor, product_name);
+		settings->board_type = dmi_board_type;
+	}
+}
-- 
2.19.0

