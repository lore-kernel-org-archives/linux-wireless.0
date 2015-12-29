Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f193.google.com ([209.85.160.193]:33682 "EHLO
	mail-yk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbbL2UPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 15:15:04 -0500
From: Insu Yun <wuninsu@gmail.com>
To: akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] mwifiex: correctly handling kzalloc
Date: Tue, 29 Dec 2015 15:17:48 -0500
Message-Id: <1451420268-15862-1-git-send-email-wuninsu@gmail.com> (sfid-20151229_211530_160553_BD9E8720)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 78a8474..a8af72d 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2053,8 +2053,19 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	/* Allocate skb pointer buffers */
 	card->mpa_rx.skb_arr = kzalloc((sizeof(void *)) *
 				       card->mp_agg_pkt_limit, GFP_KERNEL);
+	if (!card->mpa_rx.skb_arr) {
+		kfree(card->mp_regs);
+		return -ENOMEM;
+	}
+
 	card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
 				       card->mp_agg_pkt_limit, GFP_KERNEL);
+	if (!card->mpa_rx.len_arr) {
+		kfree(card->mp_regs);
+		kfree(card->mpa_rx.skb_arr);
+		return -ENOMEM;
+	}
+
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
 					     card->mp_tx_agg_buf_size,
 					     card->mp_rx_agg_buf_size);
-- 
1.9.1

