Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:60282 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936103AbdGTMR3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Jul 2017 08:17:29 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>
Subject: [v3] wlcore: add missing nvs file name info for wilink8
Date: Thu, 20 Jul 2017 12:16:36 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36409500@DFRE01.ent.ti.com> (sfid-20170720_142408_322319_7A8A008A)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits:
c815fde wlcore: spi: Populate config firmware data
d776fc8 wlcore: sdio: Populate config firmware data

Populated the nvs entry for wilink6 and wilink7 only while it is=20
still needed for wilink8 as well.=20
This broke user space backward compatibility when upgrading from older=20
kernels, as the alternate mac address would not be read from the nvs that i=
s=20
already present in the file system (lib/firmware/ti-connectivity/wl1271-nvs=
.bin)=20
causing mac address change of the wlan interface.

This patch fix this and update the structure field with the same default nv=
s file=20
name that has been used before.

In addition, some distros hold a default wl1271-nvs.bin in the file
system with a bogus mac address (deadbeef...) that for a wl18xx device
also overrides the mac address that is stored inside the device.
Warn users about this bogus mac address.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
v2->v3: add a check for default deadbeef... mac address and warn about it

 drivers/net/wireless/ti/wlcore/main.c | 10 ++++++++++
 drivers/net/wireless/ti/wlcore/sdio.c |  1 +
 drivers/net/wireless/ti/wlcore/spi.c  |  1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index 60aaa85..37c35aa 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5961,6 +5961,16 @@ static void wl12xx_derive_mac_addresses(struct wl127=
1 *wl, u32 oui, u32 nic)
 	if (nic + WLCORE_NUM_MAC_ADDRESSES - wl->num_mac_addr > 0xffffff)
 		wl1271_warning("NIC part of the MAC address wraps around!");
=20
+	if (oui =3D=3D 0xdeadbe && nic =3D=3D 0xef0000)
+		wl1271_warning("Detected unconfigured mac address in nvs.\n"
+				"in case of using a wl12xx device, your "
+				"device performance may not be optimized.\n"
+				"Please use the calibrator tool to configure "
+				"your device.\n"
+				"When using a wl18xx device the nvs file can "
+				"be removed as a default mac address is "
+				"stored internally.\n");
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
--=20
2.7.4
