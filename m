Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:58770 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbaAMRnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:07 -0500
From: Luciano Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de,
	yeohchunyeow@gmail.com
Cc: yeohchunyeow@cozybit.com
Subject: [PATCH v11 2/3] mac80211: align ieee80211_mesh_csa_beacon() with ieee80211_assign_beacon()
Date: Mon, 13 Jan 2014 19:42:59 +0200
Message-Id: <1389634980-12584-3-git-send-email-luca@coelho.fi> (sfid-20140113_184316_965226_28B2F634)
In-Reply-To: <1389634980-12584-1-git-send-email-luca@coelho.fi>
References: <1389634980-12584-1-git-send-email-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The return value of ieee80211_mesh_csa_beacon is not aligned with the
return value of ieee80211_assign_beacon() and
ieee80211_ibss_csa_beacon().  For consistency and to be able to use
both functions with similar code, change ieee80211_mesh_csa_beacon()
not to send the bss changed notification itself, but return what has
changed so the caller can send the notification instead.

Tested by: Simon Wunderlich <sw@simonwunderlich.de>
Acked by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 net/mac80211/mesh.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 319adf4..b421993 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1104,12 +1104,10 @@ int ieee80211_mesh_csa_beacon(struct ieee80211_sub_if_data *sdata,
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
1.8.5.2

