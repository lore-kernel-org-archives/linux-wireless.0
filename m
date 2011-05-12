Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33050 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755929Ab1ELNpw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 09:45:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Yogesh Ashok Powar <yogeshp@marvell.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Fix mesh-related build breakage...
Date: Thu, 12 May 2011 09:34:55 -0400
Message-Id: <1305207295-31362-1-git-send-email-linville@tuxdriver.com> (sfid-20110512_154556_501070_4F382FE2)
In-Reply-To: <20110512094456.GB32495@hertz.marvell.com>
References: <20110512094456.GB32495@hertz.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

net/mac80211/cfg.c: In function ‘sta_apply_parameters’:
net/mac80211/cfg.c:746: error: ‘struct sta_info’ has no member named ‘plink_state’
make[1]: *** [net/mac80211/cfg.o] Error 1
make: *** [net/mac80211/mac80211.ko] Error 2

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/cfg.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

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
1.7.4.4

