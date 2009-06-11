Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1640 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758251AbZFKCDp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 2/7] wl12xx: use wiphy_dev instead of wl->spi->dev
Date: Wed, 10 Jun 2009 22:02:55 -0400
Message-Id: <1244685780-28930-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove a dependency on the bus-specific struct device by using wiphy_dev
when requesting firmware.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9ecfb9e..5e975c8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -75,9 +75,10 @@ static irqreturn_t wl12xx_irq(int irq, void *cookie)
 static int wl12xx_fetch_firmware(struct wl12xx *wl)
 {
 	const struct firmware *fw;
+	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.fw_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.fw_filename, dev);
 
 	if (ret < 0) {
 		wl12xx_error("could not get firmware: %d", ret);
@@ -113,9 +114,10 @@ out:
 static int wl12xx_fetch_nvs(struct wl12xx *wl)
 {
 	const struct firmware *fw;
+	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.nvs_filename, &wl->spi->dev);
+	ret = request_firmware(&fw, wl->chip.nvs_filename, dev);
 
 	if (ret < 0) {
 		wl12xx_error("could not get nvs file: %d", ret);
-- 
1.6.0.6


