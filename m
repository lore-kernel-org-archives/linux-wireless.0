Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:52518 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab3KNMKM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 07:10:12 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	johannes@sipsolutions.net, yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v5 4/5] mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_csa_beacon()
Date: Thu, 14 Nov 2013 14:09:35 +0200
Message-Id: <1384430976-13708-4-git-send-email-luciano.coelho@intel.com> (sfid-20131114_131023_873754_036A726A)
In-Reply-To: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com>
References: <1384430976-13708-1-git-send-email-luciano.coelho@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The return value of ieee80211_mesh_csa_beacon is not aligned with the
return value of ieee80211_csa_beacon() and
ieee80211_ibss_csa_beacon().  For consistency and to be able to use
both functions with similar code, change ieee80211_mesh_csa_beacon()
not to send the bss changed notification itself, but return what has
changed so the caller can send the notification instead.

Change-Id: If4c111fd874a3e17a5df98d306f7f1c8fcaa6a1a
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c  | 2 ++
 net/mac80211/mesh.c | 4 +---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a5aa766..6eb8e08 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3155,6 +3155,8 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
 			ifmsh->csa_role = IEEE80211_MESH_CSA_ROLE_NONE;
 			return err;
 		}
+		changed |= err;
+
 		break;
 #endif
 	default:
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5852080..94dff7f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1091,12 +1091,10 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
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

