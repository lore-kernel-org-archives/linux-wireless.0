Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63323 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751027AbdBJNUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 08:20:13 -0500
Subject: [PATCH v2 4/4] ath10k: convert warning about non-existent OTP board
 id to debug message
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Fri, 10 Feb 2017 14:27:07 +0200
Message-ID: <148672962764.8556.11600829537505995398.stgit@potku.adurom.net> (sfid-20170210_142017_172284_5157864F)
In-Reply-To: <148672934198.8556.5588600166627442652.stgit@potku.adurom.net>
References: <148672934198.8556.5588600166627442652.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath10k unncessarily warns about board id not available from OTP:

ath10k_pci 0000:02:00.0: pci irq msi oper_irq_mode 2 irq_mode 0 reset_mode 0
ath10k_pci 0000:02:00.0: qca988x hw2.0 target 0x4100016c chip_id 0x043202ff sub 0000:0000
ath10k_pci 0000:02:00.0: kconfig debug 1 debugfs 1 tracing 1 dfs 1 testmode 1
ath10k_pci 0000:02:00.0: firmware ver 10.2.4.70.9-2 api 5 features no-p2p,raw-mode crc32 b8d50af5
ath10k_pci 0000:02:00.0: board id is not exist in otp, ignore it
ath10k_pci 0000:02:00.0: board_file api 1 bmi_id N/A crc32 bebc7c08
ath10k_pci 0000:02:00.0: htt-ver 2.1 wmi-op 5 htt-op 2 cal otp max-sta 128 raw 0 hwcrypto 1

But not all boards have the board id in OTP so this is not a problem and no
need to confuse the user with that info. So this can be safely changed to a
debug message.

Also fix grammar in the debug message.

Fixes: d2e202c06ca4 ("ath10k: ignore configuring the incorrect board_id")
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 6433fdd2c0c7..5e8dd3806622 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -701,7 +701,8 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 
 	if ((result & ATH10K_BMI_BOARD_ID_STATUS_MASK) != 0 ||
 	    (board_id == 0)) {
-		ath10k_warn(ar, "board id is not exist in otp, ignore it\n");
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "board id does not exist in otp, ignore it\n");
 		return -EOPNOTSUPP;
 	}
 
