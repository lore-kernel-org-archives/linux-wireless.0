Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466AbcF2OGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 10:06:41 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: "John W . Linville" <linville@tuxdriver.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Chen-Yu Tsai <wens@csie.org>, linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 1/4] brcmfmac: Add brcm,nvram_file_name dt property
Date: Wed, 29 Jun 2016 16:04:31 +0200
Message-Id: <1467209074-15634-1-git-send-email-hdegoede@redhat.com> (sfid-20160629_160742_937228_C6DCEB6D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a brcm,nvram_file_name dt property to allow overruling the default
nvram filename for sdio devices. The idea is that we can specify a
board specific nvram file, e.g. brcmfmac43362-ap6210.txt for boards
with an ap6210 wifi sdio module and ship this in linux-firmware, so
that wifi will work out of the box, without requiring users to find
and then manually install the right nvram file for their board.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt          | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c               | 2 ++
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c             | 6 ++++++
 include/linux/platform_data/brcmfmac.h                              | 2 ++
 4 files changed, 12 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
index 5dbf169..2ba13a6 100644
--- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
+++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
@@ -11,6 +11,7 @@ Required properties:
 Optional properties:
  - brcm,drive-strength : drive strength used for SDIO pins on device in mA
 	(default = 6).
+ - brcm,nvram_file_name : name of the nvram file to load
  - interrupt-parent : the phandle for the interrupt controller to which the
 	device interrupts are connected.
  - interrupts : specifies attributes for the out-of-band interrupt (host-wake).
@@ -34,6 +35,7 @@ mmc3: mmc@01c12000 {
 	brcmf: bcrmf@1 {
 		reg = <1>;
 		compatible = "brcm,bcm4329-fmac";
+		brcm,nvram_file_name = "brcm/brcmfmac43362-ap6210.txt";
 		interrupt-parent = <&pio>;
 		interrupts = <10 8>; /* PH10 / EINT10 */
 		interrupt-names = "host-wake";
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 425c41d..a054122 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -36,6 +36,8 @@ void brcmf_of_probe(struct device *dev, struct brcmfmac_sdio_pd *sdio)
 	if (of_property_read_u32(np, "brcm,drive-strength", &val) == 0)
 		sdio->drive_strength = val;
 
+	of_property_read_string(np, "brcm,nvram_file_name", &sdio->nvram_name);
+
 	/* make sure there are interrupts defined in the node */
 	if (!of_find_property(np, "interrupts", NULL))
 		return;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 67e69bf..2655409 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -4201,6 +4201,12 @@ struct brcmf_sdio *brcmf_sdio_probe(struct brcmf_sdio_dev *sdiodev)
 	if (ret)
 		goto fail;
 
+	if (sdiodev->settings->bus.sdio.nvram_name) {
+		strlcpy(sdiodev->nvram_name,
+			sdiodev->settings->bus.sdio.nvram_name,
+			BRCMF_FW_NAME_LEN);
+	}
+
 	ret = brcmf_fw_get_firmwares(sdiodev->dev, BRCMF_FW_REQUEST_NVRAM,
 				     sdiodev->fw_name, sdiodev->nvram_name,
 				     brcmf_sdio_firmware_callback);
diff --git a/include/linux/platform_data/brcmfmac.h b/include/linux/platform_data/brcmfmac.h
index 1d30bf2..a5515dd 100644
--- a/include/linux/platform_data/brcmfmac.h
+++ b/include/linux/platform_data/brcmfmac.h
@@ -65,6 +65,7 @@ enum brcmf_bus_type {
  *			the target drive strength, the exact drive strength
  *			which will be used depends on the capabilities of the
  *			device.
+ * @nvram_name:		name of nvram file to load.
  * @oob_irq_supported:	does the board have support for OOB interrupts. SDIO
  *			in-band interrupts are relatively slow and for having
  *			less overhead on interrupt processing an out of band
@@ -91,6 +92,7 @@ enum brcmf_bus_type {
 struct brcmfmac_sdio_pd {
 	int		txglomsz;
 	unsigned int	drive_strength;
+	const char	*nvram_name;
 	bool		oob_irq_supported;
 	unsigned int	oob_irq_nr;
 	unsigned long	oob_irq_flags;
-- 
2.7.4

