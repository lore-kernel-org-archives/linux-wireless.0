Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.73]:64758 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752859AbdKFN4f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 08:56:35 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] rtlwifi: fix uninitialized rtlhal->last_suspend_sec time
Date: Mon,  6 Nov 2017 14:55:35 +0100
Message-Id: <20171106135619.1248453-1-arnd@arndb.de> (sfid-20171106_145700_878425_7CA5088A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We set rtlhal->last_suspend_sec to an uninitialized stack variable,
but unfortunately gcc never warned about this, I only found it
while working on another patch. I opened a gcc bug for this.

Presumably the value of rtlhal->last_suspend_sec is not all that
important, but it does get used, so we probably want the
patch backported to stable kernels.

Cc: stable@vger.kernel.org
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82839
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 60c82a5b51cd..20ffe856180e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -1373,6 +1373,7 @@ static void _rtl8821ae_get_wakeup_reason(struct ieee80211_hw *hw)
 
 	ppsc->wakeup_reason = 0;
 
+	do_gettimeofday(&ts);
 	rtlhal->last_suspend_sec = ts.tv_sec;
 
 	switch (fw_reason) {
-- 
2.9.0
