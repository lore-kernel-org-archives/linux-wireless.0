Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:39295 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJWQ12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 12:27:28 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, troy_tan@realsil.com.cn,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org,
	Murilo Opsfelder Araujo <mopsfelder@gmail.com>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Thadeu Cascardo <cascardo@cascardo.eti.br>
Subject: [PATCH V3.18] rtlwifi: Add check for get_btc_status callback
Date: Thu, 23 Oct 2014 11:27:09 -0500
Message-Id: <1414081629-23002-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141023_182737_668164_661E8314)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that do not use the get_btc_status() callback may not define a
dummy routine. The caller needs to check before making the call.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thadeu Cascardo <cascardo@cascardo.eti.br>
---

John,

This missing statement is causing kernel crashes for several of the drivers.
This patch should be applied ASAP.

Larry
---

 drivers/net/wireless/rtlwifi/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 667aba8..25daa87 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -1796,7 +1796,8 @@ static int rtl_pci_start(struct ieee80211_hw *hw)
 	rtl_pci_reset_trx_ring(hw);
 
 	rtlpci->driver_is_goingto_unload = false;
-	if (rtlpriv->cfg->ops->get_btc_status()) {
+	if (rtlpriv->cfg->ops->get_btc_status &&
+	    rtlpriv->cfg->ops->get_btc_status()) {
 		rtlpriv->btcoexist.btc_ops->btc_init_variables(rtlpriv);
 		rtlpriv->btcoexist.btc_ops->btc_init_hal_vars(rtlpriv);
 	}
-- 
1.8.4.5

