Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:35175 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbbGCNeB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jul 2015 09:34:01 -0400
Received: by lagh6 with SMTP id h6so85449156lag.2
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jul 2015 06:33:59 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH] ath10k: fix QCA61X4 boot up
Date: Fri,  3 Jul 2015 15:33:49 +0200
Message-Id: <1435930429-3970-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20150703_153407_634876_5E71B8A3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit "a521ee983d312db7 ath10k: Add new reg_address/mask to hw register
table" commit has broken the QCA61x4 support, by providing wrong
fw_indicator_address, which shall be 0x0003a028 instead of 0x00009028.

User experience was a failing boot up sequence (crashing device during
initialization)

[  181.663874] ath10k_pci 0000:02:00.0: enabling device (0000 -> 0002)
[  181.664787] ath10k_pci 0000:02:00.0: pci irq msi-x interrupts 8 irq_mode 0 reset_mode 0
[  181.688886] ath10k_pci 0000:02:00.0: device has crashed during init
[  181.688897] ath10k_pci 0000:02:00.0: failed to wait for target after cold reset: -70
[  181.688902] ath10k_pci 0000:02:00.0: failed to reset chip: -70
[  181.689774] ath10k_pci: probe of 0000:02:00.0 failed with error -70

Fix it by updating the address with correct value.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 1414e1f3c7ac..fef7ccf6e185 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -63,7 +63,7 @@ const struct ath10k_hw_regs qca6174_regs = {
 	.soc_reset_control_ce_rst_mask		= 0x00000001,
 	.soc_chip_id_address			= 0x000000f0,
 	.scratch_3_address			= 0x00000028,
-	.fw_indicator_address			= 0x00009028,
+	.fw_indicator_address			= 0x0003a028,
 	.pcie_local_base_address		= 0x00080000,
 	.ce_wrap_intr_sum_host_msi_lsb		= 0x00000008,
 	.ce_wrap_intr_sum_host_msi_mask		= 0x0000ff00,
-- 
2.1.2

