Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63805 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754371AbcEPTYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 15:24:11 -0400
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: [PATCH 3/6] wil6210: protect wil_vring_fini_tx in parallel to tx completions
Date: Mon, 16 May 2016 22:23:32 +0300
Message-Id: <1463426615-15523-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160516_212423_128059_992A033C)
In-Reply-To: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1463426615-15523-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

napi_synchronize is called before releasing the vring, with the
assumption that setting txdata->enabled to 0 will prevent handling
of this vring in the next scheduled napi.
To guarantee this assumption, a memory barrier is added after disabling
the txdata.
In addition, as the ctx is zeroed in wil_tx_complete after this
descriptor is handled (protected by wmb), ctx needs to be checked
before releasing this descriptor in wil_vring_free.

Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 3909af1..483e063 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -184,6 +184,13 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 					&vring->va[vring->swtail].tx;
 
 			ctx = &vring->ctx[vring->swtail];
+			if (!ctx) {
+				wil_dbg_txrx(wil,
+					     "ctx(%d) was already completed\n",
+					     vring->swtail);
+				vring->swtail = wil_vring_next_tail(vring);
+				continue;
+			}
 			*d = *_d;
 			wil_txdesc_unmap(dev, d, ctx);
 			if (ctx->skb)
@@ -975,6 +982,13 @@ void wil_vring_fini_tx(struct wil6210_priv *wil, int id)
 	txdata->dot1x_open = false;
 	txdata->enabled = 0; /* no Tx can be in progress or start anew */
 	spin_unlock_bh(&txdata->lock);
+	/* napi_synchronize waits for completion of the current NAPI but will
+	 * not prevent the next NAPI run.
+	 * Add a memory barrier to guarantee that txdata->enabled is zeroed
+	 * before napi_synchronize so that the next scheduled NAPI will not
+	 * handle this vring
+	 */
+	wmb();
 	/* make sure NAPI won't touch this vring */
 	if (test_bit(wil_status_napi_en, wil->status))
 		napi_synchronize(&wil->napi_tx);
-- 
1.8.5.2

