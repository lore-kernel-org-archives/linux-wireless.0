Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4829 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149AbZE1XrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 19:47:20 -0400
Date: Thu, 28 May 2009 19:47:02 -0400
From: Bob Copeland <me@bobcopeland.com>
To: henk <henk@god.dyndns.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k in AP mode works!! (but sometimes with an oops, and a
	panic)
Message-ID: <20090528234702.GA9455@hash.localnet>
References: <20090524222027.GA32198@god.dyndns.org> <b6c5339f0905270550y50a925fbk4b891db8bbb9d9b@mail.gmail.com> <20090527184956.GA14462@god.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090527184956.GA14462@god.dyndns.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 27, 2009 at 08:49:56PM +0200, henk wrote:
> 
> I added some extra checks in ath5k/base.c
> see http://bugzilla.kernel.org/show_bug.cgi?id=13381#c3
> 
> This resolves the panic for now.

Can you try this patch?  It should reduce to a warning if there is
still a bug but hopefully you won't see the warning.  

There's also a chance that it could break beaconing if you kill
hostapd and restart it a few times, but I did a little testing and
it seemed to work ok.

From: Bob Copeland <me@bobcopeland.com>
Date: Thu, 28 May 2009 19:33:50 -0400
Subject: [PATCH] ath5k: disable beacon interrupt when interface is down

When we remove the active interface, there's no need to continue
sending beacons; doing so would cause a null pointer deref in
ieee80211_beacon_get().  Disable the interrupt in remove_interface
and add a WARN_ON(!vif) in case there are other instances lurking.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b6fb15e..f011c44 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2070,6 +2070,13 @@ err_unmap:
 	return ret;
 }
 
+static void ath5k_beacon_disable(struct ath5k_softc *sc)
+{
+	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
+	ath5k_hw_set_imr(sc->ah, sc->imask);
+	ath5k_hw_stop_tx_dma(sc->ah, sc->bhalq);
+}
+
 /*
  * Transmit a beacon frame at SWBA.  Dynamic updates to the
  * frame contents are done as needed and the slot time is
@@ -2758,6 +2765,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 
 	ath5k_hw_set_lladdr(sc->ah, mac);
 	sc->vif = NULL;
+	ath5k_beacon_disable(sc);
 end:
 	mutex_unlock(&sc->lock);
 }
@@ -3059,7 +3067,14 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	int ret;
 	struct ath5k_softc *sc = hw->priv;
-	struct sk_buff *skb = ieee80211_beacon_get(hw, vif);
+	struct sk_buff *skb;
+
+	if (WARN_ON(!vif)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	skb = ieee80211_beacon_get(hw, vif);
 
 	if (!skb) {
 		ret = -ENOMEM;
-- 
1.6.0.6


-- 
Bob Copeland %% www.bobcopeland.com

