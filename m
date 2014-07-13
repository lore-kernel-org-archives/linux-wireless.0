Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:52175 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbaGMKSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 06:18:39 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so1209791wib.15
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 03:18:34 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [RFCv2 10/10] ath9k: initialize ath_node linked list
Date: Sun, 13 Jul 2014 12:18:24 +0200
Message-Id: <1405246704-7489-11-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140713_121851_312644_4953BF21)
In-Reply-To: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405246704-7489-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize neighbor linked list used by estimation algorithm to compute maximum
sta ack timeout

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 689db57..93ad6c1 100644
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

