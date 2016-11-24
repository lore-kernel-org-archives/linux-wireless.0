Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35862 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932185AbcKXIVY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Nov 2016 03:21:24 -0500
From: Kirtika Ruchandani <kirtika.ruchandani@gmail.com>
Date: Thu, 24 Nov 2016 00:02:43 -0800
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Raja Mani <rmani@qti.qualcomm.com>,
        Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/5] ath10k: Removed unused 'dev' in ath10k_ahb_resource_init
Message-ID: <7d837ab7846f83add2f5e289ece94d0dbeb82eed.1479974100.git.kirtika@chromium.org> (sfid-20161124_092145_479074_4E69AC92)
References: <cover.1479974100.git.kirtika@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <cover.1479974100.git.kirtika@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 704dc4e36769 introduced ath10k_ahb_resource_init() which
defines and sets 'struct device* dev' but does not use it.
Compiling with W=1 gives the following warning, fix it.

drivers/net/wireless/ath/ath10k/ahb.c: In function ‘ath10k_ahb_resource_init’:
drivers/net/wireless/ath/ath10k/ahb.c:449:17: warning: variable ‘dev’ set but not used [-Wunused-but-set-variable]

This is a harmless warning, and is only being fixed to reduce the
noise with W=1 in the kernel.

Fixes: 704dc4e36769 ("ath10k: add resource init and deinit in ahb")
Cc: Raja Mani <rmani@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Kirtika Ruchandani <kirtika@chromium.org>
---
 drivers/net/wireless/ath/ath10k/ahb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index 8078d64..19507fe 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -443,12 +443,10 @@ static int ath10k_ahb_resource_init(struct ath10k *ar)
 {
	struct ath10k_ahb *ar_ahb = ath10k_ahb_priv(ar);
	struct platform_device *pdev;
-	struct device *dev;
	struct resource *res;
	int ret;

	pdev = ar_ahb->pdev;
-	dev = &pdev->dev;

	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
	if (!res) {
--
2.8.0.rc3.226.g39d4020
