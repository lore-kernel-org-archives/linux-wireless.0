Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33163 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382Ab1EWNyA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 09:54:00 -0400
Received: by pwi15 with SMTP id 15so2611783pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 06:54:00 -0700 (PDT)
Message-ID: <4DDA66E3.8030207@ring3k.org> (sfid-20110523_155409_901544_A3627481)
Date: Mon, 23 May 2011 22:53:39 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] rtlwifi: Synchronize IRQ after disabling it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This make sure any IRQ handlers running on other CPUs complete.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/hw.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
index 4a56138..87b8a79 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/hw.c
@@ -1196,6 +1196,7 @@ void rtl92ce_disable_interrupt(struct ieee80211_hw *hw)
 	rtl_write_dword(rtlpriv, REG_HIMR, IMR8190_DISABLED);
 	rtl_write_dword(rtlpriv, REG_HIMRE, IMR8190_DISABLED);
 	rtlpci->irq_enabled = false;
+	synchronize_irq(rtlpci->pdev->irq);
 }
 
 static void _rtl92ce_poweroff_adapter(struct ieee80211_hw *hw)
-- 
1.7.4.1


