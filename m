Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63181 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbaFPQim (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 12:38:42 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 17/25] wil6210: avoid dmesg pollution by Tx errors
Date: Mon, 16 Jun 2014 19:37:15 +0300
Message-ID: <1402936643-31819-18-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140616_190457_438929_19ABCBE6)
In-Reply-To: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1402936643-31819-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tx path, when vring for the destination not found,
it was considered as error and message was printed unconditionally.
However, this situation is normal after disconnect. If disconnect was while
heavy traffic load, lots of Tx packets will be dropped and this would
cause significant amount of prints in dmesg.
Demote messages priority from 'error' to 'debug'.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index a89a5c6..c06d74a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -771,7 +771,7 @@ static struct vring *wil_tx_bcast(struct wil6210_priv *wil,
 		goto found;
 	}
 
-	wil_err(wil, "Tx while no vrings active?\n");
+	wil_dbg_txrx(wil, "Tx while no vrings active?\n");
 
 	return NULL;
 
@@ -1031,7 +1031,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		vring = wil_tx_bcast(wil, skb);
 	}
 	if (!vring) {
-		wil_err(wil, "No Tx VRING found for %pM\n", eth->h_dest);
+		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
 		goto drop;
 	}
 	/* set up vring entry */
-- 
1.9.1

