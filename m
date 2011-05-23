Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f173.google.com ([209.85.212.173]:65243 "EHLO
	mail-px0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1EWNz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 09:55:28 -0400
Received: by pxi16 with SMTP id 16so3817724pxi.4
        for <linux-wireless@vger.kernel.org>; Mon, 23 May 2011 06:55:28 -0700 (PDT)
Message-ID: <4DDA673B.6070600@ring3k.org> (sfid-20110523_155536_087651_7BAC1779)
Date: Mon, 23 May 2011 22:55:07 +0900
From: Mike McCormack <mikem@ring3k.org>
MIME-Version: 1.0
To: Larry.Finger@lwfinger.net, chaoming_li@realsil.com.cn
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] rtlwifi: Fix logic in rx_interrupt
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should pass along packet if there's no CRC and no hardware error.

Signed-off-by: Mike McCormack <mikem@ring3k.org>
---
 drivers/net/wireless/rtlwifi/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 4fe405a..215abfa 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -691,7 +691,7 @@ static void _rtl_pci_rx_interrupt(struct ieee80211_hw *hw)
 			hdr = rtl_get_hdr(skb);
 			fc = rtl_get_fc(skb);
 
-			if (!stats.crc || !stats.hwerror) {
+			if (!stats.crc && !stats.hwerror) {
 				memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
 				       sizeof(rx_status));
 
-- 
1.7.4.1

