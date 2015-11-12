Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36270 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbbKLNQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 08:16:22 -0500
Received: by lfs39 with SMTP id 39so33705537lfs.3
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2015 05:16:21 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 09/12] ath9k: request NOA update when chanctx active
Date: Thu, 12 Nov 2015 14:15:46 +0100
Message-Id: <1447334149-15507-9-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151112_141631_451064_BB577413)
In-Reply-To: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1447334149-15507-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Request NOA update when chanctx active, also in case
of STA.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
This depends on:
[PATCH] mac80211: add new IEEE80211_VIF_GET_NOA_UPDATE flag

 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index db49bc5..4320928 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1439,7 +1439,7 @@ static void ath9k_update_p2p_ps(struct ath_softc *sc, struct ieee80211_vif *vif)
 	if (!sc->p2p_ps_timer)
 		return;
 
-	if (vif->type != NL80211_IFTYPE_STATION || !vif->p2p)
+	if (vif->type != NL80211_IFTYPE_STATION)
 		return;
 
 	sc->p2p_ps_vif = avp;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index d184e68..ab46a4d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -974,7 +974,7 @@ static void ath9k_update_bssid_mask(struct ath_softc *sc,
 		if (ctx->nvifs_assigned != 1)
 			continue;
 
-		if (!avp->vif->p2p || !iter_data->has_hw_macaddr)
+		if (!iter_data->has_hw_macaddr)
 			continue;
 
 		ether_addr_copy(common->curbssid, avp->bssid);
@@ -1251,6 +1251,9 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	ath_dbg(common, CONFIG, "Attach a VIF of type: %d\n", vif->type);
 	sc->cur_chan->nvifs++;
 
+	if (vif->type == NL80211_IFTYPE_STATION && ath9k_is_chanctx_enabled())
+		vif->driver_flags |= IEEE80211_VIF_GET_NOA_UPDATE;
+
 	if (ath9k_uses_beacons(vif->type))
 		ath9k_beacon_assign_slot(sc, vif);
 
-- 
1.9.1

