Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaFPQik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:40 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 16/25] wil6210: Debug print GRO Rx result
Date: Mon, 16 Jun 2014 19:37:14 +0300
Message-ID: <1402936643-31819-17-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190458_253066_E4B17C5E)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 0318cd2..a89a5c6 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -525,6 +525,17 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		ndev->stats.rx_bytes += len;
 		stats->rx_bytes += len;
 	}
+	{
+		static const char * const gro_res_str[] = {
+			[GRO_MERGED]		= "GRO_MERGED",
+			[GRO_MERGED_FREE]	= "GRO_MERGED_FREE",
+			[GRO_HELD]		= "GRO_HELD",
+			[GRO_NORMAL]		= "GRO_NORMAL",
+			[GRO_DROP]		= "GRO_DROP",
+		};
+		wil_dbg_txrx(wil, "Rx complete %d bytes => %s,\n",
+			     len, gro_res_str[rc]);
+	}
 }
 
 /**
-- 
1.9.1

