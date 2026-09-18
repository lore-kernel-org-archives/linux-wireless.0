Received: from mx5.mail-out.lima-city.de (mx5.mail-out.lima-city.de [91.216.248.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF75F522F19;
	Fri, 18 Sep 2026 21:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.248.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789767533; cv=none; b=bRWjBGy/gRoDSdM0iSapgI69pGpHkZJV6uaCnQog2jJJtQvyBi40VoK7cnhtr5ogQFmyBQSVm7gW+nr123rYbPD1QnJQgKQb4WXgfvUuOLo3wvxS28gSKj0nOMvqqnb2ZJSvF4vwcNk86ZRKu8eK8X8HSw2Z+choNzYSy2morMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789767533; c=relaxed/simple;
	bh=4/z9WauPBe59K8RqhZ3KZ0qYmtFmuafoiXwQvkcjw4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uPy0SJ/2H0+ACzxbpoi/tV1eyc/yJkQexieh3hSHLCdlTXUkmBMkRP9HMOcP3/vsrkLzH/SpkVDW9OsUoiqlVPmDl0AZnBtSAb/ujsufLV+sAsbk7K4sCNe0mG+QNwNpGY11SIEl/cRfekCGK7K6IfF0wMDpF2r+iGLWPRF8+F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks; spf=none smtp.mailfrom=deq.rocks; dkim=pass (2048-bit key) header.d=deq.rocks header.i=@deq.rocks header.b=ehFk8qQl; arc=none smtp.client-ip=91.216.248.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=deq.rocks
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=deq.rocks
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deq.rocks header.i=@deq.rocks header.b="ehFk8qQl"
From: Andre Eikmeyer <dev@deq.rocks>
X-Lima-ML-UUID: a6bea56f-ef01-4d5d-83e1-8baf45dd6bb0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=deq.rocks;
	s=securedbylima-20251205; t=1789767016;
	bh=4/z9WauPBe59K8RqhZ3KZ0qYmtFmuafoiXwQvkcjw4U=;
	h=From:To:Cc:Subject:Date:From;
	b=ehFk8qQlvhKOzrF2puRnaLR3PyqhYSycNJHLDlnnwoyvajvhk6w84hvcr/4nJyihq
	 synvHZP0xO/+e+qWMT0wa3AWFk6GsjiSP+KUZo9SB4vbagA4yqHewcFqbDnx7kpK6s
	 YbNsjZj33rP6nYgybVSF/FIvtT8Jddxu1jMF8OqlBbxUT81CUP6c5uDeh7XDbjW1pp
	 sqOqzS3BLz0kyDMD26+u+UnCTLT5aVV7FrZSaliaP7a581xHga1EV1W+naGDtG5bNk
	 bLYz8qVtTHR0K84sqvTpzblFGr//t6rwIRzly69dC5P6B7s99uIC/p0ggI6Nu9j0xy
	 xZxUhkFe9XU5A==
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Andre Eikmeyer <dev@deq.rocks>
Subject: [PATCH] wifi: brcmfmac: handle missing D3 ACK on BCM4377 T2 Macs
Date: Fri, 18 Sep 2026 23:30:14 +0200
Message-ID: <20260918213014.1890677-1-dev@deq.rocks>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

BCM4377 on the affected T2 Macs does not acknowledge HOST_D3_INFORM.
The current PCIe suspend callback treats this as fatal and aborts system
suspend.

On the affected PCI and DMI combinations, mask the mailbox interrupt,
preserve the bus-down state, and let generic PCI/ACPI suspend proceed. On
resume the existing recovery path tears down and probes the device again
instead of relying on a D0 mailbox transaction.

Tested-on: MacBookAir9,1, MacBookPro15,4, MacBookPro16,3
Signed-off-by: Andre Eikmeyer <dev@deq.rocks>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 55f4d7b..57bbac1 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -9,6 +9,7 @@
 #include <linux/pci.h>
 #include <linux/vmalloc.h>
 #include <linux/delay.h>
+#include <linux/dmi.h>
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
@@ -49,6 +50,40 @@ enum brcmf_pcie_state {
 	BRCMFMAC_PCIE_STATE_UP
 };
 
+/*
+ * BCM4377 on these T2 Macs never acknowledges HOST_D3_INFORM. The platform
+ * can nevertheless enter and leave system suspend if the PCIe mailbox
+ * interrupt is masked and resume takes the existing cold-reprobe path.
+ */
+static const struct dmi_system_id brcmf_pcie_no_d3_ack_quirk[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookAir9,1"),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,4"),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MacBookPro16,3"),
+		},
+	},
+	{}
+};
+
+static bool brcmf_pcie_quirk_no_d3_ack(struct pci_dev *pdev)
+{
+	return pdev->vendor == PCI_VENDOR_ID_BROADCOM &&
+	       pdev->device == BRCM_PCIE_4377_DEVICE_ID &&
+	       dmi_check_system(brcmf_pcie_no_d3_ack_quirk);
+}
+
 BRCMF_FW_DEF(43602, "brcmfmac43602-pcie");
 BRCMF_FW_DEF(4350, "brcmfmac4350-pcie");
 BRCMF_FW_DEF(4350C, "brcmfmac4350c2-pcie");
@@ -2652,11 +2687,18 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
 			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
+		if (brcmf_pcie_quirk_no_d3_ack(devinfo->pdev)) {
+			dev_info(dev, "D3 ACK missing; masking PCIe mailbox interrupt\n");
+			brcmf_pcie_intr_disable(devinfo);
+			goto done;
+		}
+
 		brcmf_err(bus, "Timeout on response for entering D3 substate\n");
 		brcmf_bus_change_state(bus, BRCMF_BUS_UP);
 		return -EIO;
 	}
 
+done:
 	devinfo->state = BRCMFMAC_PCIE_STATE_DOWN;
 
 	return 0;
-- 
2.55.0
