Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:33244 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbaGGJb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2014 05:31:57 -0400
Received: by mail-wi0-f169.google.com with SMTP id hi2so14638490wib.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2014 02:31:56 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: ath9k-devel@lists.ath9k.org
Cc: linux-wireless@vger.kernel.org
Subject: [RFC 10/10] ath9k: add ath_node linked list
Date: Mon,  7 Jul 2014 11:31:46 +0200
Message-Id: <1404725506-9571-11-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140707_113212_086005_C4F04D4A)
In-Reply-To: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1404725506-9571-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add neighbor linked list used by estimation algorithm to compute maximum sta
ack timeout

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5d8af08..ee07776 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -350,6 +350,7 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 			    struct ieee80211_vif *vif)
 {
 	struct ath_node *an;
+	struct ath_dynack *da = &sc->sc_ah->dynack;
 	an = (struct ath_node *)sta->drv_priv;
 
 	an->sc = sc;
@@ -358,12 +359,21 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
 	memset(&an->key_idx, 0, sizeof(an->key_idx));
 
 	ath_tx_node_init(sc, an);
+
+	spin_lock(&da->qlock);
+	list_add_tail(&an->list, &da->nodes);
+	spin_unlock(&da->qlock);
 }
 
 static void ath_node_detach(struct ath_softc *sc, struct ieee80211_sta *sta)
 {
 	struct ath_node *an = (struct ath_node *)sta->drv_priv;
+	struct ath_dynack *da = &sc->sc_ah->dynack;
 	ath_tx_node_cleanup(sc, an);
+
+	spin_lock(&da->qlock);
+	list_del(&an->list);
+	spin_unlock(&da->qlock);
 }
 
 void ath9k_tasklet(unsigned long data)
-- 
1.9.1

