Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33445 "EHLO
	mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRCZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:25:39 -0400
Received: by mail-pf0-f174.google.com with SMTP id 4so15145407pfd.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:25:39 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH DETAIL 13/19] rsi: Delete unnecessary variable initialisation
Date: Fri, 18 Mar 2016 13:25:33 +1100
Message-Id: <c95f816da2d5c6789004e063e1b7adc44695718e.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032542_147790_7DFD3A34)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

In rsi_send_data_pkt(), the following variables are assigned to
before they're used:

 * tmp_hdr - Assigned on line 47, first used on line 48
 * bss - Assigned on line 41, first used on line 44
 * extnd_size - Assigned on line 50, first used on line 52
 * seq_num - Assigned on line 48, first used on line 96

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[Rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 571eaba..4322df1 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -27,15 +27,15 @@
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
 	struct rsi_hw *adapter = common->priv;
-	struct ieee80211_hdr *tmp_hdr = NULL;
+	struct ieee80211_hdr *tmp_hdr;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
-	struct ieee80211_bss_conf *bss = NULL;
+	struct ieee80211_bss_conf *bss;
 	int status = -EINVAL;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
-	u8 extnd_size = 0;
+	u8 extnd_size;
 	__le16 *frame_desc;
-	u16 seq_num = 0;
+	u16 seq_num;
 
 	info = IEEE80211_SKB_CB(skb);
 	bss = &info->control.vif->bss_conf;
-- 
2.7.0

