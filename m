Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:36089 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498AbaIPAN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 20:13:27 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so4718615wgh.22
        for <linux-wireless@vger.kernel.org>; Mon, 15 Sep 2014 17:13:26 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCHv2 10/10] ath9k: initialize ath_node linked list
Date: Tue, 16 Sep 2014 02:13:16 +0200
Message-Id: <1410826396-15544-11-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140916_021335_508461_EA75E892)
In-Reply-To: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1410826396-15544-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize neighbor linked list used by dynack to compute ACK timeout
as the maximum STA ACK timeout

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 6969aba..3e485f7 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -345,12 +345,16 @@ static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
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

