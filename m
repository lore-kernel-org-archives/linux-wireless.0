Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:50372 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdHIHyg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Aug 2017 03:54:36 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        ",Tony Lindgren" <tony@atomide.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sebastian.reichel@collabora.co.uk"
        <sebastian.reichel@collabora.co.uk>,
        Julian Calaby <julian.calaby@gmail.com>
Subject: [v6] wlcore: add missing nvs file name info for wilink8
Date: Wed, 9 Aug 2017 07:53:33 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36420E5A@DFRE01.ent.ti.com> (sfid-20170809_095450_882992_4F7835F9)
References: <1502264840-10569-1-git-send-email-eyalr@ti.com>
In-Reply-To: <1502264840-10569-1-git-send-email-eyalr@ti.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits:
commit c815fdebef44 ("wlcore: spi: Populate config firmware data")
commit d776fc86b82f ("wlcore: sdio: Populate config firmware data")

Populated the nvs entry for wilink6 and wilink7 only while it is
still needed for wilink8 as well for specifying an alternate mac address.
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
Cc: <stable@vger.kernel.org> # 4.9+
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
v2->v3: add a check for default deadbeef... mac address and warn about it
v3->v4: use a random TI mac address instead of the bogus one
v4->v5: add constant definition for TI oui address
v5->v6: after also verifying on wilink6/7 Use mac internal mac address
instead of a random one
---
 drivers/net/wireless/ti/wlcore/main.c | 15 +++++++++++++++
 drivers/net/wireless/ti/wlcore/sdio.c |  1 +
 drivers/net/wireless/ti/wlcore/spi.c  |  1 +
 3 files changed, 17 insertions(+)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/t=
i/wlcore/main.c
index 60aaa85..dd1ac48 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -6040,6 +6040,21 @@ static int wl1271_register_hw(struct wl1271 *wl)
 		nic_addr =3D wl->fuse_nic_addr + 1;
 	}
=20
+	if (oui_addr =3D=3D 0xdeadbe && nic_addr =3D=3D 0xef0000) {
+		wl1271_warning("Detected unconfigured mac address in nvs.\n"
+				"derive from fuse instead.\n"
+				"in case of using a wl12xx device, your "
+				"device performance may not be optimized.\n"
+				"Please use the calibrator tool to configure "
+				"your device.\n"
+				"When using a wl18xx device this default nvs "
+				"file can be removed from the file system\n");
+
+		oui_addr =3D wl->fuse_oui_addr;
+		/* fuse has the BD_ADDR, the WLAN addresses are the next two */
+		nic_addr =3D wl->fuse_nic_addr + 1;
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
--=20
2.7.4
