Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:39233 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751185AbeBINZw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 08:25:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192cu: remove pointless memcpy
Date: Fri,  9 Feb 2018 14:24:41 +0100
Message-Id: <20180209132531.2755482-1-arnd@arndb.de> (sfid-20180209_142613_004576_F51AD13B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

gcc-8 points out that source and destination of the memcpy() are
always the same pointer, so the effect of memcpy() is undefined
here (its arguments must not overlap):

drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c: In function '_rtl_rx_process':
drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:430:2: error: 'memcpy' source argument is the same as destination [-Werror=restrict]

Most likely this is harmless, but it's easy to just remove the
line and get rid of the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index ac4a82de40c7..9ab56827124e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -427,7 +427,6 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 		 (u32)hdr->addr1[0], (u32)hdr->addr1[1],
 		 (u32)hdr->addr1[2], (u32)hdr->addr1[3],
 		 (u32)hdr->addr1[4], (u32)hdr->addr1[5]);
-	memcpy(IEEE80211_SKB_RXCB(skb), rx_status, sizeof(*rx_status));
 	ieee80211_rx(hw, skb);
 }
 
-- 
2.9.0
