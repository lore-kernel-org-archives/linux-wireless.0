Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:65211 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932363AbaICMct (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:32:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/10] mac80211: use bss_conf->dtim_period instead of conf.ps_dtim_period
Date: Wed,  3 Sep 2014 15:25:04 +0300
Message-Id: <1409747106-30717-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140903_143257_775314_62CA8231)
In-Reply-To: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1409747106-30717-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta_set_sinfo is obviously takes data for specific station.
This specific station is attached to a specific virtual
interface. Hence we should use the dtim_period from this
virtual interface rather than the system wide dtim_period.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/sta_info.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 6274cd7..50f2e31 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1820,7 +1820,7 @@ void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_PREAMBLE;
 	if (sdata->vif.bss_conf.use_short_slot)
 		sinfo->bss_param.flags |= BSS_PARAM_FLAGS_SHORT_SLOT_TIME;
-	sinfo->bss_param.dtim_period = sdata->local->hw.conf.ps_dtim_period;
+	sinfo->bss_param.dtim_period = sdata->vif.bss_conf.dtim_period;
 	sinfo->bss_param.beacon_interval = sdata->vif.bss_conf.beacon_int;
 
 	sinfo->sta_flags.set = 0;
-- 
1.9.1

