Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21144 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaLWHsc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 02:48:32 -0500
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: [PATCH 13/22] wil6210: fix Tx VRING for STA mode
Date: Tue, 23 Dec 2014 09:47:15 +0200
Message-Id: <1419320844-23989-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20141223_091348_114102_B992B36D)
In-Reply-To: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1419320844-23989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In STA mode, all Tx should be directed to the same VRING towards the AP.
Thus, look up for the 1-st eligible VRING and use it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 46 +++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 33961ca..4c145ee 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -777,6 +777,38 @@ static void wil_set_da_for_vring(struct wil6210_priv *wil,
 
 static int wil_tx_vring(struct wil6210_priv *wil, struct vring *vring,
 			struct sk_buff *skb);
+
+static struct vring *wil_find_tx_vring_sta(struct wil6210_priv *wil,
+					   struct sk_buff *skb)
+{
+	struct vring *v;
+	int i;
+	u8 cid;
+
+	/* In the STA mode, it is expected to have only 1 VRING
+	 * for the AP we connected to.
+	 * find 1-st vring and see whether it is eligible for data
+	 */
+	for (i = 0; i < WIL6210_MAX_TX_RINGS; i++) {
+		v = &wil->vring_tx[i];
+		if (!v->va)
+			continue;
+
+		cid = wil->vring2cid_tid[i][0];
+		if (!wil->sta[cid].data_port_open &&
+		    (skb->protocol != cpu_to_be16(ETH_P_PAE)))
+			break;
+
+		wil_dbg_txrx(wil, "Tx -> ring %d\n", i);
+
+		return v;
+	}
+
+	wil_dbg_txrx(wil, "Tx while no vrings active?\n");
+
+	return NULL;
+}
+
 /*
  * Find 1-st vring and return it; set dest address for this vring in skb
  * duplicate skb and send it to other active vrings
@@ -1056,15 +1088,19 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	pr_once_fw = false;
 
 	/* find vring */
-	if (is_unicast_ether_addr(eth->h_dest))
-		vring = wil_find_tx_vring(wil, skb);
-	else
-		vring = wil_tx_bcast(wil, skb);
+	if (wil->wdev->iftype == NL80211_IFTYPE_STATION) {
+		/* in STA mode (ESS), all to same VRING */
+		vring = wil_find_tx_vring_sta(wil, skb);
+	} else { /* direct communication, find matching VRING */
+		if (is_unicast_ether_addr(eth->h_dest))
+			vring = wil_find_tx_vring(wil, skb);
+		else
+			vring = wil_tx_bcast(wil, skb);
+	}
 	if (!vring) {
 		wil_dbg_txrx(wil, "No Tx VRING found for %pM\n", eth->h_dest);
 		goto drop;
 	}
-
 	/* set up vring entry */
 	rc = wil_tx_vring(wil, vring, skb);
 
-- 
2.1.0

