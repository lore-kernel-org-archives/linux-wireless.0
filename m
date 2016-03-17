Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f195.google.com ([209.85.214.195]:35248 "EHLO
	mail-ob0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031488AbcCQSlU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 14:41:20 -0400
Received: by mail-ob0-f195.google.com with SMTP id e7so6741336obv.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 11:41:19 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/9] rtlwifi: rtl8192ee: Fix Smatch warning
Date: Thu, 17 Mar 2016 13:41:00 -0500
Message-Id: <1458240064-31422-6-git-send-email-Larry.Finger@lwfinger.net> (sfid-20160317_194132_842950_4B4E3C5F)
In-Reply-To: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1458240064-31422-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch lists the following:

  CHECK   drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c:371 rtl92ee_rx_query_desc() warn: inconsistent indenting

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index 24eff8e..35e6bf7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -368,7 +368,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	status->decrypted = !GET_RX_DESC_SWDEC(pdesc);
 	status->rate = (u8)GET_RX_DESC_RXMCS(pdesc);
 	status->isampdu = (bool)(GET_RX_DESC_PAGGR(pdesc) == 1);
-		status->timestamp_low = GET_RX_DESC_TSFL(pdesc);
+	status->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	status->is_cck = RTL92EE_RX_HAL_IS_CCK_RATE(status->rate);
 
 	status->macid = GET_RX_DESC_MACID(pdesc);
-- 
2.1.4

