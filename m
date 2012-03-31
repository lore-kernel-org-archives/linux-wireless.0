Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54864 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2CaUcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 16:32:22 -0400
Received: by obbtb18 with SMTP id tb18so473268obb.19
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 13:32:21 -0700 (PDT)
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [[PATCH v2 1/4] mac80211: Use mandatory rates as basic rates when starting mesh
Date: Sat, 31 Mar 2012 13:32:07 -0700
Message-Id: <1333225930-320-1-git-send-email-ashok@cozybit.com> (sfid-20120331_223226_585678_8C0BDF25)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/mesh.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 1f82c61..56ec79d 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -579,8 +579,12 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	ieee80211_mesh_root_setup(ifmsh);
 	ieee80211_queue_work(&local->hw, &sdata->work);
 	sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
+	sdata->vif.bss_conf.basic_rates =
+		ieee80211_mandatory_rates(sdata->local,
+					  sdata->local->hw.conf.channel->band);
 	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
 						BSS_CHANGED_BEACON_ENABLED |
+						BSS_CHANGED_BASIC_RATES |
 						BSS_CHANGED_BEACON_INT);
 }
 
-- 
1.7.5.4

