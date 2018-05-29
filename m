Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam03on0088.outbound.protection.outlook.com ([104.47.42.88]:23410
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933613AbeE2MAj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 08:00:39 -0400
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Dmitry Lebed <dlebed@quantenna.com>
Subject: [PATCH 7/9] qtnfmac: fix bg_scan_period parameter processing
Date: Tue, 29 May 2018 15:00:03 +0300
Message-Id: <20180529120005.21498-8-sergey.matyukevich.os@quantenna.com> (sfid-20180529_140052_606874_0FB89B33)
In-Reply-To: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
References: <20180529120005.21498-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrey Shevchenko <ashevchenko@quantenna.com>

Do not process bg_scan_period parameter in qtnfmac driver.
Pass correct values as is. In the case of invalid values
pass default value. Leave further processing to firmware.

Signed-off-by: Andrey Shevchenko <ashevchenko@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 8 +++-----
 drivers/net/wireless/quantenna/qtnfmac/core.h     | 2 --
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index e2fc57be1cdd..5eb143667539 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -2339,13 +2339,11 @@ int qtnf_cmd_send_connect(struct qtnf_vif *vif,
 	else
 		eth_zero_addr(cmd->prev_bssid);
 
-	if ((sme->bg_scan_period > 0) &&
-	    (sme->bg_scan_period <= QTNF_MAX_BG_SCAN_PERIOD))
+	if ((sme->bg_scan_period >= 0) &&
+	    (sme->bg_scan_period <= SHRT_MAX))
 		cmd->bg_scan_period = cpu_to_le16(sme->bg_scan_period);
-	else if (sme->bg_scan_period == -1)
-		cmd->bg_scan_period = cpu_to_le16(QTNF_DEFAULT_BG_SCAN_PERIOD);
 	else
-		cmd->bg_scan_period = 0; /* disabled */
+		cmd->bg_scan_period = cpu_to_le16(-1); /* use default value */
 
 	if (sme->flags & ASSOC_REQ_DISABLE_HT)
 		connect_flags |= QLINK_STA_CONNECT_DISABLE_HT;
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index 3b884c80b6ab..214435448335 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -44,8 +44,6 @@
 #define QTNF_MAX_VSIE_LEN		255
 #define QTNF_MAX_INTF			8
 #define QTNF_MAX_EVENT_QUEUE_LEN	255
-#define QTNF_DEFAULT_BG_SCAN_PERIOD	300
-#define QTNF_MAX_BG_SCAN_PERIOD		0xffff
 #define QTNF_SCAN_TIMEOUT_SEC		15
 
 #define QTNF_DEF_BSS_PRIORITY		0
-- 
2.11.0
