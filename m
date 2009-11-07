Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56132 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [PATCH 04/29] ath9k: use the passed ieee80211_hw on ath_rx_prepare()
Date: Sat,  7 Nov 2009 15:18:41 -0500
Message-Id: <1257625146-17971-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this now uses the proper hw which should mean finding the
right sta when using ath9k virtual wiphy stuff. Only
advantage I see here is getting the rssi properly updated
so the 'fix' itself isn't that great, but at least this
is correct.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index c910c10..c6904f0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -201,7 +201,7 @@ static int ath_rx_prepare(struct ieee80211_hw *hw,
 
 	rcu_read_lock();
 	/* XXX: use ieee80211_find_sta! */
-	sta = ieee80211_find_sta_by_hw(sc->hw, hdr->addr2);
+	sta = ieee80211_find_sta_by_hw(hw, hdr->addr2);
 	if (sta) {
 		an = (struct ath_node *) sta->drv_priv;
 		if (ds->ds_rxstat.rs_rssi != ATH9K_RSSI_BAD &&
-- 
1.6.5.2.143.g8cc62

