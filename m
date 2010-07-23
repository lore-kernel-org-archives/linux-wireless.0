Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22509 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab0GWFN6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jul 2010 01:13:58 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 22 Jul 2010 22:13:58 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19529.9687.183293.284789@gargle.gargle.HOWL>
Date: Fri, 23 Jul 2010 10:47:11 +0530
To: <linville@tuxdriver.com>
CC: <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Don't set per-BSS QoS for monitor interfaces
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In AP mode, there is no need to notify the driver about QoS
changes for the monitor interface that is created. The warning
in ieee80211_bss_info_change_notify() would be hit otherwise.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 net/mac80211/util.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 7947921..748387d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -803,8 +803,12 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 	/* after reinitialize QoS TX queues setting to default,
 	 * disable QoS at all */
-	sdata->vif.bss_conf.qos = sdata->vif.type != NL80211_IFTYPE_STATION;
-	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+
+	if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
+		sdata->vif.bss_conf.qos =
+			sdata->vif.type != NL80211_IFTYPE_STATION;
+		ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_QOS);
+	}
 }
 
 void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
-- 
1.7.1.1

