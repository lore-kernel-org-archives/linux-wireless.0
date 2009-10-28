Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59811 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbZJ1Unn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2009 16:43:43 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jouni.Malinen@atheros.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [RFC] ath9k: update hw configuration for virtual wiphys
Date: Wed, 28 Oct 2009 16:43:47 -0400
Message-Id: <1256762627-1574-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k supports its own virtual wiphys. The hardware code
relies on the ieee80211_hw for the present interface but
with recent changes introduced the common->hw was never
updated and is required for virtual wiphys.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

Jouni, it seems this the right place for this, do you agree?

 drivers/net/wireless/ath/ath9k/virtual.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index bc7d173..fe2e300 100644
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
1.6.0.4

