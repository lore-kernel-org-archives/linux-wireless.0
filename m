Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:52961 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab3LCNs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 08:48:29 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v6 4/5] mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_csa_beacon()
Date: Tue,  3 Dec 2013 15:48:21 +0200
Message-Id: <1386078502-19845-5-git-send-email-luciano.coelho@intel.com> (sfid-20131203_144837_230502_68B77369)
In-Reply-To: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
References: <1386078502-19845-1-git-send-email-luciano.coelho@intel.com>
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
 net/mac80211/mesh.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 980cc12..5476ad9 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1089,12 +1089,10 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
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
1.8.4.2

