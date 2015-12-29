Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f195.google.com ([209.85.160.195]:34415 "EHLO
	mail-yk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbbL2Twm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 14:52:42 -0500
From: Insu Yun <wuninsu@gmail.com>
To: akarwar@marvell.com, nishants@marvell.com, kvalo@codeaurora.org,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: taesoo@gatech.edu, yeongjin.jang@gatech.edu, insu@gatech.edu,
	changwoo@gatech.edu, Insu Yun <wuninsu@gmail.com>
Subject: [PATCH] mwifiex: correctly handling kzalloc
Date: Tue, 29 Dec 2015 14:55:25 -0500
Message-Id: <1451418925-11735-1-git-send-email-wuninsu@gmail.com> (sfid-20151229_205254_704652_E884D6D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since kzalloc can be failed in memory pressure,
it needs to be handled as above kzalloc.

Signed-off-by: Insu Yun <wuninsu@gmail.com>
---
 drivers/net/wireless/mwifiex/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 78a8474..d114934 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2053,8 +2053,14 @@ static int mwifiex_init_sdio(struct mwifiex_adapter *adapter)
 	/* Allocate skb pointer buffers */
 	card->mpa_rx.skb_arr = kzalloc((sizeof(void *)) *
 				       card->mp_agg_pkt_limit, GFP_KERNEL);
+	if (!card->mpa_rx.skb_arr)
+		return -ENOMEM;
+
 	card->mpa_rx.len_arr = kzalloc(sizeof(*card->mpa_rx.len_arr) *
 				       card->mp_agg_pkt_limit, GFP_KERNEL);
+	if (!card->mpa_rx.len_arr)
+		return -ENOMEM;
+
 	ret = mwifiex_alloc_sdio_mpa_buffers(adapter,
 					     card->mp_tx_agg_buf_size,
 					     card->mp_rx_agg_buf_size);
-- 
1.9.1

