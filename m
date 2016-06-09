Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32346 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbcFIN1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 09:27:34 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2] ath10k: Fix crash during card removal
Date: Thu, 9 Jun 2016 18:58:47 +0530
Message-ID: <1465478927-21401-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160609_152737_882102_4D570B7D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Usually when the firmware crashes we check for the value
'FW_IND_EVENT_PENDING' in 'FW_INDICATOR_ADDRESS' and proceed with
disabling the irq and dumping firmware 'crash dump'. Now
when the PCI card is unplugged from the device the PCI controller
seems to generate a spurious interrupt after some time which
was as treated a firmware crash and resulting in the below race
condition (and eventually crashing the system)

	ath10k_core_unregister -> ath10k_core_free_board_files

	...... device unplug spurious interrupt .........

	ath10k_pci_taklet -> ath10k_pci_fw_crashed_dump  ...etc

Clearly even after the firmware board files related data structure
is freed up we are getting a spurious interrupt from PCI with 0xfffffff
in the 'FW_INDICATOR_ADDRESS' resulting in scheduling of the pci tasklet
and doing a crash dump, printing f/w board related info resulting in the
below crash. Fix this by detecting this spurious interrupt in ath10k PCI
irq handler itself and return IRQ_NONE. Thanks to Michal Kazior for
helping us conclude the most appropriate fix.

Call trace:

 EIP is at ath10k_debug_print_board_info+0x39/0xb0
[ath10k_core]
EAX: 00000000 EBX: d4de15a0 ECX: 00000000 EDX: 00000064
ESI: f615ddd0 EDI: f8530000 EBP: f615de3c ESP: f615ddbc
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 80050033 CR2: 00000004 CR3: 01c0a000 CR4: 000006f0
Stack:
 f615ddd0 00000064 f8b4ecdd 00000000 00000000 00412f4e
00000000 00000000
00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
 00000000 00000000 00000000 00000000 00000000 00000000
00000000 00000000
Call Trace:
  [<f8b1f517>] ath10k_print_driver_info+0x17/0x30
[ath10k_core]
[<f875463a>] ath10k_pci_fw_crashed_dump+0x7a/0xe0
[ath10k_pci]
[<f87549d0>] ath10k_pci_tasklet+0x70/0x90 [ath10k_pci]
[<c106151e>] tasklet_action+0x9e/0xb0

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/pci.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 8133d7b..ce6269f 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2198,6 +2198,14 @@ static void ath10k_pci_fw_crashed_clear(struct ath10k *ar)
 	ath10k_pci_write32(ar, FW_INDICATOR_ADDRESS, val);
 }
 
+static bool ath10k_pci_has_device_gone(struct ath10k *ar)
+{
+	u32 val;
+
+	val = ath10k_pci_read32(ar, FW_INDICATOR_ADDRESS);
+	return (val == 0xffffffff);
+}
+
 /* this function effectively clears target memory controller assert line */
 static void ath10k_pci_warm_reset_si0(struct ath10k *ar)
 {
@@ -2591,6 +2599,9 @@ static irqreturn_t ath10k_pci_interrupt_handler(int irq, void *arg)
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
 	int ret;
 
+	if (ath10k_pci_has_device_gone(ar))
+		return IRQ_NONE;
+
 	ret = ath10k_pci_force_wake(ar);
 	if (ret) {
 		ath10k_warn(ar, "failed to wake device up on irq: %d\n", ret);
-- 
1.7.9.5

