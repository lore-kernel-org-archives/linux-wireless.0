Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65356 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3ELLoI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:08 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/7] wil6210: Sanity check for reported DMA length
Date: Sun, 12 May 2013 14:43:33 +0300
Message-ID: <1368359018-20870-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134415_424988_C063703C)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If Rx descriptor contains garbage, it is possible to access memory beyond
allocated buffer.

Check this condition and drop Rx if reported length is
unreasonable large

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index b9cac7d..6506b76 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -351,7 +351,13 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 
 	d1 = wil_skb_rxdesc(skb);
 	*d1 = *d;
+	wil_vring_advance_head(vring, 1);
 	dmalen = le16_to_cpu(d1->dma.length);
+	if (dmalen > sz) {
+		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
+		kfree(skb);
+		return NULL;
+	}
 	skb_trim(skb, dmalen);
 
 	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d1);
@@ -364,8 +370,6 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_NONE, 32, 4,
 			  (const void *)d, sizeof(*d), false);
 
-	wil_vring_advance_head(vring, 1);
-
 	/* no extra checks if in sniffer mode */
 	if (ndev->type != ARPHRD_ETHER)
 		return skb;
-- 
1.8.1.2

