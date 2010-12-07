Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:60442 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0LGVmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:42:42 -0500
Received: by iwn40 with SMTP id 40so435422iwn.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 13:42:41 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/3] ath5k: Fix beaconing in mesh mode
Date: Tue,  7 Dec 2010 13:35:55 -0800
Message-Id: <1291757755-29831-1-git-send-email-javier@cozybit.com>
In-Reply-To: <20101207205812.GK2700@tuxdriver.com>
References: <20101207205812.GK2700@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the oops below when attempting to bring up a mesh
interface on ath5k hardware.

[  128.933099] kernel BUG at drivers/net/wireless/ath/ath5k/base.c:197!
[  128.933099] invalid opcode: 0000 [#1]
(...)
[  128.933099] Call Trace:
[  128.933099]  [<c83b77fa>] ? ath5k_beacon_update+0x57/0x1f8 [ath5k]
[  128.933099]  [<c02d9a40>] ? __sysfs_add_one+0x28/0x76
[  128.933099]  [<c83b830e>] ? ath5k_bss_info_changed+0x13f/0x173
[ath5k]
[  128.933099]  [<c82ff629>] ? ieee80211_config_beacon+0xc0/0x17e
[mac80211]
[  128.933099]  [<c82f073e>] ?
ieee80211_bss_info_change_notify+0x182/0x18b [mac80211]
[  128.933099]  [<c83b81cf>] ? ath5k_bss_info_changed+0x0/0x173 [ath5k]
[  128.933099]  [<c82ff6d6>] ? ieee80211_config_beacon+0x16d/0x17e
[mac80211]
[  128.933099]  [<c82ff753>] ? ieee80211_add_beacon+0x34/0x39 [mac80211]
[  128.933099]  [<c830a4ed>] ? ieee80211s_init+0xf8/0x10f [mac80211]
[  128.933099]  [<c830a5df>] ? ieee80211_mesh_init_sdata+0xdb/0x154 [mac80211]

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 0a7071a..6c35730 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1913,8 +1913,9 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		/* NB: hw still stops DMA, so proceed */
 	}
 
-	/* refresh the beacon for AP mode */
-	if (sc->opmode == NL80211_IFTYPE_AP)
+	/* refresh the beacon for AP or MESH mode */
+	if (sc->opmode == NL80211_IFTYPE_AP ||
+			sc->opmode == NL80211_IFTYPE_MESH_POINT)
 		ath5k_beacon_update(sc->hw, vif);
 
 	ath5k_hw_set_txdp(ah, sc->bhalq, bf->daddr);
@@ -2977,7 +2978,8 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 
 	/* Assign the vap/adhoc to a beacon xmit slot. */
 	if ((avf->opmode == NL80211_IFTYPE_AP) ||
-	    (avf->opmode == NL80211_IFTYPE_ADHOC)) {
+	    (avf->opmode == NL80211_IFTYPE_ADHOC) ||
+	    (avf->opmode == NL80211_IFTYPE_MESH_POINT)) {
 		int slot;
 
 		WARN_ON(list_empty(&sc->bcbuf));
-- 
1.7.1

