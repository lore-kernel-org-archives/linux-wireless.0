Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36639 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318Ab2C2X24 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2012 19:28:56 -0400
Received: by pbcun15 with SMTP id un15so789148pbc.19
        for <linux-wireless@vger.kernel.org>; Thu, 29 Mar 2012 16:28:56 -0700 (PDT)
MIME-Version: 1.0
From: Ashok Nagarajan <ashok@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: javier@cozybit.com, thomas@cozybit.com, johannes@sipsolutions.net,
	devel@lists.open80211s.org, linville@tuxdriver.com,
	Ashok Nagarajan <ashok@cozybit.com>
Subject: [PATCH 1/4] mac80211: Use mandatory rates as basic rates when starting mesh
Date: Thu, 29 Mar 2012 16:28:46 -0700
Message-Id: <1333063729-9353-1-git-send-email-ashok@cozybit.com> (sfid-20120330_012900_159231_2CF107D2)
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

