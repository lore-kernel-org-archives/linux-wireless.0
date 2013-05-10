Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab3EJOKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 10:10:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: enable power save only if DTIM period is available
Date: Fri, 10 May 2013 16:10:48 +0200
Message-Id: <1368195048-27326-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_161057_623544_1F856B7B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Generally, the DTIM period is available after a beacon has
been received, and if no beacon has been received enabling
powersave is problematic anyway for synchronisation. Since
some drivers may require the DTIM period for powersave,
don't enable powersave until it becomes available in case
the scan/association managed to not receive a beacon.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 2bfcdda..07a3eb5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1390,6 +1390,9 @@ static bool ieee80211_powersave_allowed(struct ieee80211_sub_if_data *sdata)
 			  IEEE80211_STA_CONNECTION_POLL))
 		return false;
 
+	if (!sdata->vif.bss_conf.dtim_period)
+		return false;
+
 	rcu_read_lock();
 	sta = sta_info_get(sdata, mgd->bssid);
 	if (sta)
@@ -3126,6 +3129,7 @@ ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		}
 
 		changed |= BSS_CHANGED_DTIM_PERIOD;
+		ieee80211_recalc_ps_vif(sdata);
 	}
 
 	if (elems.erp_info) {
-- 
1.8.0

