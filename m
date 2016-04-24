Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33378 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbcDXXHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Apr 2016 19:07:46 -0400
From: Claudiu Beznea <claudiu.beznea@gmail.com>
To: johnny.kim@atmel.com, austin.shin@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, glen.lee@atmel.com, leo.kim@atmel.com,
	gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Claudiu Beznea <claudiu.beznea@gmail.com>
Subject: [PATCH] Staging: wilc1000: Freed memory in case of error
Date: Mon, 25 Apr 2016 02:07:18 +0300
Message-Id: <1461539238-28907-1-git-send-email-claudiu.beznea@gmail.com> (sfid-20160425_010803_929178_65EA2221)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch frees memory allocated inside wilc_wlan_txq_add_cfg_pkt()
in case wilc_wlan_txq_add_to_head() fails.

Signed-off-by: Claudiu Beznea <claudiu.beznea@gmail.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 7da3b4a..11e16d5 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -325,8 +325,11 @@ static int wilc_wlan_txq_add_cfg_pkt(struct wilc_vif *vif, u8 *buffer,
 	tqe->priv = NULL;
 	tqe->tcp_pending_ack_idx = NOT_TCP_ACK;
 
-	if (wilc_wlan_txq_add_to_head(vif, tqe))
+	if (wilc_wlan_txq_add_to_head(vif, tqe)) {
+		kfree(tqe);
 		return 0;
+	}
+
 	return 1;
 }
 
-- 
1.9.1

