Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401AbZKCDH5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 22:07:57 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [RFT 4/9] ath9k: use the passed ieee80211_hw on ath_rx_prepare()
Date: Mon,  2 Nov 2009 22:07:56 -0500
Message-Id: <1257217681-27180-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
References: <1257217681-27180-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this now uses the proper hw which should mean finding the
right sta when using ath9k virtual wiphy stuff.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 330cd3b..10decfa 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -200,7 +200,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 	}
 
 	rcu_read_lock();
-	sta = ieee80211_find_sta(sc->hw, hdr->addr2);
+	sta = ieee80211_find_sta(hw, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
-- 
1.6.5.2.143.g8cc62

