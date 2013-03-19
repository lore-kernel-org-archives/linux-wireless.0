Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59389 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920Ab3CSVUD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 17:20:03 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] mac80211:  Make beacon-loss-count configurable.
Date: Tue, 19 Mar 2013 14:19:56 -0700
Message-Id: <1363727997-1554-1-git-send-email-greearb@candelatech.com> (sfid-20130319_222010_382492_3F895FA6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

On loaded systems with lots of VIFs, I see lots of beacon
timeouts, even though the connection to the AP is very
good.  Allow tuning the beacon-loss-count variable to
give the system longer to process beacons if the user
prefers.

Signed-off-by:  Ben Greear <greearb@candelatech.com>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 da805e2... 1f1e889... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index da805e2..1f1e889 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -54,7 +54,10 @@ MODULE_PARM_DESC(max_probe_tries,
  * probe on beacon miss before declaring the connection lost
  * default to what we want.
  */
-#define IEEE80211_BEACON_LOSS_COUNT	7
+static int beacon_loss_count = 7;
+module_param(beacon_loss_count, int, 0644);
+MODULE_PARM_DESC(beacon_loss_count,
+		 "Number of beacon intervals before we decide beacon was lost.");
 
 /*
  * Time the connection can be idle before we probe
@@ -1319,7 +1322,7 @@ static void ieee80211_set_associated(struct ieee80211_sub_if_data *sdata,
 		bss_conf->assoc_capability, bss->has_erp_value, bss->erp_value);
 
 	sdata->u.mgd.beacon_timeout = usecs_to_jiffies(ieee80211_tu_to_usec(
-		IEEE80211_BEACON_LOSS_COUNT * bss_conf->beacon_int));
+		beacon_loss_count * bss_conf->beacon_int));
 
 	sdata->u.mgd.associated = cbss;
 	memcpy(sdata->u.mgd.bssid, cbss->bssid, ETH_ALEN);
-- 
1.7.3.4

