Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:55031 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757633Ab1IHAuK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 20:50:10 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so370400pzk.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Sep 2011 17:50:10 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, jlopex@gmail.com
Subject: [PATCH v2 3/3] mac80211: Mark all mesh stations as QoS capable
Date: Wed,  7 Sep 2011 17:49:54 -0700
Message-Id: <1315442994-304-4-git-send-email-javier@cozybit.com> (sfid-20110908_025015_476053_1D322CA9)
In-Reply-To: <1315442994-304-1-git-send-email-javier@cozybit.com>
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 net/mac80211/mesh_plink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1a00d0f..4396906 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -88,7 +88,7 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	if (!sta)
 		return NULL;
 
-	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH;
+	sta->flags = WLAN_STA_AUTHORIZED | WLAN_STA_AUTH | WLAN_STA_WME;
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	rate_control_rate_init(sta);
 
-- 
1.7.6

