Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:33424 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753700AbdHWJ76 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2017 05:59:58 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: davem@davemloft.net, Larry.Finger@lwfinger.net,
        chaoming_li@realsil.com.cn, kvalo@codeaurora.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/3] net: rtlwifi: constify rate_control_ops
Date: Wed, 23 Aug 2017 15:29:33 +0530
Message-Id: <1503482375-19983-2-git-send-email-arvind.yadav.cs@gmail.com> (sfid-20170823_120119_377500_950777DB)
In-Reply-To: <1503482375-19983-1-git-send-email-arvind.yadav.cs@gmail.com>
References: <1503482375-19983-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rate_control_ops are not supposed to change at runtime. All functions
working with rate_control_ops provided by <net/mac80211.h> work with
const rate_control_ops. So mark the non-const structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index 951d257..02811ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -283,7 +283,7 @@ static void rtl_rate_free_sta(void *rtlpriv,
 	kfree(rate_priv);
 }
 
-static struct rate_control_ops rtl_rate_ops = {
+static const struct rate_control_ops rtl_rate_ops = {
 	.name = "rtl_rc",
 	.alloc = rtl_rate_alloc,
 	.free = rtl_rate_free,
-- 
1.9.1
