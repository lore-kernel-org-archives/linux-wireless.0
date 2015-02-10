Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36952 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547AbbBJIzy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Feb 2015 03:55:54 -0500
From: Colin King <colin.king@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Colin King <colin.king@canonical.com>
Subject: [PATCH] rtlwifi: ratelimit skb allocation failure message
Date: Tue, 10 Feb 2015 08:54:31 +0000
Message-Id: <1423558471-27278-1-git-send-email-colin.king@canonical.com> (sfid-20150210_095620_694825_C4A5A042)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

when running low on memory I noticed rtlwifi was producing a large
quantity of repeated skb allocation failures messages.  This should
be ratelimited to reduce the noise.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rtlwifi/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index c70efb9..ca0fd50 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -817,7 +817,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 		/* get a new skb - if fail, old one will be reused */
 		new_skb = dev_alloc_skb(rtlpci->rxbuffersize);
 		if (unlikely(!new_skb)) {
-			pr_err("Allocation of new skb failed in %s\n",
+			pr_err_ratelimited("Allocation of new skb failed in %s\n",
 			       __func__);
 			goto no_new;
 		}
-- 
2.1.4

