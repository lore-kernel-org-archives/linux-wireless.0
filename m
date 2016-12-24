Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33957 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753547AbcLXQ5T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Dec 2016 11:57:19 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Tony Lindgren <tony@atomide.com>,
        Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for loading NVS calibration data
Date: Sat, 24 Dec 2016 17:52:57 +0100
Message-Id: <1482598381-16513-3-git-send-email-pali.rohar@gmail.com> (sfid-20161224_175739_877566_C7948942)
In-Reply-To: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
References: <1482598381-16513-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

NVS calibration data for wl1251 are model specific. Every one device with
wl1251 chip has different and calibrated in factory.

Not all wl1251 chips have own EEPROM where are calibration data stored. And
in that case there is no "standard" place. Every device has stored them on
different place (some in rootfs file, some in dedicated nand partition,
some in another proprietary structure).

Kernel wl1251 driver cannot support every one different storage decided by
device manufacture so it will use request_firmware_prefer_user() call for
loading NVS calibration data and userspace helper will be responsible to
prepare correct data.

In case userspace helper fails request_firmware_prefer_user() still try to
load data file directly from VFS as fallback mechanism.

On Nokia N900 device which has wl1251 chip, NVS calibration data are stored
in CAL nand partition. CAL is proprietary Nokia key/value format for nand
devices.

With this patch it is finally possible to load correct model specific NVS
calibration data for Nokia N900.

Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/Kconfig |    1 +
 drivers/net/wireless/ti/wl1251/main.c  |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/Kconfig b/drivers/net/wireless/ti/wl1251/Kconfig
index 7142ccf..affe154 100644
--- a/drivers/net/wireless/ti/wl1251/Kconfig
+++ b/drivers/net/wireless/ti/wl1251/Kconfig
@@ -2,6 +2,7 @@ config WL1251
 	tristate "TI wl1251 driver support"
 	depends on MAC80211
 	select FW_LOADER
+	select FW_LOADER_USER_HELPER
 	select CRC7
 	---help---
 	  This will enable TI wl1251 driver support. The drivers make
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index 208f062..24f8866 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -110,7 +110,7 @@ static int wl1251_fetch_nvs(struct wl1251 *wl)
 	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, WL1251_NVS_NAME, dev);
+	ret = request_firmware_prefer_user(&fw, WL1251_NVS_NAME, dev);
 
 	if (ret < 0) {
 		wl1251_error("could not get nvs file: %d", ret);
-- 
1.7.9.5
