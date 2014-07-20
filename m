Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:57928 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170AbaGTMbj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:39 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so2836804wib.15
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 10/10] ath9k: initialize ath_node linked list
Date: Sun, 20 Jul 2014 14:31:26 +0200
Message-Id: <1405859486-31414-11-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143146_311215_528D289E)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize neighbor linked list used by estimation algorithm to compute maximum
sta ack timeout

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 52ca884..9a7fe6d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -358,12 +358,16 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	memset(&an->key_idx, 0, sizeof(an->key_idx));
 
 	ath_tx_node_init(sc, an);
+
+	ath_dynack_node_init(sc->sc_ah, an);
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
 	ath_tx_node_cleanup(sc, an);
+
+	ath_dynack_node_deinit(sc->sc_ah, an);
 }
 
 void ath9k_tasklet(unsigned long data)
-- 
1.9.1

