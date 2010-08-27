Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:47271 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110Ab0H0Fit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 01:38:49 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Kalle Valo <kvalo@adurom.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
Subject: [RFT] mac80211: fix broadcast/multicast data drop on scan
Date: Fri, 27 Aug 2010 01:38:47 -0400
Message-Id: <1282887527-23259-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new scan implementation only takes into consideration
the the listen interval which the driver itself sets. The AP
however will send all buffered broadcast and multicast data
every dtim_period which typically is less than the listen
interval. We are also currently not respecting the pm-qos
network latency. Since dynamic powersave work already computes
for us the minimum allowed sleep period reuse that work
and ensure we don't sleep longer than what we allowed for.

Without this we drop buffered broadcast and multicast traffic.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Kalle Valo <kvalo@adurom.com>
Cc: Amod Bodas <Amod.Bodas@atheros.com>
---

The big question is if the max_sleep_period is synched with 
the DTIM count. If it is not, then we may need something else. 
As I see it only the DTIM period is used for the max_sleep_period
calculation along with the network latency pm-qos requirement.

If this requires a bit too many changes I am not sure how to handle
this for stable. We'll see.

Please test with different DTIM intervals.

 net/mac80211/scan.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 2c7e376..e105304 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -444,6 +444,8 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 	bool tx_empty = true;
 	bool bad_latency;
 	bool listen_int_exceeded;
+	/* accounts for PM_QOS_NETWORK_LATENCY and dtim period */
+	bool latency_dtim_period_exceeded = false;
 	unsigned long min_beacon_int = 0;
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_channel *next_chan;
@@ -466,6 +468,7 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 
 		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
 			if (sdata->u.mgd.associated) {
+
 				associated = true;
 
 				if (sdata->vif.bss_conf.beacon_int <
@@ -511,8 +514,16 @@ static int ieee80211_scan_state_decision(struct ieee80211_local *local,
 				usecs_to_jiffies(min_beacon_int * 1024) *
 				local->hw.conf.listen_interval);
 
+		if (associated && local->hw.conf.max_sleep_period) {
+			latency_dtim_period_exceeded = time_after(jiffies +
+				ieee80211_scan_get_channel_time(next_chan),
+				local->leave_oper_channel_time +
+				usecs_to_jiffies(min_beacon_int * 1024) *
+				local->hw.conf.max_sleep_period);
+		}
+
 		if (associated && ( !tx_empty || bad_latency ||
-		    listen_int_exceeded))
+		    listen_int_exceeded || latency_dtim_period_exceeded))
 			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
 		else
 			local->next_scan_state = SCAN_SET_CHANNEL;
-- 
1.7.0.4

