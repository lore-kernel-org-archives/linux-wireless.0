Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:13853 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653Ab3GKHM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 03:12:27 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/3] wil6210: write modified HW descriptor back
Date: Thu, 11 Jul 2013 10:12:09 +0300
Message-ID: <1373526729-10908-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_091233_055479_7E61C4DC)
In-Reply-To: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HW descriptor copied from vring in un-cached memory to normal memory;
in tx completion it was not written back after modification. Fix it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 8fde73a..7cf5c94 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -859,6 +859,7 @@ int wil_tx_complete(struct wil6210_priv *wil, int ringid)
 		d->dma.addr.addr_high = 0;
 		d->dma.length = 0;
 		d->dma.status = TX_DMA_STATUS_DU;
+		*_d = *d;
 		vring->swtail = wil_vring_next_tail(vring);
 		done++;
 	}
-- 
1.8.1.2

