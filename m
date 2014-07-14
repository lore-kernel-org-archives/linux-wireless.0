Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45389 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaGNGvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 02:51:11 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 3/7] wil6210: fix double definition of 'ctx'
Date: Mon, 14 Jul 2014 09:49:39 +0300
Message-ID: <1405320583-5775-4-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140714_085117_737524_48718D91)
In-Reply-To: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1405320583-5775-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

Variable 'ctx' declarad again in the inner loop. Should use
one from outer loop instead.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index af4b93e..d346794 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1108,8 +1108,10 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		while (vring->swtail != new_swtail) {
 			struct vring_tx_desc dd, *d = &dd;
 			u16 dmalen;
-			struct wil_ctx *ctx = &vring->ctx[vring->swtail];
-			struct sk_buff *skb = ctx->skb;
+			struct sk_buff *skb;
+
+			ctx = &vring->ctx[vring->swtail];
+			skb = ctx->skb;
 			_d = &vring->va[vring->swtail].tx;
 
 			*d = *_d;
-- 
1.7.6

