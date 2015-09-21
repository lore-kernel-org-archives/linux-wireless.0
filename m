Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45162 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756495AbbIUMr6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:47:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 15:47:40 +0300
Message-Id: <1442839660-25790-1-git-send-email-luca@coelho.fi> (sfid-20150921_144801_527640_E4340D3E)
Subject: [PATCH] mac80211: reset CQM history upon reconfiguration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Current behavior of notifying CQM events is inconsistent.
Upon first configuration there is a cqm event of channel status
according to threshold configured, regardless of signal stability.
When there is reconfiguration no event is sent unless there is
a significant change to the signal level according to the new
configuration.

Since current reconfiguration behavior might cause missing CQM
events in case current signal did not change but is crossing the
new threshold, fix that by resetting latest signal level upon
reconfiguration.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 390eabf..8873f93 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2471,6 +2471,7 @@ static int ieee80211_set_cqm_rssi_config(struct wiphy *wiphy,
 
 	bss_conf->cqm_rssi_thold = rssi_thold;
 	bss_conf->cqm_rssi_hyst = rssi_hyst;
+	sdata->u.mgd.last_cqm_event_signal = 0;
 
 	/* tell the driver upon association, unless already associated */
 	if (sdata->u.mgd.associated &&
-- 
2.5.1

