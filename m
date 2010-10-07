Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51563 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab0JGXMT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Oct 2010 19:12:19 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] mac80211:  Improve mlme probe response log messages.
Date: Thu,  7 Oct 2010 16:12:06 -0700
Message-Id: <1286493126-18316-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Old messages didn't mention the device in question.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 5695c94... a3a9421... M	net/mac80211/mlme.c
 net/mac80211/mlme.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5695c94..a3a9421 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1864,10 +1864,12 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 		else if (ifmgd->probe_send_count < IEEE80211_MAX_PROBE_TRIES) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, try %d\n", bssid,
-				(1000 * IEEE80211_PROBE_WAIT)/HZ,
-				ifmgd->probe_send_count);
+			wiphy_debug(local->hw.wiphy,
+				    "%s: No probe response from AP %pM"
+				    " after %dms, try %d\n",
+				    sdata->name,
+				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ,
+				    ifmgd->probe_send_count);
 #endif
 			ieee80211_mgd_probe_ap_send(sdata);
 		} else {
@@ -1877,9 +1879,11 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 */
 			ifmgd->flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 					  IEEE80211_STA_BEACON_POLL);
-			printk(KERN_DEBUG "No probe response from AP %pM"
-				" after %dms, disconnecting.\n",
-				bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
+			wiphy_debug(local->hw.wiphy,
+				    "%s: No probe response from AP %pM"
+				    " after %dms, disconnecting.\n",
+				    sdata->name,
+				    bssid, (1000 * IEEE80211_PROBE_WAIT)/HZ);
 			ieee80211_set_disassoc(sdata, true, true);
 			mutex_unlock(&ifmgd->mtx);
 			mutex_lock(&local->mtx);
-- 
1.7.2.2

