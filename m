Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:36797 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab2HJGv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 02:51:27 -0400
Received: by mail-we0-f174.google.com with SMTP id x8so792295wey.19
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 23:51:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Florian Fainelli <f.fainelli@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2][PROOF][DONT APPLY] mtd: bcma_sflash driver
Date: Fri, 10 Aug 2012 08:51:15 +0200
Message-Id: <1344581475-11568-2-git-send-email-zajec5@gmail.com> (sfid-20120810_085133_566051_F0B67034)
In-Reply-To: <1344581475-11568-1-git-send-email-zajec5@gmail.com>
References: <1344581475-11568-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
This is only proof of concept, don't apply!
---
 drivers/mtd/devices/Makefile    |    1 +
 drivers/mtd/devices/b47sflash.c |  113 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/devices/b47sflash.c

diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index a4dd1d8..b449760 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -19,5 +19,6 @@ obj-$(CONFIG_MTD_DATAFLASH)	+= mtd_dataflash.o
 obj-$(CONFIG_MTD_M25P80)	+= m25p80.o
 obj-$(CONFIG_MTD_SPEAR_SMI)	+= spear_smi.o
 obj-$(CONFIG_MTD_SST25L)	+= sst25l.o
+obj-y				+= b47sflash.o
 
 CFLAGS_docg3.o			+= -I$(src)
\ No newline at end of file
diff --git a/drivers/mtd/devices/b47sflash.c b/drivers/mtd/devices/b47sflash.c
new file mode 100644
index 0000000..37080f2
--- /dev/null
+++ b/drivers/mtd/devices/b47sflash.c
@@ -0,0 +1,113 @@
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/mtd/mtd.h>
+#include <linux/platform_device.h>
+#include <linux/bcma/bcma.h>
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Broadcom serial flash driver");
+
+#if 0
+static const char *probes[] = { "bcm47xx", NULL };
+#endif
+
+static int b47sflash_read(struct mtd_info *mtd, loff_t from, size_t len,
+			  size_t *retlen, u_char *buf)
+{
+	//struct bcma_sflash *sflash = mtd->priv;
+	size_t bytes_read = 0;
+	u32 *src;
+	u32 *desc = (u32 *)buf;
+
+	/* Check address range */
+	if (!len)
+		return 0;
+
+	if ((from + len) > mtd->size)
+		return -EINVAL;
+
+	/* Is this an aligned access? */
+	if (from & 0x3)
+		return -EINVAL;
+
+	src = (u32 *)KSEG0ADDR(0x1c000000 + from);
+	while (bytes_read < len) {
+		*desc = readl(src);
+		desc++;
+		src++;
+		bytes_read += 4;
+	}
+
+	*retlen = bytes_read;
+
+	return 0;
+}
+
+static void b47sflash_fill_mtd(struct bcma_sflash *sflash, struct mtd_info *mtd)
+{
+	mtd->priv = sflash;
+	mtd->name = "b47sflash";
+	mtd->owner = THIS_MODULE;
+	mtd->_read = b47sflash_read;
+	mtd->size = sflash->size;
+}
+
+static int b47sflash_probe(struct platform_device *pdev)
+{
+	struct bcma_sflash *sflash = dev_get_platdata(&pdev->dev);
+	struct mtd_info *mtd;
+
+	mtd = kzalloc(sizeof(struct mtd_info), GFP_KERNEL);
+	if (!mtd)
+		return -ENOMEM;
+	b47sflash_fill_mtd(sflash, mtd);
+
+#if 0
+	err = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
+	if (err) {
+		pr_err("Failed to register MTD device: %d\n", err);
+		return err;
+	}
+#endif
+
+	return 0;
+}
+
+static int __devexit b47sflash_remove(struct platform_device *pdev)
+{
+	//struct mtd_info *mtd = dev_get_drvdata(&pdev->dev);
+	return 0;
+}
+
+static struct platform_driver bcma_sflash_driver = {
+	.remove = __devexit_p(b47sflash_remove),
+	.driver = {
+		.name = "bcma_sflash",
+		.owner = THIS_MODULE,
+	},
+};
+
+static int __init init_b47sflash(void)
+{
+	int err;
+
+	err = platform_driver_probe(&bcma_sflash_driver, b47sflash_probe);
+	if (err)
+		pr_err("Failed to register serial flash driver: %d\n", err);
+
+	return err;
+}
+
+static void __exit exit_b47sflash(void)
+{
+	platform_driver_unregister(&bcma_sflash_driver);
+}
+
+void b47sflash_early_mtd(struct bcma_sflash *sflash, struct mtd_info *mtd)
+{
+	b47sflash_fill_mtd(sflash, mtd);
+}
+
+module_init(init_b47sflash);
+module_exit(exit_b47sflash);
-- 
1.7.7

