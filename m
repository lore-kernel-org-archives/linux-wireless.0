Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65455 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2FYUMm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 16:12:42 -0400
Received: by weyu7 with SMTP id u7so3074649wey.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 13:12:41 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] bcma: define some additional cores IDs
Date: Mon, 25 Jun 2012 22:12:20 +0200
Message-Id: <1340655140-28950-1-git-send-email-zajec5@gmail.com> (sfid-20120625_221246_049635_576DA2C7)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of them are BCM4706 specific AFAWK. Most of them was confirmed on
Netgear WNDR450.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/scan.c       |    6 ++++++
 include/linux/bcma/bcma.h |    7 +++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/scan.c b/drivers/bcma/scan.c
index 5ed0718..a342058 100644
--- a/drivers/bcma/scan.c
+++ b/drivers/bcma/scan.c
@@ -28,6 +28,12 @@ static const struct bcma_device_id_name bcma_arm_device_names[] = {
 
 static const struct bcma_device_id_name bcma_bcm_device_names[] = {
 	{ BCMA_CORE_OOB_ROUTER, "OOB Router" },
+	{ BCMA_CORE_4706_CHIPCOMMON, "BCM4706 ChipCommon" },
+	{ BCMA_CORE_4706_SOC_RAM, "BCM4706 SOC RAM" },
+	{ BCMA_CORE_4706_MAC_GBIT, "BCM4706 GBit MAC" },
+	{ BCMA_CORE_AMEMC, "AMEMC (DDR)" },
+	{ BCMA_CORE_ALTA, "ALTA (I2S)" },
+	{ BCMA_CORE_4706_MAC_GBIT_COMMON, "BCM4706 GBit MAC Common" },
 	{ BCMA_CORE_INVALID, "Invalid" },
 	{ BCMA_CORE_CHIPCOMMON, "ChipCommon" },
 	{ BCMA_CORE_ILINE20, "ILine 20" },
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 8deaf6d..12334f9 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -70,6 +70,13 @@ struct bcma_host_ops {
 
 /* Core-ID values. */
 #define BCMA_CORE_OOB_ROUTER		0x367	/* Out of band */
+#define BCMA_CORE_4706_CHIPCOMMON	0x500
+#define BCMA_CORE_4706_SOC_RAM		0x50E
+#define BCMA_CORE_4706_MAC_GBIT		0x52D
+#define BCMA_CORE_AMEMC			0x52E	/* DDR1/2 memory controller core */
+#define BCMA_CORE_ALTA			0x534	/* I2S core */
+#define BCMA_CORE_4706_MAC_GBIT_COMMON	0x5DC
+#define BCMA_CORE_DDR23_PHY		0x5DD
 #define BCMA_CORE_INVALID		0x700
 #define BCMA_CORE_CHIPCOMMON		0x800
 #define BCMA_CORE_ILINE20		0x801
-- 
1.7.7

