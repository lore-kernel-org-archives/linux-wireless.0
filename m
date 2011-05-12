Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:57526 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab1ELJyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 05:54:21 -0400
Date: Thu, 12 May 2011 15:14:57 +0530
From: Yogesh Ashok Powar <yogeshp@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: net/mac80211/cfg.c:746: error
Message-ID: <20110512094456.GB32495@hertz.marvell.com> (sfid-20110512_115436_914880_D32FF64E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, 
Have seen following error during the compilation

>net/mac80211/cfg.c: In function ‘sta_apply_parameters’:
>net/mac80211/cfg.c:746: error: ‘struct sta_info’ has no member named ‘plink_state’
>make[1]: *** [net/mac80211/cfg.o] Error 1
>make: *** [net/mac80211/mac80211.ko] Error 2

May be following is the fix

Thanks
Yogesh

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a2ff474..ed3400c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -738,6 +738,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 						  &sta->sta.ht_cap);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+#ifdef CONFIG_MAC80211_MESH
 		if (sdata->u.mesh.security & IEEE80211_MESH_SEC_SECURED)
 			switch (params->plink_state) {
 			case PLINK_LISTEN:
@@ -758,6 +759,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 				mesh_plink_block(sta);
 				break;
 			}
+#endif
 	}
 }

--
