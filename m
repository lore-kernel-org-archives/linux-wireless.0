Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932161AbeCKVry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Mar 2018 17:47:54 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH] brcmfmac: Add support for getting nvram contents from EFI variables
Date: Sun, 11 Mar 2018 22:47:51 +0100
Message-Id: <20180311214751.12769-1-hdegoede@redhat.com> (sfid-20180311_224758_537066_3259DFE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various models Asus laptops with a SDIO attached brcmfmac wifi chip, store
the nvram contents in a special EFI variable. This commit adds support for
getting nvram directly from this EFI variable, without the user needing to
manually copy it.

This makes Wifi / Bluetooth work out of the box on these devices instead of
requiring manual setup.

Note that at least on the Asus T200TA the nvram from the EFI variable
wrongly contains "ccode=ALL" which the firmware does not understand, the
code to fetch the nvram from the EFI variable will fix this up to:
"ccode=XV" which is the correct way to specify the worldwide broadcast
regime.

This has been tested on the following models: Asus T100CHI, Asus T100HA,
Asus T100TA and Asus T200TA

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c         | 68 +++++++++++++++++++++-
 1 file changed, 67 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 091b52979e03..cbac407ae132 100644
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
@@ -446,6 +448,67 @@ struct brcmf_fw {
 		     void *nvram_image, u32 nvram_len);
 };
 
+#ifdef CONFIG_EFI
+static u8 *brcmf_fw_nvram_from_efi(size_t *data_len_ret)
+{
+	const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };
+	struct efivar_entry *nvram_efivar;
+	unsigned long data_len = 0;
+	u8 *data = NULL;
+	char *ccode;
+	int err;
+
+	/* So far only Asus devices store the nvram in an EFI var */
+	if (!dmi_name_in_vendors("ASUSTeK COMPUTER INC."))
+		return NULL;
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
+	/* In some cases the EFI-var stored nvram contains "ccode=ALL" but
+	 * the firmware does not understand "ALL" change this to "XV" which
+	 * is the correct way to specify the "worldwide" compatible settings.
+	 */
+	ccode = strnstr((char *)data, "ccode=ALL", data_len);
+	if (ccode) {
+		ccode[6] = 'X';
+		ccode[7] = 'V';
+		ccode[8] = '\n';
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
@@ -462,6 +525,8 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 		raw_nvram = false;
 	} else {
 		data = bcm47xx_nvram_get_contents(&data_len);
+		if (!data)
+			data = brcmf_fw_nvram_from_efi(&data_len);
 		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 			goto fail;
 		raw_nvram = true;
@@ -472,7 +537,8 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 					     fwctx->domain_nr, fwctx->bus_nr);
 
 	if (raw_nvram)
-		bcm47xx_nvram_release_contents(data);
+		kvfree(data); /* vfree for bcm47xx case / kfree for efi case */
+
 	release_firmware(fw);
 	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
 		goto fail;
-- 
2.14.3
