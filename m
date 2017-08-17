Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:14906 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdHQH30 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 03:29:26 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: [v8] wlcore: add missing nvs file name info for   wilink8
Date: Thu, 17 Aug 2017 07:29:18 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36428C6D@DFRE01.ent.ti.com> (sfid-20170817_092959_899570_9F9D8095)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits:
commit c815fdebef44 ("wlcore: spi: Populate config firmware data")
commit d776fc86b82f ("wlcore: sdio: Populate config firmware data")

Populated the nvs entry for wilink6 and wilink7 only while it is
still needed for wilink8 as well.
This broke user space backward compatibility when upgrading from older
kernels, as the alternate mac address would not be read from the nvs that
is present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
causing mac address change of the wlan interface.

This patch fix this and update the structure field with the same default
nvs file name that has been used before.

In addition, some distros hold a default wl1271-nvs.bin in the file
system with a bogus mac address (deadbeef...) that overrides the mac
address that is stored inside the device.
Warn users about this bogus mac address and use the internal mac address

Fixes: c815fdebef44 ("wlcore: spi: Populate config firmware data")
Fixes: d776fc86b82f ("wlcore: sdio: Populate config firmware data")
Signed-off-by: Eyal Reizer <eyalr@ti.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Tested-by: Tony Lindgren <tony@atomide.com>
---
v2->v3: add a check for default deadbeef... mac address and warn about it
v3->v4: use a random TI mac address instead of the bogus one
v4->v5: add constant definition for TI oui address
v5->v6: after also verifying on wilink6/7 Use internal mac address
instead of a random one
v6->v7: use random mac in case internal mac is zero
v7->v8: adjust warning message based on wilink family (wl12xx/wl18xx)
---
 drivers/net/wireless/ti/wlcore/main.c   | 23 +++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/sdio.c   |  1 +
 drivers/net/wireless/ti/wlcore/spi.c    |  1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |  3 +++
 4 files changed, 28 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index 60aaa85..2c80cea 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6016,6 +6016,8 @@ static int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
 	u32 oui_addr =3D 0, nic_addr =3D 0;
+	struct platform_device *pdev =3D wl->pdev;
+	struct wlcore_platdev_data *pdev_data =3D dev_get_platdata(&pdev->dev);
=20
 	if (wl->mac80211_registered)
 		return 0;
@@ -6040,6 +6042,27 @@ static int wl1271_register_hw(struct wl1271 *wl)
 		nic_addr =3D wl->fuse_nic_addr + 1;
 	}
=20
+	if (oui_addr =3D=3D 0xdeadbe && nic_addr =3D=3D 0xef0000) {
+		wl1271_warning("Detected unconfigured mac address in nvs, derive from fu=
se instead.\n");
+		if (!strcmp(pdev_data->family->name, "wl12xx")) {
+			wl1271_warning("Your device performance is not optimized.\n");
+			wl1271_warning("Please use the calibrator tool to configure your device=
.\n");
+		} else {
+			wl1271_warning("This default nvs file can be removed from the file syst=
em\n");
+		}
+
+		if (wl->fuse_oui_addr =3D=3D 0 && wl->fuse_nic_addr =3D=3D 0) {
+			wl1271_warning("Fuse mac address is zero. using random mac\n");
+			/* Use TI oui and a random nic */
+			oui_addr =3D WLCORE_TI_OUI_ADDRESS;
+			nic_addr =3D get_random_int();
+		} else {
+			oui_addr =3D wl->fuse_oui_addr;
+			/* fuse has the BD_ADDR, the WLAN addresses are the next two */
+			nic_addr =3D wl->fuse_nic_addr + 1;
+		}
+	}
+
 	wl12xx_derive_mac_addresses(wl, oui_addr, nic_addr);
=20
 	ret =3D ieee80211_register_hw(wl->hw);
diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/t=
i/wlcore/sdio.c
index 2fb3871..f8a1fea 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -230,6 +230,7 @@ static const struct wilink_family_data wl128x_data =3D =
{
 static const struct wilink_family_data wl18xx_data =3D {
 	.name =3D "wl18xx",
 	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
+	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
 };
=20
 static const struct of_device_id wlcore_sdio_of_match_table[] =3D {
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti=
/wlcore/spi.c
index fdabb92..62ce54a 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -92,6 +92,7 @@ static const struct wilink_family_data wl128x_data =3D {
 static const struct wilink_family_data wl18xx_data =3D {
 	.name =3D "wl18xx",
 	.cfg_name =3D "ti-connectivity/wl18xx-conf.bin",
+	.nvs_name =3D "ti-connectivity/wl1271-nvs.bin",
 };
=20
 struct wl12xx_spi_glue {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless=
/ti/wlcore/wlcore.h
index 1827546..95fbedc 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -40,6 +40,9 @@
 /* wl12xx/wl18xx maximum transmission power (in dBm) */
 #define WLCORE_MAX_TXPWR        25
=20
+/* Texas Instruments pre assigned OUI */
+#define WLCORE_TI_OUI_ADDRESS 0x080028
+
 /* forward declaration */
 struct wl1271_tx_hw_descr;
 enum wl_rx_buf_align;
--=20
2.7.4
