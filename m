Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:47651 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbdKDTiG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 4 Nov 2017 15:38:06 -0400
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: remove redundant initialization to cfg_cmd
Date: Sat,  4 Nov 2017 19:37:59 +0000
Message-Id: <20171104193759.919-1-colin.king@canonical.com> (sfid-20171104_203824_438513_DB77627F)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

cfg_cmd is initialized to zero and this value is never read, instead
it is over-written in the start of a do-while loop. Remove the
redundant initialization. Cleans up clang warning:

drivers/net/wireless/realtek/rtlwifi/core.c:1750:22: warning: Value
stored to 'cfg_cmd' during its initialization is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/realtek/rtlwifi/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/core.c b/drivers/net/wireless/realtek/rtlwifi/core.c
index 1147327e6f52..7a17cc20c57e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/core.c
+++ b/drivers/net/wireless/realtek/rtlwifi/core.c
@@ -1748,7 +1748,7 @@ bool rtl_hal_pwrseqcmdparsing(struct rtl_priv *rtlpriv, u8 cut_version,
 			      u8 faversion, u8 interface_type,
 			      struct wlan_pwr_cfg pwrcfgcmd[])
 {
-	struct wlan_pwr_cfg cfg_cmd = {0};
+	struct wlan_pwr_cfg cfg_cmd;
 	bool polling_bit = false;
 	u32 ary_idx = 0;
 	u8 value = 0;
-- 
2.14.1
