Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=93.77.172.83
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792765825;
	b=eQ3gVQvWs7/CC8fwUkr5tzE3wp9zA48NEE6xH1l0g6EDSCTVUNagOuwx/sD/qQiuaClB
	 DYKRgLkeWfygpxVpGgGCDB8rG2o5hoOo5GrC2lQ1uMAI9qk14qw5o7UhgbnJBbxiubpCi
	 cpC62zLe1qBWpRRTwNvdBVfp0dD8fvno4mp6OVinCufFeISThNKzIP1G2MVbjMRyQDMwb
	 I0Z9Dt1Mdo7H6yiceDxeTckbZSOSQ+mfJ/k/jPWaxYA1ML2+gCuIDEe7nYmLvCL4BY4mM
	 25qhxNcF7wQDTDj82ZDeDHFJj8iwO0KBjRBpkPoYUY2sn4cIJjNiF9H3VH7jzh3GS3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792765825;
	h=DMARC-Filter:Received:Received:X-Yandex-Fwd:DKIM-Signature:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Q4YBxp9Ib2eL1X9V1E4sWkkEpnIlNYN58hjqcOkNbeM=;
	b=BK2KiAn1sY6fYCE5LgAVQht6rfdy64viam7D+deJjF0mgl50K4mdlv4Ihnmqg1l00ICw
	 RtDoIrSqX1gFBvdZUXDqu1bqwybd+pEIIRCNj3fVMicdSrw35zVHmCZTmGCPvHJcX6YTe
	 u0gobWrQE3lvH6KYeI82kTFYZ0myryQHbfvxkOAzs/vrnULhMU6FefVpJe+nI9NlQo12I
	 UWjF1gPm8XWuJJX7xRMMDJMW/8ncU2wl1IZ7IP0EcWeihY0fW7un0r+bwrl7tSs5IxgHH
	 4ovYy4nla3GmaZEChLeglgOxnDGsOpbUZTCBhaULpGA2gm06HqhQa+6+ZTr6sGIrNtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=yandex.ru;
	spf=pass smtp.mailfrom=yandex.ru;
	dkim=pass header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=gogYjfSl;
	arc=none smtp.remote-ip=93.77.172.83
Received: from forward400e.mail.yandex.net (forward400e.mail.yandex.net [93.77.172.83])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ECE606A320
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:30:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7ECE606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=yandex.ru header.i=@yandex.ru header.a=rsa-sha256 header.s=mail header.b=gogYjfSl
Received: from mail-nwsmtp-smtp-production-main-63.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-63.yp-c.yandex.net)
	by forward400e.mail.yandex.net (postfix) with ESMTPS id 3FB2B82526;
	Fri, 23 Oct 2026 17:30:13 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-63 with ESMTPSA id 3UeBSOCiJmI0-Brb3G9fB;
	Fri, 23 Oct 2026 17:30:12 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1792765812; bh=Q4YBxp9Ib2eL1X9V1E4sWkkEpnIlNYN58hjqcOkNbeM=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=gogYjfSl9pohZRNrjHS2lw6TayQLCHgG3WM9YeO0dXfFxFyh9W9uPy4ayzMH9ant8
	 g9BfmZnYIAYgXs1kTgOrX/2+GSs9JUW/tadPrlww2grKrFJuVfYmFGGBp6IkA/ZKes
	 Bt5rSvr8sPzG7OV2ZKkD6mQX5P04Xkp/vNWkDoyw=
Authentication-Results: mail-nwsmtp-smtp-production-main-63; dkim=pass header.i=@yandex.ru
From: Sergey Armodin <dolph-in@yandex.ru>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH wireless-next v2] wifi: brcmfmac: pcie: restore FEM control pin mode on Apple BCM43602
Date: Fri, 23 Oct 2026 21:30:03 +0700
Message-ID: <20261023143003.1307752-1-dolph-in@yandex.ru>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a MacBookPro14,3 with a BCM43602 (14e4:43ba, subsystem 106b:0173),
5 GHz stops working once the chip has been reset to its power-on
state, which happens over S3 while running on battery. Scans still
report 5 GHz networks, but every attempt to join one fails: the
firmware ends the join with a SET_SSID event with status
BRCMF_E_STATUS_FAIL and no LINK event, which brcmfmac reports as
WLAN_STATUS_AUTH_TIMEOUT, seen in wpa_supplicant as
"CTRL-EVENT-ASSOC-REJECT ... status_code=16". A 2.4 GHz network could
still be joined in that state. Reloading the driver, power cycling
the slot or a secondary bus reset do not help; only a reboot of the
machine does.

