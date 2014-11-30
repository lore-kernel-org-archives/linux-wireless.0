Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:32648 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbaK3PV5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Nov 2014 10:21:57 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: update the channel context after channel switch
Date: Sun, 30 Nov 2014 17:17:26 +0200
Message-Id: <1417360646-5262-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141130_162203_905775_DC707337)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the channel switch has been made, a vif is now using
the channel context which was reserved. When that happens,
we need to update the channel context since its parameters
may change.

I hit a case in which I switched to a 40Mhz channel but the
reserved channel context was still on 20Mhz. The rate control
would try to send 40Mhz packets on a 20Mhz channel context and
that made iwlwifi's firmware unhappy.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/chan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index c7c5142..bde457d 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -996,6 +996,10 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 
 	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
 
+	ieee80211_recalc_smps_chanctx(local, new_ctx);
+	ieee80211_recalc_radar_chanctx(local, new_ctx);
+	ieee80211_recalc_chanctx_min_def(local, new_ctx);
+
 	if (changed)
 		ieee80211_bss_info_change_notify(sdata, changed);
 
-- 
1.9.1

