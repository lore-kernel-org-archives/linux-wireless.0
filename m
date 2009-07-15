Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52578 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbZGOAWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/5] ath9k: do not stop the queues in driver stop
Date: Tue, 14 Jul 2009 20:21:56 -0400
Message-Id: <1247617320-20163-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 will have disabled the queues for us when
needed.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d14f8c9..907434a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2101,8 +2101,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	mutex_lock(&sc->mutex);
 
-	ieee80211_stop_queues(hw);
-
 	if (ath9k_wiphy_started(sc)) {
 		mutex_unlock(&sc->mutex);
 		return; /* another wiphy still in use */
-- 
1.6.0.6

