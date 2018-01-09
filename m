Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:45271 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932231AbeAIBj2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 20:39:28 -0500
From: AceLan Kao <acelan.kao@canonical.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: add a quirk to set use_msi automatically
Date: Tue,  9 Jan 2018 09:39:22 +0800
Message-Id: <1515461962-27129-1-git-send-email-acelan.kao@canonical.com> (sfid-20180109_024115_158192_96FE29AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some platform(BIOS) blocks legacy interrupts (INTx), and only allows MSI
for WLAN device. So adding a quirk to list those machines and set
use_msi automatically.
Adding the following platforms to the quirk.
   Dell Inspiron 24-3460
   Dell Inspiron 3472
   Dell Inspiron 14-3473
   Dell Vostro 3262
   Dell Vostro 15-3572

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 43adead..e479fae 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <linux/relay.h>
+#include <linux/dmi.h>
 #include <net/ieee80211_radiotap.h>
 
 #include "ath9k.h"
@@ -96,6 +97,56 @@ static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
 };
 #endif
 
+static int __init set_use_msi(const struct dmi_system_id *dmi)
+{
+	ath9k_use_msi = 1;
+	return 1;
+}
+
+static const struct dmi_system_id ath9k_quirks[] __initconst = {
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Inspiron 24-3460",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 24-3460"),
+		},
+	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Vostro 3262",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 3262"),
+		},
+	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Inspiron 3472",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 3472"),
+		},
+	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Vostro 15-3572",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 15-3572"),
+		},
+	},
+	{
+		.callback = set_use_msi,
+		.ident = "Dell Inspiron 14-3473",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 14-3473"),
+		},
+	},
+	{}
+};
+
 static void ath9k_deinit_softc(struct ath_softc *sc);
 
 static void ath9k_op_ps_wakeup(struct ath_common *common)
@@ -1104,6 +1155,8 @@ static int __init ath9k_init(void)
 		goto err_pci_exit;
 	}
 
+	dmi_check_system(ath9k_quirks);
+
 	return 0;
 
  err_pci_exit:
-- 
2.7.4
