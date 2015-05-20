Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:18322 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbbETLs4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 07:48:56 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Ralf Baechle <ralf@linux-mips.org>
CC: <linux-mip@linux-mips.org>, <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] mips: bcm47xx: allow retrieval of complete nvram contents
Date: Wed, 20 May 2015 13:48:51 +0200
Message-ID: <1432122531-3106-1-git-send-email-arend@broadcom.com> (sfid-20150520_134900_134764_8642B775)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Host platforms such as routers supported by OpenWRT can
support NVRAM reading directly from internal NVRAM store.
The brcmfmac for one requires the complete nvram contents
to select what needs to be sent to wireless device.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 arch/mips/bcm47xx/nvram.c     | 40 +++++++++++++++++++++++++++++++++-------
 include/linux/bcm47xx_nvram.h | 15 +++++++++++++++
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
index ba632ff..3bb7f41 100644
--- a/arch/mips/bcm47xx/nvram.c
+++ b/arch/mips/bcm47xx/nvram.c
@@ -138,6 +138,7 @@ static int nvram_init(void)
 #ifdef CONFIG_MTD
 	struct mtd_info *mtd;
 	struct nvram_header header;
+	struct nvram_header *pheader;
 	size_t bytes_read;
 	int err;
 
@@ -146,20 +147,21 @@ static int nvram_init(void)
 		return -ENODEV;
 
 	err = mtd_read(mtd, 0, sizeof(header), &bytes_read, (uint8_t *)&header);
-	if (!err && header.magic == NVRAM_MAGIC) {
-		u8 *dst = (uint8_t *)nvram_buf;
-		size_t len = header.len;
-
-		if (header.len > NVRAM_SPACE) {
+	if (!err && header.magic == NVRAM_MAGIC &&
+	    header.len > sizeof(header)) {
+		if (header.len > NVRAM_SPACE - 2) {
 			pr_err("nvram on flash (%i bytes) is bigger than the reserved space in memory, will just copy the first %i bytes\n",
 				header.len, NVRAM_SPACE);
-			len = NVRAM_SPACE;
+			header.len = NVRAM_SPACE - 2;
 		}
 
-		err = mtd_read(mtd, 0, len, &bytes_read, dst);
+		err = mtd_read(mtd, 0, header.len, &bytes_read,
+			       (u8 *)nvram_buf);
 		if (err)
 			return err;
 
+		pheader = (struct nvram_header *)nvram_buf;
+		pheader->len = header.len;
 		return 0;
 	}
 #endif
@@ -221,3 +223,27 @@ int bcm47xx_nvram_gpio_pin(const char *name)
 	return -ENOENT;
 }
 EXPORT_SYMBOL(bcm47xx_nvram_gpio_pin);
+
+char *bcm47xx_nvram_get_contents(size_t *nvram_size)
+{
+	int err;
+	char *nvram;
+	struct nvram_header *header;
+
+	if (!nvram_buf[0]) {
+		err = nvram_init();
+		if (err)
+			return NULL;
+	}
+
+	header = (struct nvram_header *)nvram_buf;
+	*nvram_size = header->len - sizeof(struct nvram_header);
+	nvram = vmalloc(*nvram_size);
+	if (!nvram)
+		return NULL;
+	memcpy(nvram, &nvram_buf[sizeof(struct nvram_header)], *nvram_size);
+
+	return nvram;
+}
+EXPORT_SYMBOL(bcm47xx_nvram_get_contents);
+
diff --git a/include/linux/bcm47xx_nvram.h b/include/linux/bcm47xx_nvram.h
index b12b07e..c73927c 100644
--- a/include/linux/bcm47xx_nvram.h
+++ b/include/linux/bcm47xx_nvram.h
@@ -10,11 +10,17 @@
 
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/vmalloc.h>
 
 #ifdef CONFIG_BCM47XX
 int bcm47xx_nvram_init_from_mem(u32 base, u32 lim);
 int bcm47xx_nvram_getenv(const char *name, char *val, size_t val_len);
 int bcm47xx_nvram_gpio_pin(const char *name);
+char *bcm47xx_nvram_get_contents(size_t *val_len);
+static inline void bcm47xx_nvram_release_contents(char *nvram)
+{
+	vfree(nvram);
+};
 #else
 static inline int bcm47xx_nvram_init_from_mem(u32 base, u32 lim)
 {
@@ -29,6 +35,15 @@ static inline int bcm47xx_nvram_gpio_pin(const char *name)
 {
 	return -ENOTSUPP;
 };
+
+static inline char *bcm47xx_nvram_get_contents(size_t *val_len)
+{
+	return NULL;
+};
+
+static inline void bcm47xx_nvram_release_contents(char *nvram)
+{
+};
 #endif
 
 #endif /* __BCM47XX_NVRAM_H */
-- 
1.9.1

