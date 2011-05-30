Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56473 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1E3Xs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 19:48:29 -0400
Received: by mail-pw0-f46.google.com with SMTP id 15so1804023pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 16:48:28 -0700 (PDT)
Message-ID: <4DE42CC7.9000905@ring3k.org> (sfid-20110531_014831_519327_CA86E9A9)
Date: Tue, 31 May 2011 08:48:23 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 1/8] rtlwifi: Synchronize IRQ after disabling it
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This make sure any IRQ handlers running on other CPUs complete.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
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


