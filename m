Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34905 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751145AbdFBOPj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 10:15:39 -0400
Received: by mail-pf0-f194.google.com with SMTP id u26so11895346pfd.2
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jun 2017 07:15:39 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 2/6] rsi: use enum for FSM states
Date: Fri,  2 Jun 2017 19:43:01 +0530
Message-Id: <1496412785-8720-3-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170602_161543_088409_756684C9)
In-Reply-To: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1496412785-8720-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently macros are used for FSM states. We will replace
it with enum so that new state can be added easily without
worrying about macro value.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_main.h | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index ea4fc22..833c66f5 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -31,13 +31,15 @@
 #define FSM_ZONE                        BIT(7)  /* For State Machine Msgs     */
 #define ISR_ZONE                        BIT(8)  /* For Interrupt Msgs         */
 
-#define FSM_CARD_NOT_READY              0
-#define FSM_BOOT_PARAMS_SENT            1
-#define FSM_EEPROM_READ_MAC_ADDR        2
-#define FSM_RESET_MAC_SENT              3
-#define FSM_RADIO_CAPS_SENT             4
-#define FSM_BB_RF_PROG_SENT             5
-#define FSM_MAC_INIT_DONE               6
+enum RSI_FSM_STATES {
+	FSM_CARD_NOT_READY,
+	FSM_BOOT_PARAMS_SENT,
+	FSM_EEPROM_READ_MAC_ADDR,
+	FSM_RESET_MAC_SENT,
+	FSM_RADIO_CAPS_SENT,
+	FSM_BB_RF_PROG_SENT,
+	FSM_MAC_INIT_DONE
+};
 
 extern u32 rsi_zone_enabled;
 extern __printf(2, 3) void rsi_dbg(u32 zone, const char *fmt, ...);
-- 
2.7.4
