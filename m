Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:51175 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab3KMRsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 12:48:08 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net, yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v4 4/5] mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_csa_beacon()
Date: Wed, 13 Nov 2013 19:47:30 +0200
Message-Id: <1384364851-31805-4-git-send-email-luciano.coelho@intel.com> (sfid-20131113_184815_046245_058B4221)
In-Reply-To: <1384364851-31805-1-git-send-email-luciano.coelho@intel.com>
References: <1384364851-31805-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of ieee80211_mesh_csa_beacon is not aligned with the
return value of ieee80211_csa_beacon() and
ieee80211_ibss_csa_beacon().  For consistency and to be able to use
both functions with similar code, change ieee80211_mesh_csa_beacon()
not to send the bss changed notification itself, but return what has
changed so the caller can send the notification instead.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---

This depends on Chun-Yeow's "mac80211: fix the mesh channel switch
support", which Johannes already applied but is not in
wireless-testing yet.

 net/mac80211/cfg.c  | 2 ++
 net/mac80211/mesh.c | 4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index e242862..fc5a1f9 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3135,6 +3135,8 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			ifmsh->csa_repeater = false;
 			return err;
 		}
+		changed |= err;
+
 		break;
 #endif
 	default:
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index a2344fc..6d6c56b 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1094,12 +1094,10 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
 		return ret;
 	}
 
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON);
-
 	if (csa_action)
 		ieee80211_send_action_csa(sdata, csa_settings);
 
-	return 0;
+	return BSS_CHANGED_BEACON;
 }
 
 static int mesh_fwd_csa_frame(struct ieee80211_sub_if_data *sdata,
-- 
1.8.4.rc3

