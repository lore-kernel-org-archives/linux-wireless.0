Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:34402 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbbEFBEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 21:04:08 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: rusty@rustcorp.com.au, dhowells@redhat.com, ming.lei@canonical.com,
	seth.forshee@canonical.com, kyle@kernel.org
Cc: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
	keescook@chromium.org, casey@schaufler-ca.com, tiwai@suse.de,
	mjg59@srcf.ucam.org, wireless-regdb@lists.infradead.org,
	linux-wireless@vger.kernel.org, jlee@suse.com,
	linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 08/12] p54spi: use sysdata_file_request() for EEPROM optional system data
Date: Tue,  5 May 2015 17:44:26 -0700
Message-Id: <1430873070-7290-9-git-send-email-mcgrof@do-not-panic.com> (sfid-20150506_030429_943842_C63ADB7C)
In-Reply-To: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
References: <1430873070-7290-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This converts the driver over from request_firmware_direct() to
the sysdata_file_request().

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 drivers/net/wireless/p54/p54spi.c | 49 +++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/p54/p54spi.c b/drivers/net/wireless/p54/p54spi.c
index 63de5ee..0950ed6 100644
--- a/drivers/net/wireless/p54/p54spi.c
+++ b/drivers/net/wireless/p54/p54spi.c
@@ -24,6 +24,7 @@
 #include <linux/platform_device.h>
 #include <linux/interrupt.h>
 #include <linux/firmware.h>
+#include <linux/sysdata.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
 #include <linux/spi/spi.h>
@@ -184,33 +185,41 @@ static int p54spi_request_firmware(struct ieee80211_hw *dev)
 	return 0;
 }
 
-static int p54spi_request_eeprom(struct ieee80211_hw *dev)
+static int p54spi_load_new_eeprom(void *context,
+				  const struct sysdata_file *sysdata)
 {
-	struct p54s_priv *priv = dev->priv;
-	const struct firmware *eeprom;
+	struct ieee80211_hw *dev = context;
 	int ret;
 
-	/* allow users to customize their eeprom.
-	 */
+	ret = p54_parse_eeprom(dev, (void *) sysdata->data,
+			       sysdata->size);
+	release_sysdata_file(sysdata);
 
-	ret = request_firmware_direct(&eeprom, "3826.eeprom", &priv->spi->dev);
-	if (ret < 0) {
-#ifdef CONFIG_P54_SPI_DEFAULT_EEPROM
-		dev_info(&priv->spi->dev, "loading default eeprom...\n");
-		ret = p54_parse_eeprom(dev, (void *) p54spi_eeprom,
-				       sizeof(p54spi_eeprom));
-#else
-		dev_err(&priv->spi->dev, "Failed to request user eeprom\n");
-#endif /* CONFIG_P54_SPI_DEFAULT_EEPROM */
-	} else {
-		dev_info(&priv->spi->dev, "loading user eeprom...\n");
-		ret = p54_parse_eeprom(dev, (void *) eeprom->data,
-				       (int)eeprom->size);
-		release_firmware(eeprom);
-	}
 	return ret;
 }
 
+static int p54spi_load_default_eeprom(void *context)
+{
+	struct ieee80211_hw *dev = context;
+
+	return p54_parse_eeprom(dev, (void *) p54spi_eeprom,
+				sizeof(p54spi_eeprom));
+}
+
+static int p54spi_request_eeprom(struct ieee80211_hw *dev)
+{
+	struct p54s_priv *priv = dev->priv;
+	const struct sysdata_file_desc p54_spi_eeprom_sysdata = {
+		SYSDATA_DEFAULT_SYNC(p54spi_load_new_eeprom, dev),
+		.optional = !IS_ENABLED(CONFIG_P54_SPI_DEFAULT_EEPROM),
+		SYSDATA_SYNC_OPT_CB(p54spi_load_default_eeprom, dev),
+	};
+
+	return sysdata_file_request("3826.eeprom",
+				    &p54_spi_eeprom_sysdata,
+				    &priv->spi->dev);
+}
+
 static int p54spi_upload_firmware(struct ieee80211_hw *dev)
 {
 	struct p54s_priv *priv = dev->priv;
-- 
2.3.2.209.gd67f9d5.dirty

