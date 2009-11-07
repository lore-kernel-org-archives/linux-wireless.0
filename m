Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:56128 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZKGUTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 15:19:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	mcgrof@gmail.com, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Subject: [PATCH 02/29] ath9k: update hw configuration for virtual wiphys
Date: Sat,  7 Nov 2009 15:18:39 -0500
Message-Id: <1257625146-17971-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
References: <1257625146-17971-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k supports its own virtual wiphys. The hardware code
relies on the ieee80211_hw for the present interface but
with recent changes introduced the common->hw was never
updated and is required for virtual wiphys.

Cc: Jouni.Malinen <Jouni.Malinen@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/virtual.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index e6a50f3..7678c4a 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -298,6 +298,7 @@ static void ath9k_wiphy_unpause_channel(struct ath_softc *sc)
 void ath9k_wiphy_chan_work(struct work_struct *work)
 {
 	struct ath_softc *sc = container_of(work, struct ath_softc, chan_work);
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_wiphy *aphy = sc->next_wiphy;
 
 	if (aphy == NULL)
@@ -313,6 +314,10 @@ void ath9k_wiphy_chan_work(struct work_struct *work)
 	/* XXX: remove me eventually */
 	ath9k_update_ichannel(sc, aphy->hw,
 			      &sc->sc_ah->channels[sc->chan_idx]);
+
+	/* sync hw configuration for hw code */
+	common->hw = aphy->hw;
+
 	ath_update_chainmask(sc, sc->chan_is_ht);
 	if (ath_set_channel(sc, aphy->hw,
 			    &sc->sc_ah->channels[sc->chan_idx]) < 0) {
-- 
1.6.5.2.143.g8cc62

