Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:34683 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752688AbdCMW4Y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Mar 2017 18:56:24 -0400
From: <ryanhsu@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
CC: <ryanhsu@qca.qualcomm.com>
Subject: [PATCH 4.11] ath10k: fix incorrect wlan_mac_base in qca6174_regs
Date: Mon, 13 Mar 2017 15:49:03 -0700
Message-ID: <1489445343-8719-1-git-send-email-ryanhsu@qca.qualcomm.com> (sfid-20170313_235627_137690_7F3FCB62)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ryan Hsu <ryanhsu@qca.qualcomm.com>

In the 'commit ebee76f7fa46 ("ath10k: allow setting coverage class")',
it inherits the design and the address offset from ath9k, but the address
is not applicable to QCA6174, which leads to a random crash while doing the
resume() operation, since the set_coverage_class.ops will be called from
ieee80211_reconfig() when resume() (if the wow is not configured).

Fix the incorrect address offset here to avoid the random crash.

Verified on QCA6174/hw3.0 with firmware WLAN.RM.4.4-00022-QCARMSWPZ-2.

Fixes: ebee76f7fa46 ("ath10k: allow setting coverage class")
Cc: stable@vger.kernel.org
Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index 33fb268..d9f37ee 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -51,7 +51,7 @@
 	.rtc_soc_base_address			= 0x00000800,
 	.rtc_wmac_base_address			= 0x00001000,
 	.soc_core_base_address			= 0x0003a000,
-	.wlan_mac_base_address			= 0x00020000,
+	.wlan_mac_base_address			= 0x00010000,
 	.ce_wrapper_base_address		= 0x00034000,
 	.ce0_base_address			= 0x00034400,
 	.ce1_base_address			= 0x00034800,
-- 
1.9.1
