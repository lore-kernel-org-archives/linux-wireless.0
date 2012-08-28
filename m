Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36079 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab2H1NMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2012 09:12:01 -0400
MIME-Version: 1.0
Date: Tue, 28 Aug 2012 21:12:00 +0800
Message-ID: <CAPgLHd_q0T=RD+qgEzFpnhez4Hdu-jDuFf0E+MgwiWLSeaMYaQ@mail.gmail.com> (sfid-20120828_151205_294215_49FDBB31)
Subject: [PATCH] rtlwifi: rtl8192c: remove pointless conditional before kfree_skb()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove pointless conditional before kfree_skb().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 44febfd..b627151 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -577,8 +577,7 @@ static bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
 	ring = &rtlpci->tx_ring[BEACON_QUEUE];
 
 	pskb = __skb_dequeue(&ring->queue);
-	if (pskb)
-		kfree_skb(pskb);
+	kfree_skb(pskb);
 
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 


