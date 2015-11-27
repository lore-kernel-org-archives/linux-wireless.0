Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:36039 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbbK0Ihf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 03:37:35 -0500
Received: by lfs39 with SMTP id 39so118585476lfs.3
        for <linux-wireless@vger.kernel.org>; Fri, 27 Nov 2015 00:37:33 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, nbd@openwrt.org,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 09/13] ath9k: request NOA update when chanctx active
Date: Fri, 27 Nov 2015 09:37:14 +0100
Message-Id: <1448613438-5173-9-git-send-email-janusz.dziedzic@tieto.com> (sfid-20151127_095252_037432_E4F109F0)
In-Reply-To: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1448613438-5173-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Request NOA update when chanctx active, also in case
of STA.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
This depends on:
mac80211: add new IEEE80211_VIF_GET_NOA_UPDATE flag

 drivers/net/wireless/ath/ath9k/channel.c | 2 +-
 drivers/net/wireless/ath/ath9k/main.c    | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 5a1ede6..c94d7d9 100644
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

