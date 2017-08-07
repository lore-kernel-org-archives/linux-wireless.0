Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:54229 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdHGHb7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 03:31:59 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: [v5] wlcore: add missing nvs file name info for wilink8
Date: Mon, 7 Aug 2017 07:31:51 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B3641E25B@DFRE01.ent.ti.com> (sfid-20170807_093212_689390_9C161C5B)
References: <1502090869-8833-1-git-send-email-eyalr@ti.com>
In-Reply-To: <1502090869-8833-1-git-send-email-eyalr@ti.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits:
c815fde wlcore: spi: Populate config firmware data
d776fc8 wlcore: sdio: Populate config firmware data

Populated the nvs entry for wilink6 and wilink7 only while it is
still needed for wilink8 as well.
This broke user space backward compatibility when upgrading from older
kernels, as the alternate mac address would not be read from the nvs that i=
s
present in the file system (lib/firmware/ti-connectivity/wl1271-nvs.bin)
causing mac address change of the wlan interface.

This patch fix this and update the structure field with the same default
nvs file name that has been used before.

In addition, some distros hold a default wl1271-nvs.bin in the file
system with a bogus mac address (deadbeef...) that for a wl18xx device
also overrides the mac address that is stored inside the device.
Warn users about this bogus mac address and use a random mac instead

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
v2->v3: add a check for default deadbeef... mac address and warn about it
v3->v4: use a random TI mac address instead of the bogus one
v4->v5: add constant definition for TI oui address
---
 drivers/net/wireless/ti/wlcore/main.c   | 16 ++++++++++++++++
 drivers/net/wireless/ti/wlcore/sdio.c   |  1 +
 drivers/net/wireless/ti/wlcore/spi.c    |  1 +
 drivers/net/wireless/ti/wlcore/wlcore.h |  3 +++
 4 files changed, 21 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index 60aaa85..257831a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5961,6 +5961,22 @@ static void wl12xx_derive_mac_addresses(struct wl127=
1 *wl, u32 oui, u32 nic)
 	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr > 0xffffff)
 		wl1271_warning("NIC part of the MAC address wraps around!");
=20
+	if (oui =3D=3D 0xdeadbe && nic =3D=3D 0xef0000) {
+		wl1271_warning("Detected unconfigured mac address in nvs.\n"
+				"Using a random TI mac address instead.\n"
+				"in case of using a wl12xx device, your "
+				"device performance may not be optimized.\n"
+				"Please use the calibrator tool to configure "
+				"your device.\n"
+				"When using a wl18xx device the nvs file can "
+				"be removed as a default mac address is "
+				"stored internally.\n");
+
+		/* Use TI oui and a random nic */
+		oui =3D WLCORE_TI_OUI_ADDRESS;
+		nic =3D get_random_int();
+	}
+
 	for (i =3D 0; i < wl->num_mac_addr; i++) {
 		wl->addresses[i].addr[0] =3D (u8)(oui >> 16);
 		wl->addresses[i].addr[1] =3D (u8)(oui >> 8);
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
