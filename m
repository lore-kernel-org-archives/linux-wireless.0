Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34524 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:25:19 -0400
Received: by mail-pf0-f170.google.com with SMTP id x3so145890620pfb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:25:19 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH DETAIL 12/19] rsi: Delete unnecessary variable initialisation
Date: Fri, 18 Mar 2016 13:25:13 +1100
Message-Id: <3df80efb8bddfafb9222b6b03b088c0d85693da8.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032524_369295_60ED8CEB)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

In rsi_send_mgmt_pkt(), the following variables are assigned to
before they're used:

 * wh - Assigned on line 161, first used on line 180
 * bss - Assigned on line 160, first used on line 196
 * msg - Assigned on line 168, first used on line 175
 * extnd_size - Assigned on line 139, first used on line 142

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 702593f..571eaba 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -123,15 +123,15 @@ int rsi_send_mgmt_pkt(struct rsi_common *common,
 		      struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *wh = NULL;
+	struct ieee80211_hdr *wh;
 	struct ieee80211_tx_info *info;
-	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_bss_conf *bss;
 	struct ieee80211_hw *hw = adapter->hw;
 	struct ieee80211_conf *conf = &hw->conf;
 	struct skb_info *tx_params;
 	int status = -E2BIG;
-	__le16 *msg = NULL;
-	u8 extnd_size = 0;
+	__le16 *msg;
+	u8 extnd_size;
 	u8 vap_id = 0;
 
 	info = IEEE80211_SKB_CB(skb);
-- 
2.7.0

