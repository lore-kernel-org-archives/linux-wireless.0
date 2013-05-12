Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35829 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3ELLoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 May 2013 07:44:10 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 3/7] wil6210: debug dump packet content right after DMA
Date: Sun, 12 May 2013 14:43:34 +0300
Message-ID: <1368359018-20870-4-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130512_134414_661938_562D5BDD)
In-Reply-To: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1368359018-20870-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move packet dump to the earliest location where it is known to have
valid data.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 6506b76..d060511 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -360,6 +360,10 @@ static struct sk_buff *wil_vring_reap_rx(struct wil6210_priv *wil,
 	}
 	skb_trim(skb, dmalen);
 
+	wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
+			  skb->data, skb_headlen(skb), false);
+
+
 	wil->stats.last_mcs_rx = wil_rxdesc_mcs(d1);
 
 	/* use radiotap header only if required */
@@ -474,8 +478,6 @@ void wil_rx_handle(struct wil6210_priv *wil)
 	}
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 	while (NULL != (skb = wil_vring_reap_rx(wil, v))) {
-		wil_hex_dump_txrx("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
-				  skb->data, skb_headlen(skb), false);
 
 		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 			skb->dev = ndev;
-- 
1.8.1.2

