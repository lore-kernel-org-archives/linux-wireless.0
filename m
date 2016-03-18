Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f177.google.com ([209.85.192.177]:36739 "EHLO
	mail-pf0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361AbcCRC1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 22:27:38 -0400
Received: by mail-pf0-f177.google.com with SMTP id u190so146247286pfb.3
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 19:27:37 -0700 (PDT)
From: Julian Calaby <julian.calaby@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Markus Elfring <elfring@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH MOREWORK 15/19] rsi: Move variable initialisation into error code
Date: Fri, 18 Mar 2016 13:27:31 +1100
Message-Id: <0a8900fc6af3452d6601c186580381b23e1a3913.1458262312.git.julian.calaby@gmail.com> (sfid-20160318_032741_617810_B0C49523)
In-Reply-To: <cover.1458262312.git.julian.calaby@gmail.com>
References: <cover.1458262312.git.julian.calaby@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

In rsi_send_data_pkt(), it's a little more logical to assign 'status' in
the actual error handling code as opposed to at the top of the functon.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
[Deleted controversial bits, rewrote commit message]
Signed-off-by: Julian Calaby <julian.calaby@gmail.com>

---

I'm not fussed if this one goes in or not as the central concept of the
patch can be argued both ways.

Markus had originally added changes to move the setting of adapter down to
just before it was used, however people rightly objected to it, so it's
been removed from this re-send and the commit message re-written to
reflect this.

Thanks,

Julian Calaby
---
 drivers/net/wireless/rsi/rsi_91x_pkt.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_pkt.c b/drivers/net/wireless/rsi/rsi_91x_pkt.c
index 4322df1..a0b31c0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_pkt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_pkt.c
@@ -31,7 +31,7 @@ int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb)
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
-- 
2.7.0

