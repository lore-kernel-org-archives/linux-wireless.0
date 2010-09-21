Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34981 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753560Ab0IUH0u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 03:26:50 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 21 Sep 2010 00:26:43 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH v2] ath9k_htc: Fix beacon distribution in IBSS mode
Date: Tue, 21 Sep 2010 12:58:09 +0530
Message-ID: <1285054089-6707-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch ensures fair beacon distribution in IBSS mode
by configuring proper CWmin based on slot time.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_beacon.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
index bd1506e..1b72aa4 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_beacon.c
@@ -235,7 +235,14 @@ void ath9k_htc_beaconq_config(struct ath9k_htc_priv *priv)
 	ath9k_hw_get_txq_props(ah, qnum, &qi_be);
 
 	qi.tqi_aifs = qi_be.tqi_aifs;
-	qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
+	/* For WIFI Beacon Distribution
+	 * Long slot time  : 2x cwmin
+	 * Short slot time : 4x cwmin
+	 */
+	if (ah->slottime == ATH9K_SLOT_TIME_20)
+		qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
+	else
+		qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
 	qi.tqi_cwmax = qi_be.tqi_cwmax;
 
 	if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
-- 
1.7.3