On this board 5 GHz depends on bit 4 of the ChipCommon chipcontrol
register, which Broadcom's sbchipc.h calls
CCTRL4360_DISCRETE_FEMCTRL_MODE (front-end module control through the
discrete FEM control pins). After a reboot the bit is set. brcmfmac
never writes it and firmware 7.35.177.61 does not set it after a
power-on reset, so presumably the platform firmware sets it at boot.
The watchdog reset brcmfmac does on probe and remove preserves the
bit, but a power-on reset clears it: power cycling the slot of a
working system breaks 5 GHz the same way. Read with the driver unbound
after the firmware has run, chipcontrol is 0x01400010 after a reboot
and 0x01000000 after S3 on battery. Bit 22 is lost as well, but
setting bit 4 alone before the firmware is downloaded is enough to
make 5 GHz work again.

A MacBookPro14,2 (subsystem 106b:0157) was reported to behave the
same way, over S3 on AC power as well as on battery: with the driver
unbound, chipcontrol read 0x01400090 after a boot, 0 after S3 and
0x01000000 once the firmware had run again, and setting bit 4 from
user space before loading the driver made 5 GHz work again. A
MacBookPro11,5 (subsystem 106b:0152), on the other hand, boots with
chipcontrol 0x0100000c, bit 4 clear, and 5 GHz works there, so not
every Apple BCM43602 board uses this mode.

Set the bit, if it is clear, before downloading the firmware, but only
for the MacBookPro14,2 and MacBookPro14,3 subsystem IDs. Subsystem ID
0x0157 may not be unique to the MacBookPro14,2: it is also the ID that
the module on the MacBookPro14,3 reports after a reset, until the
platform firmware rewrites it to 0x0173, so other boards with the same
module may match too. When the firmware is lost over a resume,
brcmfmac removes and probes the device again, so this covers S3 as
well as a driver reload.

Tested on a MacBookPro14,3 with firmware 7.35.177.61: after power
cycling the slot and after S3 on battery the driver sets the bit and
5 GHz associates again; after a normal boot the bit is already set and
nothing is written. Not tested with this patch on a MacBookPro14,2.

Signed-off-by: Sergey Armodin <dolph-in@yandex.ru>
---
v2:
- Only set the bit on the MacBookPro14,2 and MacBookPro14,3 instead of
  on all Apple BCM43602 boards, since a MacBookPro11,5 boots with the
  bit clear and 5 GHz works there.
- Describe the MacBookPro14,2 and MacBookPro11,5 reports.
- Retested on the MacBookPro14,3 with a slot power cycle. The S3 result
  is from v1, which does the same on this board.

v1: https://lore.kernel.org/linux-wireless/20261018193950.14287-1-dolph-in@yandex.ru/

 .../broadcom/brcm80211/brcmfmac/pcie.c        | 39 +++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 17bae04c1..653994d7b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -726,9 +726,48 @@ static void brcmf_pcie_attach(struct brcmf_pciedev_info *devinfo)
 }
 
 
+/* ChipCommon chipcontrol bit selecting the discrete FEM control pin mode */
+#define BRCMF_CC_CHIPCTL_4360_DISCRETE_FEMCTRL_MODE	BIT(4)
+
+/* On the Apple boards below, 5 GHz on the BCM43602 only works with the
+ * discrete FEM control pin mode selected in the ChipCommon chipcontrol
+ * register. The bit is set after a reboot, but a power-on reset of the chip
+ * (e.g. over S3) clears it and the firmware does not set it again. Restore
+ * it before the firmware is started. Other Apple boards may not use this
+ * mode (a MacBookPro11,5 boots with the bit clear), so they are left alone.
+ */
+static void brcmf_pcie_43602_apple_femctrl(struct brcmf_pciedev_info *devinfo)
+{
+	const struct pci_dev *pdev = devinfo->pdev;
+	u32 val;
+
+	if (pdev->subsystem_vendor != PCI_VENDOR_ID_APPLE)
+		return;
+
+	switch (pdev->subsystem_device) {
+	case 0x0157:	/* MacBookPro14,2, possibly others */
+	case 0x0173:	/* MacBookPro14,3 */
+		break;
+	default:
+		return;
+	}
+
+	brcmf_pcie_select_core(devinfo, BCMA_CORE_CHIPCOMMON);
+	val = READCC32(devinfo, chipcontrol);
+	if (val & BRCMF_CC_CHIPCTL_4360_DISCRETE_FEMCTRL_MODE)
+		return;
+
+	brcmf_dbg(PCIE, "chipcontrol 0x%08x, setting discrete FEM control mode\n",
+		  val);
+	WRITECC32(devinfo, chipcontrol,
+		  val | BRCMF_CC_CHIPCTL_4360_DISCRETE_FEMCTRL_MODE);
+}
+
 static int brcmf_pcie_enter_download_state(struct brcmf_pciedev_info *devinfo)
 {
 	if (devinfo->ci->chip == BRCM_CC_43602_CHIP_ID) {
+		brcmf_pcie_43602_apple_femctrl(devinfo);
+
 		brcmf_pcie_select_core(devinfo, BCMA_CORE_ARM_CR4);
 		brcmf_pcie_write_reg32(devinfo, BRCMF_PCIE_ARMCR4REG_BANKIDX,
 				       5);
-- 
2.56.0

