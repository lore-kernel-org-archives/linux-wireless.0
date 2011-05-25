Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43842 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932288Ab1EYAl1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 20:41:27 -0400
Received: by pwi15 with SMTP id 15so3238562pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 17:41:27 -0700 (PDT)
Message-ID: <4DDC501F.4090809@ring3k.org> (sfid-20110525_024129_713877_EDEAF0C9)
Date: Wed, 25 May 2011 09:41:03 +0900
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

