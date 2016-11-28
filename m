Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:56995 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753647AbcK1VI3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 16:08:29 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtl8xxxu: fix tx rate debug output
Date: Mon, 28 Nov 2016 22:08:04 +0100
Message-Id: <20161128210815.2368509-1-arnd@arndb.de> (sfid-20161128_220834_252187_6A1BBD28)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We accidentally print the rate before we know it for txdesc_v2:

wireless/realtek/rtl8xxxu/rtl8xxxu_core.c: In function 'rtl8xxxu_fill_txdesc_v2':
wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:4848:3: error: 'rate' may be used uninitialized in this function [-Werror=maybe-uninitialized]

txdesc_v1 got it right, so let's do it the same way here.

Fixes: b4c3d9cfb607 ("rtl8xxxu: Pass tx_info to fill_txdesc in order to have access to retry count")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 04141e57b8ae..a9137abc3ad9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4844,16 +4844,16 @@ rtl8xxxu_fill_txdesc_v2(struct ieee80211_hw *hw, struct ieee80211_hdr *hdr,
 
 	tx_desc40 = (struct rtl8xxxu_txdesc40 *)tx_desc32;
 
-	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
-		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
-			 __func__, rate, cpu_to_le16(tx_desc40->pkt_size));
-
 	if (rate_flags & IEEE80211_TX_RC_MCS &&
 	    !ieee80211_is_mgmt(hdr->frame_control))
 		rate = tx_info->control.rates[0].idx + DESC_RATE_MCS0;
 	else
 		rate = tx_rate->hw_value;
 
+	if (rtl8xxxu_debug & RTL8XXXU_DEBUG_TX)
+		dev_info(dev, "%s: TX rate: %d, pkt size %d\n",
+			 __func__, rate, cpu_to_le16(tx_desc40->pkt_size));
+
 	seq_number = IEEE80211_SEQ_TO_SN(le16_to_cpu(hdr->seq_ctrl));
 
 	tx_desc40->txdw4 = cpu_to_le32(rate);
-- 
2.9.0
