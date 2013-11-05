Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:36566 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab3KEUzA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 15:55:00 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Cc: johannes@sipsolutions.net
Subject: [RFC v2 1/2] mac80211: don't transmit beacon with CSA count 0
Date: Tue,  5 Nov 2013 22:54:13 +0200
Message-Id: <1383684854-21663-1-git-send-email-luciano.coelho@intel.com> (sfid-20131105_215507_722544_3F836CA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A beacon should never have a Channel Switch Announcement information
element with a count of 0, because a count of 1 means switch just
before the next beacon.  So, if a count of 0 was valid in a beacon, it
would have been transmitted in the next channel already, which is
useless.  A CSA count equal to zero is only meaningful in action
frames or probe_responses.

Fix the ieee80211_csa_is_complete() and ieee80211_update_csa()
functions accordingly.

Cc: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
In v2, updated the documentation to reflect the change.
---
 include/net/mac80211.h | 10 ++++++----
 net/mac80211/tx.c      | 10 +++++++---
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f386c48..2d0c6ab 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2676,11 +2676,13 @@ enum ieee80211_roc_type {
  * @channel_switch_beacon: Starts a channel switch to a new channel.
  *	Beacons are modified to include CSA or ECSA IEs before calling this
  *	function. The corresponding count fields in these IEs must be
- *	decremented, and when they reach zero the driver must call
+ *	decremented, and when they reach 1 the driver must call
  *	ieee80211_csa_finish(). Drivers which use ieee80211_beacon_get()
  *	get the csa counter decremented by mac80211, but must check if it is
- *	zero using ieee80211_csa_is_complete() after the beacon has been
+ *	1 using ieee80211_csa_is_complete() after the beacon has been
  *	transmitted and then call ieee80211_csa_finish().
+ *	If the CSA count starts as zero or 1, this function will not be called,
+ *	since there won't be any time to beacon before the switch anyway.
  *
  * @join_ibss: Join an IBSS (on an IBSS interface); this is called after all
  *	information in bss_conf is set up and the beacon can be retrieved. A
@@ -3379,13 +3381,13 @@ static inline struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * After a channel switch announcement was scheduled and the counter in this
- * announcement hit zero, this function must be called by the driver to
+ * announcement hits 1, this function must be called by the driver to
  * notify mac80211 that the channel can be changed.
  */
 void ieee80211_csa_finish(struct ieee80211_vif *vif);
 
 /**
- * ieee80211_csa_is_complete - find out if counters reached zero
+ * ieee80211_csa_is_complete - find out if counters reached 1
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
  *
  * This function returns whether the channel switch counters reached zero.
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9993fcb..1e0d40f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2376,8 +2376,12 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(counter_offset_beacon >= beacon_data_len))
 		return;
 
-	/* warn if the driver did not check for/react to csa completeness */
-	if (WARN_ON(beacon_data[counter_offset_beacon] == 0))
+	/* Warn if the driver did not check for/react to csa
+	 * completeness.  A beacon with CSA counter set to 0 should
+	 * never occur, because a counter of 1 means switch just
+	 * before the next beacon.
+	 */
+	if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
 		return;
 
 	beacon_data[counter_offset_beacon]--;
@@ -2434,7 +2438,7 @@ bool ieee80211_csa_is_complete(struct ieee80211_vif *vif)
 	if (WARN_ON(counter_beacon > beacon_data_len))
 		goto out;
 
-	if (beacon_data[counter_beacon] == 0)
+	if (beacon_data[counter_beacon] == 1)
 		ret = true;
  out:
 	rcu_read_unlock();
-- 
1.8.4.rc3

