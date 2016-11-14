Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36625 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933381AbcKNQfe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:34 -0500
Received: by mail-lf0-f65.google.com with SMTP id o20so7510789lfg.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:33 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 09/12] ath10k: Mailbox address definitions
Date: Mon, 14 Nov 2016 17:33:39 +0100
Message-Id: <1479141222-8493-10-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173538_954774_9EADE041)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Address definitions for SDIO/mbox based chipsets.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/hw.h |   53 ++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 883547f..46142e9 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -814,6 +814,59 @@ struct ath10k_hw_ops {
 #define QCA9887_EEPROM_ADDR_LO_MASK		0x00ff0000
 #define QCA9887_EEPROM_ADDR_LO_LSB		16
 
+#define MBOX_RESET_CONTROL_ADDRESS		0x00000000
+#define MBOX_HOST_INT_STATUS_ADDRESS		0x00000800
+#define MBOX_HOST_INT_STATUS_ERROR_LSB		7
+#define MBOX_HOST_INT_STATUS_ERROR_MASK		0x00000080
+#define MBOX_HOST_INT_STATUS_CPU_LSB		6
+#define MBOX_HOST_INT_STATUS_CPU_MASK		0x00000040
+#define MBOX_HOST_INT_STATUS_COUNTER_LSB	4
+#define MBOX_HOST_INT_STATUS_COUNTER_MASK	0x00000010
+#define MBOX_CPU_INT_STATUS_ADDRESS		0x00000801
+#define MBOX_ERROR_INT_STATUS_ADDRESS		0x00000802
+#define MBOX_ERROR_INT_STATUS_WAKEUP_LSB	2
+#define MBOX_ERROR_INT_STATUS_WAKEUP_MASK	0x00000004
+#define MBOX_ERROR_INT_STATUS_RX_UNDERFLOW_LSB	1
+#define MBOX_ERROR_INT_STATUS_RX_UNDERFLOW_MASK	0x00000002
+#define MBOX_ERROR_INT_STATUS_TX_OVERFLOW_LSB	0
+#define MBOX_ERROR_INT_STATUS_TX_OVERFLOW_MASK	0x00000001
+#define MBOX_COUNTER_INT_STATUS_ADDRESS		0x00000803
+#define MBOX_COUNTER_INT_STATUS_COUNTER_LSB	0
+#define MBOX_COUNTER_INT_STATUS_COUNTER_MASK	0x000000ff
+#define MBOX_RX_LOOKAHEAD_VALID_ADDRESS		0x00000805
+#define MBOX_INT_STATUS_ENABLE_ADDRESS		0x00000828
+#define MBOX_INT_STATUS_ENABLE_ERROR_LSB	7
+#define MBOX_INT_STATUS_ENABLE_ERROR_MASK	0x00000080
+#define MBOX_INT_STATUS_ENABLE_CPU_LSB		6
+#define MBOX_INT_STATUS_ENABLE_CPU_MASK		0x00000040
+#define MBOX_INT_STATUS_ENABLE_INT_LSB		5
+#define MBOX_INT_STATUS_ENABLE_INT_MASK		0x00000020
+#define MBOX_INT_STATUS_ENABLE_COUNTER_LSB	4
+#define MBOX_INT_STATUS_ENABLE_COUNTER_MASK	0x00000010
+#define MBOX_INT_STATUS_ENABLE_MBOX_DATA_LSB	0
+#define MBOX_INT_STATUS_ENABLE_MBOX_DATA_MASK	0x0000000f
+#define MBOX_CPU_INT_STATUS_ENABLE_ADDRESS	0x00000819
+#define MBOX_CPU_INT_STATUS_ENABLE_BIT_LSB	0
+#define MBOX_CPU_INT_STATUS_ENABLE_BIT_MASK	0x000000ff
+#define MBOX_ERROR_STATUS_ENABLE_ADDRESS	0x0000081a
+#define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_LSB  1
+#define MBOX_ERROR_STATUS_ENABLE_RX_UNDERFLOW_MASK 0x00000002
+#define MBOX_ERROR_STATUS_ENABLE_TX_OVERFLOW_LSB   0
+#define MBOX_ERROR_STATUS_ENABLE_TX_OVERFLOW_MASK  0x00000001
+#define MBOX_COUNTER_INT_STATUS_ENABLE_ADDRESS	0x0000081b
+#define MBOX_COUNTER_INT_STATUS_ENABLE_BIT_LSB	0
+#define MBOX_COUNTER_INT_STATUS_ENABLE_BIT_MASK	0x000000ff
+#define MBOX_COUNT_ADDRESS			0x00000820
+#define MBOX_COUNT_DEC_ADDRESS			0x00000840
+#define MBOX_WINDOW_DATA_ADDRESS		0x00000874
+#define MBOX_WINDOW_WRITE_ADDR_ADDRESS		0x00000878
+#define MBOX_WINDOW_READ_ADDR_ADDRESS		0x0000087c
+#define MBOX_CPU_DBG_SEL_ADDRESS		0x00000883
+#define MBOX_CPU_DBG_ADDRESS			0x00000884
+#define MBOX_RTC_BASE_ADDRESS			0x00000000
+#define MBOX_GPIO_BASE_ADDRESS			0x00005000
+#define MBOX_MBOX_BASE_ADDRESS			0x00008000
+
 #define RTC_STATE_V_GET(x) (((x) & RTC_STATE_V_MASK) >> RTC_STATE_V_LSB)
 
 /* Register definitions for first generation ath10k cards. These cards include
-- 
1.7.9.5
