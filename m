Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 5520-maca-inet1-outside.broadcom.com ([216.31.211.11]:16135
	"EHLO mail-irv-18.broadcom.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161104AbcBQK10 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 05:27:26 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 08/21] brcmfmac: use device memsize config from fw if defined
Date: Wed, 17 Feb 2016 11:26:57 +0100
Message-Id: <1455704830-10088-9-git-send-email-arend@broadcom.com> (sfid-20160217_112737_510306_C167440B)
In-Reply-To: <1455704830-10088-1-git-send-email-arend@broadcom.com>
References: <1455704830-10088-1-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Newer type pcie devices have memory which get shared between fw and
hw. The division of this memory is done firmware compile time. As a
result the ramsize as used by driver needs to be adjusted for this.
This is done by reading the memory size from the firmware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 33 ++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index d5f9ef4..d89212b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -207,6 +207,10 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_PCIE_CFGREG_REG_BAR3_CONFIG	0x4F4
 #define BRCMF_PCIE_LINK_STATUS_CTRL_ASPM_ENAB	3
 
+/* Magic number at a magic location to find RAM size */
+#define BRCMF_RAMSIZE_MAGIC			0x534d4152	/* SMAR */
+#define BRCMF_RAMSIZE_OFFSET			0x6c
+
 
 struct brcmf_pcie_console {
 	u32 base_addr;
@@ -1412,6 +1416,28 @@ static const struct brcmf_bus_ops brcmf_pcie_bus_ops = {
 };
 
 
+static void
+brcmf_pcie_adjust_ramsize(struct brcmf_pciedev_info *devinfo, u8 *data,
+			  u32 data_len)
+{
+	__le32 *field;
+	u32 newsize;
+
+	if (data_len < BRCMF_RAMSIZE_OFFSET + 8)
+		return;
+
+	field = (__le32 *)&data[BRCMF_RAMSIZE_OFFSET];
+	if (le32_to_cpup(field) != BRCMF_RAMSIZE_MAGIC)
+		return;
+	field++;
+	newsize = le32_to_cpup(field);
+
+	brcmf_dbg(PCIE, "Found ramsize info in FW, adjusting to 0x%x\n",
+		  newsize);
+	devinfo->ci->ramsize = newsize;
+}
+
+
 static int
 brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 			       u32 sharedram_addr)
@@ -1694,6 +1720,13 @@ static void brcmf_pcie_setup(struct device *dev, const struct firmware *fw,
 
 	brcmf_pcie_attach(devinfo);
 
+	/* Some of the firmwares have the size of the memory of the device
+	 * defined inside the firmware. This is because part of the memory in
+	 * the device is shared and the devision is determined by FW. Parse
+	 * the firmware and adjust the chip memory size now.
+	 */
+	brcmf_pcie_adjust_ramsize(devinfo, (u8 *)fw->data, fw->size);
+
 	ret = brcmf_pcie_download_fw_nvram(devinfo, fw, nvram, nvram_len);
 	if (ret)
 		goto fail;
-- 
1.9.1

