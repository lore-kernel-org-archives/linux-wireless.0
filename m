Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:52788 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755298AbdL2Ibj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 03:31:39 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <yhchuang@realtek.com>, <Larry.Finger@lwfinger.net>,
        <johannes.berg@intel.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 05/11] rtlwifi: Remove unnecessary 'out of memory' message
Date: Fri, 29 Dec 2017 16:31:06 +0800
Message-ID: <20171229083112.31540-6-pkshih@realtek.com> (sfid-20171229_093322_653414_B93DCF42)
In-Reply-To: <20171229083112.31540-1-pkshih@realtek.com>
References: <20171229083112.31540-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shreeya Patel <shreeya.patel23498@gmail.com>

This is merged by Ping-Ke Shih from commit 596e0559d61a ("Staging:
rtlwifi: Remove unnecessary 'out of memory' message."), and commit log
is reserved below.

Logging messages that show some type of "out of memory" error
are generally unnecessary as there is a generic message and
a stack dump done by the memory subsystem.

These messages generally increase kernel size without much
added value.

Problem found by checkpatch.

Signed-off-by: Shreeya Patel <shreeya.patel23498@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/rc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rc.c b/drivers/net/wireless/realtek/rtlwifi/rc.c
index 02811eda57cd..9638bf4a96f7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rc.c
@@ -265,11 +265,9 @@ static void *rtl_rate_alloc_sta(void *ppriv,
 	struct rtl_priv *rtlpriv = ppriv;
 	struct rtl_rate_priv *rate_priv;
 
-	rate_priv = kzalloc(sizeof(struct rtl_rate_priv), gfp);
-	if (!rate_priv) {
-		pr_err("Unable to allocate private rc structure\n");
+	rate_priv = kzalloc(sizeof(*rate_priv), gfp);
+	if (!rate_priv)
 		return NULL;
-	}
 
 	rtlpriv->rate_priv = rate_priv;
 
-- 
2.14.1
