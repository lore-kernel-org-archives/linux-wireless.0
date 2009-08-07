Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53252 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757392AbZHGKdN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:33:13 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 03/23] wl1251: use wiphy_dev instead of wl->spi->dev
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:33:04 +0300
Message-ID: <20090807103303.31717.44884.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

Remove a dependency on the bus-specific struct device by using wiphy_dev
when requesting firmware.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index a858e4d..953cdb4 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -75,9 +75,10 @@ static irqreturn_t wl1251_irq(int irq, void *cookie)
 static int wl1251_fetch_firmware(struct wl1251 *wl)
 {
 	const struct firmware *fw;
+	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.fw_filename, dev);
 
 	if (ret < 0) {
 		wl1251_error("could not get firmware: %d", ret);
@@ -113,9 +114,10 @@ out:
 static int wl1251_fetch_nvs(struct wl1251 *wl)
 {
 	const struct firmware *fw;
+	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.nvs_filename, dev);
 
 	if (ret < 0) {
 		wl1251_error("could not get nvs file: %d", ret);

