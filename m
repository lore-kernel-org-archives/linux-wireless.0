Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53829 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140Ab1EYAjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:39:08 -0400
Received: by pwi15 with SMTP id 15so3238039pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:39:07 -0700 (PDT)
Message-ID: <4DDC4F93.6000900@ring3k.org> (sfid-20110525_023912_109641_86956267)
Date: Wed, 25 May 2011 09:38:43 +0900
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


