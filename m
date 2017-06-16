Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35271 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754070AbdFPOiq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:38:46 -0400
Received: by mail-pf0-f196.google.com with SMTP id s66so6820930pfs.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:38:45 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 2/6] rsi: use enum for FSM states
Date: Fri, 16 Jun 2017 20:05:37 +0530
Message-Id: <1497623741-2082-3-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_163848_831578_CE763EDD)
In-Reply-To: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497623741-2082-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

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
