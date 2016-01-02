Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:51106 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbcABOpW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 09:45:22 -0500
Subject: [PATCH 3/3] rsi: Replace variable initialisations by assignments in
 rsi_send_data_pkt()
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5687E169.4070704@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5687E27C.8000909@users.sourceforge.net> (sfid-20160102_154543_665674_7FBE63A9)
Date: Sat, 2 Jan 2016 15:45:16 +0100
MIME-Version: 1.0
In-Reply-To: <5687E169.4070704@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 2 Jan 2016 15:25:34 +0100

Replace explicit initialisation for two local variables at the beginning
by assignments.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index ec65e1c..fe36e7d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -26,12 +26,12 @@
  */
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 {
-	struct rsi_hw *adapter = common->priv;
+	struct rsi_hw *adapter;
 	struct ieee80211_hdr *tmp_hdr;
 	struct ieee80211_tx_info *info;
 	struct skb_info *tx_params;
 	struct ieee80211_bss_conf *bss;
-	int status = -EINVAL;
+	int status;
 	u8 ieee80211_size = MIN_802_11_HDR_LEN;
 	u8 extnd_size;
 	__le16 *frame_desc;
@@ -41,8 +41,10 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	bss = &info->control.vif->bss_conf;
 	tx_params = (struct skb_info *)info->driver_data;
 
-	if (!bss->assoc)
+	if (!bss->assoc) {
+		status = -EINVAL;
 		goto err;
+	}
 
 	tmp_hdr = (struct ieee80211_hdr *)&skb->data[0];
 	seq_num = (le16_to_cpu(tmp_hdr->seq_ctrl) >> 4);
@@ -97,7 +99,7 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
 	frame_desc[7] = cpu_to_le16(((tx_params->tid & 0xf) << 4) |
 				    (skb->priority & 0xf) |
 				    (tx_params->sta_id << 8));
-
+	adapter = common->priv;
 	status = adapter->host_intf_write_pkt(common->priv,
 					      skb->data,
 					      skb->len);
-- 
2.6.3

