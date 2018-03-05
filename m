Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:39711 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbeCEOtL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 09:49:11 -0500
Received: by mail-pl0-f67.google.com with SMTP id s13-v6so9759012plq.6
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2018 06:49:10 -0800 (PST)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 06/10] rsi: add module parameter rsi_reg
Date: Mon,  5 Mar 2018 20:06:56 +0530
Message-Id: <1520260620-4694-7-git-send-email-amitkarwar@gmail.com> (sfid-20180305_154917_028931_C6C07345)
In-Reply-To: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
References: <1520260620-4694-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

For few regulatory customizations, we are taking rsi_reg
as module parameter.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_main.c | 4 ++++
 drivers/net/wireless/rsi/rsi_common.h   | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index bf05242..e290779 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -24,6 +24,10 @@
 #include "rsi_coex.h"
 #include "rsi_hal.h"
 
+static u16 rsi_reg = RSI_REG_DEF;
+module_param(rsi_reg, ushort, 0444);
+MODULE_PARM_DESC(rsi_reg, "0 - RSI_REG_DEF, 1 - RSI_REG_DLCAR");
+
 u32 rsi_zone_enabled = /* INFO_ZONE |
 			INIT_ZONE |
 			MGMT_TX_ZONE |
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d9ff3b8..df40556 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -24,6 +24,9 @@
 #define QUEUE_NOT_FULL                  1
 #define QUEUE_FULL                      0
 
+#define RSI_REG_DEF			0
+#define RSI_REG_DLCAR			1
+
 static inline int rsi_init_event(struct rsi_event *pevent)
 {
 	atomic_set(&pevent->event_condition, 1);
-- 
2.7.4
