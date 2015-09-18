Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:59604 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164AbbIRUI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 16:08:26 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 14/16] brcmfmac: Add support for the BCM4365 and BCM4366 PCIE devices.
Date: Fri, 18 Sep 2015 22:08:17 +0200
Message-ID: <1442606899-31872-15-git-send-email-arend@broadcom.com> (sfid-20150918_220840_599372_8A60C0AF)
In-Reply-To: <1442606899-31872-1-git-send-email-arend@broadcom.com>
References: <1442606899-31872-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

This patch adds support for the BCM4365 and BCM4366 11ac Wave2
PCIE devices.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/chip.c     | 110 +++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c     |  22 +++++
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   9 ++
 include/linux/bcma/bcma.h                          |   2 +
 4 files changed, 133 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
index ff0c7c6..ffc3ace 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/chip.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/chip.c
@@ -208,6 +208,7 @@ struct sbsocramregs {
 };
 
 #define SOCRAMREGOFFS(_f)	offsetof(struct sbsocramregs, _f)
+#define SYSMEMREGOFFS(_f)	offsetof(struct sbsocramregs, _f)
 
 #define ARMCR4_CAP		(0x04)
 #define ARMCR4_BANKIDX		(0x40)
@@ -516,6 +517,9 @@ static int brcmf_chip_cores_check(struct brcmf_chip_priv *ci)
 		case BCMA_CORE_ARM_CR4:
 			cpu_found = true;
 			break;
+		case BCMA_CORE_ARM_CA7:
+			cpu_found = true;
+			break;
 		default:
 			break;
 		}
@@ -614,6 +618,29 @@ static void brcmf_chip_socram_ramsize(struct brcmf_core_priv *sr, u32 *ramsize,
 	}
 }
 
