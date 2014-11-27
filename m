Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49925 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaK0Nqn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 08:46:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [RFC] mac80211: update the channel context after channel switch
Date: Thu, 27 Nov 2014 15:41:57 +0200
Message-Id: <1417095717-23017-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141127_144646_275597_38604860)
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
This is a second version of the patch I sent earlier.
I think the first version is more generic.

Luca / Michal / Whoever, please share your thoughts on which version
should be merged.
---
 net/mac80211/chan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 4c74e8d..eadc1a0 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -993,6 +993,10 @@ ieee80211_vif_use_reserved_reassign(struct ieee80211_sub_if_data *sdata)
 
 	sdata->vif.bss_conf.chandef = sdata->reserved_chandef;
 
+	ieee80211_recalc_smps_chanctx(local, new_ctx);
+	ieee80211_recalc_radar_chanctx(local, new_ctx);
+	ieee80211_recalc_chanctx_min_def(local, new_ctx);
+
 	if (changed)
 		ieee80211_bss_info_change_notify(sdata, changed);
 
-- 
1.9.1

