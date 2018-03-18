Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:43194 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751061AbeCRTVu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Mar 2018 15:21:50 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2] brcmfmac: Add support for getting nvram contents from EFI variables
Date: Sun, 18 Mar 2018 20:21:47 +0100
Message-Id: <20180318192147.16813-1-hdegoede@redhat.com> (sfid-20180318_202154_492473_9DBBFB2E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various models Asus laptops with a SDIO attached brcmfmac wifi chip, store
the nvram contents in a special EFI variable. This commit adds support for
getting nvram directly from this EFI variable, without the user needing to
manually copy it.

This makes Wifi / Bluetooth work out of the box on these devices instead of
requiring manual setup.

Note this commit also adds fixup code to make sure the right ccode is used
when the nvram efivar wants to set the worldwide regulatory domain, the
correct ccode for that depends on the firmware version. So if the nvram
efivar contains ccode=ALL (which is never correct) or ccode=XV we fix it
up to the right value (XV or X2) for the firmware, assuming the firmware
from linux-firmware is used.

This has been tested on the following models: Asus T100CHI, Asus T100HA,
Asus T100TA and Asus T200TA

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v2:
-Stop testing for asus in the dmi sys_vendor string at least the Toshiba
 Encore uses the nvram efivar variable too
-Use a table mapping the firmare name to the correct ccode value (XV / X2) to
 use for the worldwide regulatory domain for that firmware, assuming the
 firmware from linux-firmware is used. This fixes the T200TA and T100HA not
 seeing 5GHz networks
-Not only fixup ccode=ALL, but also ccode=XV, this is necessary since the
 T100HA nvram efivar containts ccode=XV, but the firmware from Linux firmware
 needs ccode=X2 for proper operation
---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 96 ++++++++++++++++++++--
 1 file changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 091b52979e03..ac515d7d29cf 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -14,6 +14,8 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/dmi.h>
+#include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -446,33 +448,115 @@ struct brcmf_fw {
 		     void *nvram_image, u32 nvram_len);
 };
 
+#ifdef CONFIG_EFI
+static const char * const ccode_fixup_map[][2] = {
+	{ "brcm/brcmfmac43241b4-sdio.txt", "XV\n" },
+	{ "brcm/brcmfmac43340-sdio.txt", "X2\n" },
+};
+
+static u8 *brcmf_fw_nvram_from_efi(struct brcmf_fw *fwctx, size_t *data_len_ret)
+{
+	const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };
+	struct efivar_entry *nvram_efivar;
+	unsigned long data_len = 0;
+	const char *val = NULL;
+	u8 *data = NULL;
+	char *ccode;
+	int i, err;
+
+	nvram_efivar = kzalloc(sizeof(*nvram_efivar), GFP_KERNEL);
+	if (!nvram_efivar)
+		return NULL;
+
+	memcpy(&nvram_efivar->var.VariableName, name, sizeof(name));
+	nvram_efivar->var.VendorGuid = EFI_GUID(0x74b00bd9, 0x805a, 0x4d61,
+						0xb5, 0x1f, 0x43, 0x26,
+						0x81, 0x23, 0xd1, 0x13);
+
+	err = efivar_entry_size(nvram_efivar, &data_len);
+	if (err)
+		goto fail;
+
+	data = kmalloc(data_len, GFP_KERNEL);
+	if (!data)
+		goto fail;
+
+	err = efivar_entry_get(nvram_efivar, NULL, &data_len, data);
+	if (err)
+		goto fail;
+
+	/* In some cases the EFI-var stored nvram contains "ccode=ALL" or
+	 * "ccode=XV" to specify "worldwide" compatible settings. ccode=ALL is
+	 * not understood by the firmware and some of the firmware files in
+	 * linux-firmware support only 2.4 GHz and not 5 GHz when ccode=XV.
+	 */
+	ccode = strnstr((char *)data, "ccode=ALL", data_len);
+	if (!ccode)
+		ccode = strnstr((char *)data, "ccode=XV\r", data_len);
+	if (ccode) {
+		for (i = 0; i < ARRAY_SIZE(ccode_fixup_map); i++) {
+			if (!strcmp(ccode_fixup_map[i][0], fwctx->nvram_name)) {
+				val = ccode_fixup_map[i][1];
+				break;
+			}
+		}
+		if (val) {
+			ccode[6] = val[0];
+			ccode[7] = val[1];
+			ccode[8] = val[2];
+		} else {
+			brcmf_info("Using EFI nvram specifies worldwide ccode, but %s not found in ccode fixup map, please report this\n",
+				   fwctx->nvram_name);
+		}
+	}
+
+	brcmf_info("Using nvram EFI variable\n");
+
+	kfree(nvram_efivar);
+	*data_len_ret = data_len;
+	return data;
+
+fail:
+	kfree(data);
+	kfree(nvram_efivar);
+	return NULL;
+}
+#else
+static u8 *brcmf_fw_nvram_from_efi(size_t *data_len) { return NULL; }
+#endif
+
 static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
+	bool free_bcm47xx_nvram = false;
+	bool kfree_nvram = false;
 	u32 nvram_length = 0;
 	void *nvram = NULL;
 	u8 *data = NULL;
 	size_t data_len;
-	bool raw_nvram;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
 	if (fw && fw->data) {
 		data = (u8 *)fw->data;
 		data_len = fw->size;
-		raw_nvram = false;
 	} else {
-		data = bcm47xx_nvram_get_contents(&data_len);
-		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+		if ((data = bcm47xx_nvram_get_contents(&data_len)))
+			free_bcm47xx_nvram = true;
+		else if ((data = brcmf_fw_nvram_from_efi(fwctx, &data_len)))
+			kfree_nvram = true;
+		else if (!(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 			goto fail;
-		raw_nvram = true;
 	}
 
 	if (data)
 		nvram = brcmf_fw_nvram_strip(data, data_len, &nvram_length,
 					     fwctx->domain_nr, fwctx->bus_nr);
 
-	if (raw_nvram)
+	if (free_bcm47xx_nvram)
 		bcm47xx_nvram_release_contents(data);
+	if (kfree_nvram)
+		kfree(data);
+
 	release_firmware(fw);
 	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 		goto fail;
-- 
2.14.3
