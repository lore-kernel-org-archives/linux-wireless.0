Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:34730 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdGDG6A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 02:58:00 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [v2] wlcore: add missing nvs file name info for wilink8
Date: Tue, 4 Jul 2017 06:57:18 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B363E2669@DFRE01.ent.ti.com> (sfid-20170704_085821_786137_E9204CB3)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When working with wl18xx the nvs file is used for defining an alternate
mac address and override the default mac address that is stored inside
the wl18xx chip.

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

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 1 +
 drivers/net/wireless/ti/wlcore/spi.c  | 1 +
 2 files changed, 2 insertions(+)

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
