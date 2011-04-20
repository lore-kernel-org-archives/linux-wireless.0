Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45415 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab1DTF22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 01:28:28 -0400
Received: by mail-pz0-f46.google.com with SMTP id 9so215203pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2011 22:28:28 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19886.28564.501697.981883@gargle.gargle.HOWL>
Date: Wed, 20 Apr 2011 11:01:00 +0530
To: linville@tuxdriver.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH 3/5] ath9k_htc: Fix max A-MPDU size handling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

Set the maximum ampdu size of a station correctly
in the target by using the ampdu_factor.

Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_main.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
index a640268..fbc238a 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
@@ -467,6 +467,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 	struct ath9k_htc_sta *ista;
 	int ret, sta_idx;
 	u8 cmd_rsp;
+	u16 maxampdu;
 
 	if (priv->nstations >= ATH9K_HTC_MAX_STA)
 		return -ENOBUFS;
@@ -490,7 +491,15 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
 
 	tsta.sta_index = sta_idx;
 	tsta.vif_index = avp->index;
-	tsta.maxampdu = cpu_to_be16(0xffff);
+
+	if (!sta) {
+		tsta.maxampdu = cpu_to_be16(0xffff);
+	} else {
+		maxampdu = 1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+				 sta->ht_cap.ampdu_factor);
+		tsta.maxampdu = cpu_to_be16(maxampdu);
+	}
+
 	if (sta && sta->ht_cap.ht_supported)
 		tsta.flags = cpu_to_be16(ATH_HTC_STA_HT);
 
-- 
1.7.4.4

