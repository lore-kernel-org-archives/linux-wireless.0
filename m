Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:49181 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1J0PtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 11:49:11 -0400
Subject: [PATCH 10/10] ath6kl: don't print an error for canceled packets
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:49:08 +0300
Message-ID: <20111027154908.23519.25779.stgit@localhost6.localdomain6> (sfid-20111027_174915_423695_1C42B407)
In-Reply-To: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
References: <20111027154746.23519.39680.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath6kl_tx_complete() was printing an error when packet was canceled.
That causes unnecessary errors when hardware is powered off.

Also change the error to a warning and cleanup the message.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index ab9a5c1..9dfd7f5 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -606,8 +606,9 @@ void ath6kl_tx_complete(void *context, struct list_head *packet_queue)
 
 			vif->net_stats.tx_errors++;
 
-			if (status != -ENOSPC)
-				ath6kl_err("tx error, status: 0x%x\n", status);
+			if (status != -ENOSPC && status != -ECANCELED)
+				ath6kl_warn("tx complete error: %d\n", status);
+
 			ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
 				   "%s: skb=0x%p data=0x%p len=0x%x eid=%d %s\n",
 				   __func__, skb, packet->buf, packet->act_len,

