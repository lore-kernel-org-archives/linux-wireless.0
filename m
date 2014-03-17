Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9677 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaCQNex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:34:53 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 07/21] wil6210: reduce dmesg pollution after FW crash
Date: Mon, 17 Mar 2014 15:34:11 +0200
Message-ID: <1395063265-6522-8-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_145650_363815_FF348CAE)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When FW crashes, dmesg get polluted with the "FW not ready"
error message. Print it only once per FW lifecycle

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 41f88ee..5cda0ea9 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -956,11 +956,15 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	struct wil6210_priv *wil = ndev_to_wil(ndev);
 	struct ethhdr *eth = (void *)skb->data;
 	struct vring *vring;
+	static bool pr_once_fw;
 	int rc;
 
 	wil_dbg_txrx(wil, "%s()\n", __func__);
 	if (!test_bit(wil_status_fwready, &wil->status)) {
-		wil_err(wil, "FW not ready\n");
+		if (!pr_once_fw) {
+			wil_err(wil, "FW not ready\n");
+			pr_once_fw = true;
+		}
 		goto drop;
 	}
 	if (!test_bit(wil_status_fwconnected, &wil->status)) {
@@ -971,6 +975,7 @@ netdev_tx_t wil_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		wil_err(wil, "Xmit in monitor mode not supported\n");
 		goto drop;
 	}
+	pr_once_fw = false;
 
 	/* find vring */
 	if (is_unicast_ether_addr(eth->h_dest)) {
-- 
1.8.3.2

