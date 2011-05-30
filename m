Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:38177 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab1E3Xua (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2011 19:50:30 -0400
Received: by pxi2 with SMTP id 2so2678092pxi.10
        for <linux-wireless@vger.kernel.org>; Mon, 30 May 2011 16:50:30 -0700 (PDT)
Message-ID: <4DE42D40.3000708@ring3k.org> (sfid-20110531_015032_654375_DDE979AA)
Date: Tue, 31 May 2011 08:50:24 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn,
	linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] rtlwifi: Fix logic in rx_interrupt
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should pass along packet if there's no CRC and no hardware error.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index e29feef..fc44005 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -701,7 +701,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 					 rtlpci->rxbuffersize,
 					 PCI_DMA_FROMDEVICE);
 
-			if (!stats.crc || !stats.hwerror) {
+			if (!stats.crc && !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-- 
1.7.4.1

