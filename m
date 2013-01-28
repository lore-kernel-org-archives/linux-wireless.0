Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:1586 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab3A1Qit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:49 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/14] wil6210: Call skb_orphan() right before Rx indication
Date: Mon, 28 Jan 2013 18:31:02 +0200
Message-ID: <1359390669-9310-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173901_419480_DB13D37B)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Other parts of Rx path (BACK logic) will need to access associated data

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index e7ea538..649f504 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -430,6 +430,8 @@ static void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 	int rc;
 	unsigned int len = skb->len;
 
+	skb_orphan(skb);
+
 	if (in_interrupt())
 		rc = netif_rx(skb);
 	else
@@ -464,8 +466,6 @@ void wil_rx_handle(struct wil6210_priv *wil)
 		wil_hex_dump_TXRX("Rx ", DUMP_PREFIX_OFFSET, 16, 1,
 				  skb->data, skb_headlen(skb), false);
 
-		skb_orphan(skb);
-
 		if (wil->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 			skb->dev = ndev;
 			skb_reset_mac_header(skb);
-- 
1.7.10.4

