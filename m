Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:35871 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752810AbcKZCPd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 21:15:33 -0500
Received: by mail-pg0-f67.google.com with SMTP id x23so6865291pgx.3
        for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2016 18:15:33 -0800 (PST)
Date: Sat, 26 Nov 2016 12:12:03 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH] rtl8xxxu: tx rate reported before set
Message-ID: <20161126021158.GA12838@box64.home.org> (sfid-20161126_032134_643915_4C54A2C3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the dev_info call that attempts to show the rate used before it is set.

Signed-off-by: Barry Day <briselec@gmail.com>
---
 rtl8xxxu_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/rtl8xxxu_core.c b/rtl8xxxu_core.c
index 04141e5..a9137ab 100644
--- a/rtl8xxxu_core.c
+++ b/rtl8xxxu_core.c
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
2.9.2