+/** Return the SYS MEM size */
+static u32 brcmf_chip_sysmem_ramsize(struct brcmf_core_priv *sysmem)
+{
+	u32 memsize = 0;
+	u32 coreinfo;
+	u32 idx;
+	u32 nb;
+	u32 banksize;
+
+	if (!brcmf_chip_iscoreup(&sysmem->pub))
+		brcmf_chip_resetcore(&sysmem->pub, 0, 0, 0);
+
+	coreinfo = brcmf_chip_core_read32(sysmem, SYSMEMREGOFFS(coreinfo));
+	nb = (coreinfo & SRCI_SRNB_MASK) >> SRCI_SRNB_SHIFT;
+
+	for (idx = 0; idx < nb; idx++) {
+		brcmf_chip_socram_banksize(sysmem, idx, &banksize);
+		memsize += banksize;
+	}
+
+	return memsize;
+}
+
 /** Return the TCM-RAM size of the ARMCR4 core. */
 static u32 brcmf_chip_tcm_ramsize(struct brcmf_core_priv *cr4)
 {
@@ -656,6 +683,9 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
 	case BRCM_CC_4358_CHIP_ID:
 	case BRCM_CC_43602_CHIP_ID:
 		return 0x180000;
+	case BRCM_CC_4365_CHIP_ID:
+	case BRCM_CC_4366_CHIP_ID:
+		return 0x200000;
 	default:
 		brcmf_err("unknown chip: %s\n", ci->pub.name);
 		break;
@@ -678,10 +708,28 @@ static int brcmf_chip_get_raminfo(struct brcmf_chip_priv *ci)
 			return -EINVAL;
 		}
 	} else {
-		mem = brcmf_chip_get_core(&ci->pub, BCMA_CORE_INTERNAL_MEM);
-		mem_core = container_of(mem, struct brcmf_core_priv, pub);
-		brcmf_chip_socram_ramsize(mem_core, &ci->pub.ramsize,
-					  &ci->pub.srsize);
+		mem = brcmf_chip_get_core(&ci->pub, BCMA_CORE_SYS_MEM);
+		if (mem) {
+			mem_core = container_of(mem, struct brcmf_core_priv,
+						pub);
+			ci->pub.ramsize = brcmf_chip_sysmem_ramsize(mem_core);
+			ci->pub.rambase = brcmf_chip_tcm_rambase(ci);
+			if (!ci->pub.rambase) {
+				brcmf_err("RAM base not provided with ARM CA7 core\n");
+				return -EINVAL;
+			}
+		} else {
+			mem = brcmf_chip_get_core(&ci->pub,
+						  BCMA_CORE_INTERNAL_MEM);
+			if (!mem) {
+				brcmf_err("No memory cores found\n");
+				return -ENOMEM;
+			}
+			mem_core = container_of(mem, struct brcmf_core_priv,
+						pub);
+			brcmf_chip_socram_ramsize(mem_core, &ci->pub.ramsize,
+						  &ci->pub.srsize);
+		}
 	}
 	brcmf_dbg(INFO, "RAM: base=0x%x size=%d (0x%x) sr=%d (0x%x)\n",
 		  ci->pub.rambase, ci->pub.ramsize, ci->pub.ramsize,
@@ -924,7 +972,7 @@ static int brcmf_chip_recognition(struct brcmf_chip_priv *ci)
 static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
 {
 	struct brcmf_core *core;
-	struct brcmf_core_priv *cr4;
+	struct brcmf_core_priv *cpu;
 	u32 val;
 
 
@@ -937,10 +985,11 @@ static void brcmf_chip_disable_arm(struct brcmf_chip_priv *chip, u16 id)
 		brcmf_chip_coredisable(core, 0, 0);
 		break;
 	case BCMA_CORE_ARM_CR4:
-		cr4 = container_of(core, struct brcmf_core_priv, pub);
+	case BCMA_CORE_ARM_CA7:
+		cpu = container_of(core, struct brcmf_core_priv, pub);
 
 		/* clear all IOCTL bits except HALT bit */
-		val = chip->ops->read32(chip->ctx, cr4->wrapbase + BCMA_IOCTL);
+		val = chip->ops->read32(chip->ctx, cpu->wrapbase + BCMA_IOCTL);
 		val &= ARMCR4_BCMA_IOCTL_CPUHALT;
 		brcmf_chip_resetcore(core, val, ARMCR4_BCMA_IOCTL_CPUHALT,
 				     ARMCR4_BCMA_IOCTL_CPUHALT);
@@ -1162,6 +1211,33 @@ static bool brcmf_chip_cr4_set_active(struct brcmf_chip_priv *chip, u32 rstvec)
 	return true;
 }
 
+static inline void
+brcmf_chip_ca7_set_passive(struct brcmf_chip_priv *chip)
+{
+	struct brcmf_core *core;
+
+	brcmf_chip_disable_arm(chip, BCMA_CORE_ARM_CA7);
+
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_80211);
+	brcmf_chip_resetcore(core, D11_BCMA_IOCTL_PHYRESET |
+				   D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN,
+			     D11_BCMA_IOCTL_PHYCLOCKEN);
+}
+
+static bool brcmf_chip_ca7_set_active(struct brcmf_chip_priv *chip, u32 rstvec)
+{
+	struct brcmf_core *core;
+
+	chip->ops->activate(chip->ctx, &chip->pub, rstvec);
+
+	/* restore ARM */
+	core = brcmf_chip_get_core(&chip->pub, BCMA_CORE_ARM_CA7);
+	brcmf_chip_resetcore(core, ARMCR4_BCMA_IOCTL_CPUHALT, 0, 0);
+
+	return true;
+}
+
 void brcmf_chip_set_passive(struct brcmf_chip *pub)
 {
 	struct brcmf_chip_priv *chip;
@@ -1175,8 +1251,16 @@ void brcmf_chip_set_passive(struct brcmf_chip *pub)
 		brcmf_chip_cr4_set_passive(chip);
 		return;
 	}
-
-	brcmf_chip_cm3_set_passive(chip);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CA7);
+	if (arm) {
+		brcmf_chip_ca7_set_passive(chip);
+		return;
+	}
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	if (arm) {
+		brcmf_chip_cm3_set_passive(chip);
+		return;
+	}
 }
 
 bool brcmf_chip_set_active(struct brcmf_chip *pub, u32 rstvec)
@@ -1190,8 +1274,14 @@ bool brcmf_chip_set_active(struct brcmf_chip *pub, u32 rstvec)
 	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CR4);
 	if (arm)
 		return brcmf_chip_cr4_set_active(chip, rstvec);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CA7);
+	if (arm)
+		return brcmf_chip_ca7_set_active(chip, rstvec);
+	arm = brcmf_chip_get_core(pub, BCMA_CORE_ARM_CM3);
+	if (arm)
+		return brcmf_chip_cm3_set_active(chip);
 
