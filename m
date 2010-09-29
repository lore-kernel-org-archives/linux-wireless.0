Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43745 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab0I2SDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 14:03:09 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/2] mac80211:  Make no-probe-response kernel messages more useful.
Date: Wed, 29 Sep 2010 11:03:02 -0700
Message-Id: <1285783383-20822-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add device name and flags to give better idea of what
exactly is happening.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 77913a1... 04f33cf... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 77913a1..04f33cf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1863,10 +1863,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, try %d\n", bssid,
+			printk(KERN_DEBUG "%s: No probe response from AP %pM"
+				" after %dms, try %d  flags: 0x%x\n",
+				sdata->dev->name, bssid,
 				(1000 * IEEE80211_PROBE_WAIT)/HZ,
-				ifmgd->probe_send_count);
+				ifmgd->probe_send_count, ifmgd->flags);
 #endif
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
@@ -1876,9 +1877,10 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 */
 			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 					  IEEE80211_STA_BEACON_POLL);
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, disconnecting.\n",
-				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+			printk(KERN_DEBUG "%s: No probe response from AP %pM"
+			       " after %dms, disconnecting, flags: 0x%x\n",
+			       sdata->dev->name, bssid,
+			       (1000 * IEEE80211_PROBE_WAIT)/HZ, ifmgd->flags);
 			ieee80211_set_disassoc(sdata, true);
 			mutex_unlock(&ifmgd->mtx);
 			mutex_lock(&local->mtx);
-- 
1.7.2.2

