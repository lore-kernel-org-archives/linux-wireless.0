Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C583DC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:16:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7AE6521479
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 07:16:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7AE6521479
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbeJJOhN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:37:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30137 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeJJOhM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 10:37:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6906C4E915;
        Wed, 10 Oct 2018 07:16:24 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 762EC10018FF;
        Wed, 10 Oct 2018 07:16:22 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v3] brcmfmac: Add support for getting nvram contents from EFI variables
Date:   Wed, 10 Oct 2018 09:16:20 +0200
Message-Id: <20181010071620.14197-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 10 Oct 2018 07:16:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Various X86 laptops with a SDIO attached brcmfmac wifi chip, store the
nvram contents in a special EFI variable. This commit adds support for
getting nvram directly from this EFI variable, without the user needing
to manually copy it.

This makes Wifi / Bluetooth work out of the box on these devices instead of
requiring manual setup.

This has been tested on the following models: Acer Iconia Tab8 w1-810,
Acer One 10, Asus T100CHI, Asus T100HA, Asus T100TA, Asus T200TA and a
Lenovo Mixx 2 8.

Tested-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
Changes in v3:
-Drop ccode fixup code (to be re-added in a separate commit), so that we
 can get the main EFI nvram support merged while we figure out the ccode
 handling

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
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 63 +++++++++++++++++--
 1 file changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index b38c4b40b235..a1dfe75c835f 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -445,6 +446,51 @@ struct brcmf_fw {
 
 static void brcmf_fw_request_done(const struct firmware *fw, void *ctx);
 
+#ifdef CONFIG_EFI
+static u8 *brcmf_fw_nvram_from_efi(const char *path, size_t *data_len_ret)
+{
+	const u16 name[] = { 'n', 'v', 'r', 'a', 'm', 0 };
+	struct efivar_entry *nvram_efivar;
+	unsigned long data_len = 0;
+	u8 *data = NULL;
+	int err;
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
 static void brcmf_fw_free_request(struct brcmf_fw_request *req)
 {
 	struct brcmf_fw_item *item;
@@ -463,11 +509,12 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
 	struct brcmf_fw_item *cur;
+	bool free_bcm47xx_nvram = false;
+	bool kfree_nvram = false;
 	u32 nvram_length = 0;
 	void *nvram = NULL;
 	u8 *data = NULL;
 	size_t data_len;
-	bool raw_nvram;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
 
@@ -476,12 +523,13 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	if (fw && fw->data) {
 		data = (u8 *)fw->data;
 		data_len = fw->size;
-		raw_nvram = false;
 	} else {
-		data = bcm47xx_nvram_get_contents(&data_len);
-		if (!data && !(cur->flags & BRCMF_FW_REQF_OPTIONAL))
+		if ((data = bcm47xx_nvram_get_contents(&data_len)))
+			free_bcm47xx_nvram = true;
+		else if ((data = brcmf_fw_nvram_from_efi(cur->path, &data_len)))
+			kfree_nvram = true;
+		else if (!(cur->flags & BRCMF_FW_REQF_OPTIONAL))
 			goto fail;
-		raw_nvram = true;
 	}
 
 	if (data)
@@ -489,8 +537,11 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 					     fwctx->req->domain_nr,
 					     fwctx->req->bus_nr);
 
-	if (raw_nvram)
+	if (free_bcm47xx_nvram)
 		bcm47xx_nvram_release_contents(data);
+	if (kfree_nvram)
+		kfree(data);
+
 	release_firmware(fw);
 	if (!nvram && !(cur->flags & BRCMF_FW_REQF_OPTIONAL))
 		goto fail;
-- 
2.19.0

