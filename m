Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16533 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3HEEta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 00:49:30 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath6kl : Fix invalid pointer access on fuzz testing with AP mode
Date: Mon, 5 Aug 2013 10:19:22 +0530
Message-ID: <1375678162-3190-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20130805_064933_858242_FF182A8C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

In our Fuz testing, reference client corrupts the dest mac to "00:00:00:00:00:00"
in the WPA2 handshake no 2. During driver init the sta_list entries mac
addresses are by default "00:00:00:00:00:00". Driver returns an invalid
pointer (conn) and the drver shall crash, if rxtids (aggr_conn)
skb queues are accessed, since they would not be initialized.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index d4fcfca..5839fc2 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -29,6 +29,9 @@ struct ath6kl_sta *ath6kl_find_sta(struct ath6kl_vif *vif, u8 *node_addr)
 	struct ath6kl_sta *conn = NULL;
 	u8 i, max_conn;
 
+	if (is_zero_ether_addr(node_addr))
+		return NULL;
+
 	max_conn = (vif->nw_type == AP_NETWORK) ? AP_MAX_NUM_STA : 0;
 
 	for (i = 0; i < max_conn; i++) {
-- 
1.7.9.5

