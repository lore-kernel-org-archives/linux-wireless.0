Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64821 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1CRMxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 08:53:20 -0400
Received: by ywj3 with SMTP id 3so1546211ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 05:53:20 -0700 (PDT)
From: Arik Nemtsov <ido@wizery.com>
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Ido Yariv <ido@wizery.com>
Subject: [PATCH] wl12xx: Clamp byte mode transfers for 128x chips
Date: Fri, 18 Mar 2011 14:49:57 +0200
Message-Id: <1300452597-13281-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On wl128x based devices, when TX packets are aggregated, each packet
size must be aligned to the SDIO block size, and sent using block mode
transfers.

The block size is set to 256 bytes, which is less than the maximum
possible byte transfer. Thus, if two small packets (< 256 bytes) are
aggregated, the aggregation buffer size would be 512, and will be sent
using byte mode transfers. This can have undesired side effects.

Fix this by setting the MMC_QUIRK_BLKSZ_FOR_BYTE_MODE mmc card quirk.
For 127x chips this has no effect, as the block size is set to 512
bytes.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/sdio.c      |    3 +++
 drivers/net/wireless/wl12xx/sdio_test.c |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/sdio.c b/drivers/net/wireless/wl12xx/sdio.c
index ff77361..26dcd44 100644
--- a/drivers/net/wireless/wl12xx/sdio.c
+++ b/drivers/net/wireless/wl12xx/sdio.c
@@ -246,6 +246,9 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
+	/* Use block mode for transferring over one block size of data */
+	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
+
 	wlan_data = wl12xx_get_platform_data();
 	if (IS_ERR(wlan_data)) {
 		ret = PTR_ERR(wlan_data);
diff --git a/drivers/net/wireless/wl12xx/sdio_test.c b/drivers/net/wireless/wl12xx/sdio_test.c
index 968249a..f289153 100644
--- a/drivers/net/wireless/wl12xx/sdio_test.c
+++ b/drivers/net/wireless/wl12xx/sdio_test.c
@@ -417,6 +417,9 @@ static int __devinit wl1271_probe(struct sdio_func *func,
 	/* Grab access to FN0 for ELP reg. */
 	func->card->quirks |= MMC_QUIRK_LENIENT_FN0;
 
+	/* Use block mode for transferring over one block size of data */
+	func->card->quirks |= MMC_QUIRK_BLKSZ_FOR_BYTE_MODE;
+
 	wlan_data = wl12xx_get_platform_data();
 	if (IS_ERR(wlan_data)) {
 		ret = PTR_ERR(wlan_data);
-- 
1.7.1

