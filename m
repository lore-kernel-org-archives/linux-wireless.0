Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31382 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbcCARS2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 12:18:28 -0500
Cc: Hamad Kadmany <QCA_hkadmany@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v2 03/15] wil6210: Set permanent MAC address to wiphy
Date: Tue,  1 Mar 2016 19:18:06 +0200
Message-Id: <1456852698-26808-4-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160301_181832_280299_470DC254)
In-Reply-To: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456852698-26808-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

MAC address of wil6210 was not set in wiphy

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 35db994..997a740 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -627,6 +627,7 @@ void wil_mbox_ring_le2cpus(struct wil6210_mbox_ring *r)
 static int wil_get_bl_info(struct wil6210_priv *wil)
 {
 	struct net_device *ndev = wil_to_ndev(wil);
+	struct wiphy *wiphy = wil_to_wiphy(wil);
 	union {
 		struct bl_dedicated_registers_v0 bl0;
 		struct bl_dedicated_registers_v1 bl1;
@@ -671,6 +672,7 @@ static int wil_get_bl_info(struct wil6210_priv *wil)
 	}
 
 	ether_addr_copy(ndev->perm_addr, mac);
+	ether_addr_copy(wiphy->perm_addr, mac);
 	if (!is_valid_ether_addr(ndev->dev_addr))
 		ether_addr_copy(ndev->dev_addr, mac);
 
-- 
1.8.5.2

