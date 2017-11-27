Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:60857 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751689AbdK0Lv6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Nov 2017 06:51:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: y2038@lists.linaro.org, Arnd Bergmann <arnd@arndb.de>,
        Waldemar Rymarkiewicz <ext.waldemar.rymarkiewicz@tieto.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
        Sarada Prasanna Garnayak <c_sgarna@qti.qualcomm.com>,
        Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>,
        Marcin Rokicki <marcin.rokicki@tieto.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: use 64-bit crash dump timestamps
Date: Mon, 27 Nov 2017 12:49:51 +0100
Message-Id: <20171127115113.2831506-1-arnd@arndb.de> (sfid-20171127_125217_522266_54B41D49)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The dump format uses 64-bit timestamps already, but calling
getnstimeofday() only returns a 32-bit number on 32-bit architectures,
so that will overflow in y2038.

This changes it to use ktime_get_real_ts64() instead.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/core.h  | 2 +-
 drivers/net/wireless/ath/ath10k/debug.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 643041ef3271..dd3c6c63aae1 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -463,7 +463,7 @@ struct ath10k_fw_crash_data {
 	bool crashed_since_read;
 
 	guid_t guid;
-	struct timespec timestamp;
+	struct timespec64 timestamp;
 	__le32 registers[REG_DUMP_COUNT_QCA988X];
 	struct ath10k_ce_crash_data ce_crash_data[CE_COUNT_MAX];
 };
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index df514507d3f1..66498e3c0f91 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -720,7 +720,7 @@ ath10k_debug_get_new_fw_crash_data(struct ath10k *ar)
 
 	crash_data->crashed_since_read = true;
 	guid_gen(&crash_data->guid);
-	getnstimeofday(&crash_data->timestamp);
+	ktime_get_real_ts64(&crash_data->timestamp);
 
 	return crash_data;
 }
-- 
2.9.0