-	return brcmf_chip_cm3_set_active(chip);
+	return false;
 }
 
 bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index 451022e..30baf35 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -55,6 +55,10 @@ enum brcmf_pcie_state {
 #define BRCMF_PCIE_43570_NVRAM_NAME		"brcm/brcmfmac43570-pcie.txt"
 #define BRCMF_PCIE_4358_FW_NAME			"brcm/brcmfmac4358-pcie.bin"
 #define BRCMF_PCIE_4358_NVRAM_NAME		"brcm/brcmfmac4358-pcie.txt"
+#define BRCMF_PCIE_4365_FW_NAME			"brcm/brcmfmac4365b-pcie.bin"
+#define BRCMF_PCIE_4365_NVRAM_NAME		"brcm/brcmfmac4365b-pcie.txt"
+#define BRCMF_PCIE_4366_FW_NAME			"brcm/brcmfmac4366b-pcie.bin"
+#define BRCMF_PCIE_4366_NVRAM_NAME		"brcm/brcmfmac4366b-pcie.txt"
 
 #define BRCMF_PCIE_FW_UP_TIMEOUT		2000 /* msec */
 
@@ -204,6 +208,10 @@ MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4358_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4365_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4365_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4366_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4366_NVRAM_NAME);
 
 
 struct brcmf_pcie_console {
@@ -1440,6 +1448,14 @@ static int brcmf_pcie_get_fwnames(struct brcmf_pciedev_info *devinfo)
 		fw_name = BRCMF_PCIE_4358_FW_NAME;
 		nvram_name = BRCMF_PCIE_4358_NVRAM_NAME;
 		break;
+	case BRCM_CC_4365_CHIP_ID:
+		fw_name = BRCMF_PCIE_4365_FW_NAME;
+		nvram_name = BRCMF_PCIE_4365_NVRAM_NAME;
+		break;
+	case BRCM_CC_4366_CHIP_ID:
+		fw_name = BRCMF_PCIE_4366_FW_NAME;
+		nvram_name = BRCMF_PCIE_4366_NVRAM_NAME;
+		break;
 	default:
 		brcmf_err("Unsupported chip 0x%04x\n", devinfo->ci->chip);
 		return -ENODEV;
@@ -1973,6 +1989,12 @@ static struct pci_device_id brcmf_pcie_devid_table[] = {
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_2G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_5G_DEVICE_ID),
 	BRCMF_PCIE_DEVICE(BRCM_PCIE_43602_RAW_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_2G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4365_5G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_2G_DEVICE_ID),
+	BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID),
 	{ /* end: all zeroes */ }
 };
 
diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 8278376..d823734 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -48,6 +48,8 @@
 #define BRCM_CC_43570_CHIP_ID		43570
 #define BRCM_CC_4358_CHIP_ID		0x4358
 #define BRCM_CC_43602_CHIP_ID		43602
+#define BRCM_CC_4365_CHIP_ID		0x4365
+#define BRCM_CC_4366_CHIP_ID		0x4366
 
 /* USB Device IDs */
 #define BRCM_USB_43143_DEVICE_ID	0xbd1e
@@ -67,6 +69,13 @@
 #define BRCM_PCIE_43602_2G_DEVICE_ID	0x43bb
 #define BRCM_PCIE_43602_5G_DEVICE_ID	0x43bc
 #define BRCM_PCIE_43602_RAW_DEVICE_ID	43602
+#define BRCM_PCIE_4365_DEVICE_ID	0x43ca
+#define BRCM_PCIE_4365_2G_DEVICE_ID	0x43cb
+#define BRCM_PCIE_4365_5G_DEVICE_ID	0x43cc
+#define BRCM_PCIE_4366_DEVICE_ID	0x43c3
+#define BRCM_PCIE_4366_2G_DEVICE_ID	0x43c4
+#define BRCM_PCIE_4366_5G_DEVICE_ID	0x43c5
+
 
 /* brcmsmac IDs */
 #define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 2ff4a99..3feb1b2 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -151,6 +151,8 @@ struct bcma_host_ops {
 #define BCMA_CORE_PCIE2			0x83C	/* PCI Express Gen2 */
 #define BCMA_CORE_USB30_DEV		0x83D
 #define BCMA_CORE_ARM_CR4		0x83E
+#define BCMA_CORE_ARM_CA7		0x847
+#define BCMA_CORE_SYS_MEM		0x849
 #define BCMA_CORE_DEFAULT		0xFFF
 
 #define BCMA_MAX_NR_CORES		16
-- 
1.9.1

