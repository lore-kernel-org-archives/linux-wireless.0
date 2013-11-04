Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34761 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3KDNKb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 08:10:31 -0500
From: Luciano Coelho <luciano.coelho@intel.com>
To: linux-wireless@vger.kernel.org, sw@simonwunderlich.de
Cc: johannes@sipsolutions.net
Subject: [RFC] mac80211: don't transmit beacon with CSA count 0
Date: Mon,  4 Nov 2013 14:59:15 +0200
Message-Id: <1383569955-13236-1-git-send-email-luciano.coelho@intel.com> (sfid-20131104_141034_505075_1E90A867)
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

Hi Simon (et al),

I identified this issue while playing around with CSA.  I noticed that
we are sending a CSA beaon with count == 0, which should not happen.
The last beacon visible in the current channel (ie. before the switch)
contains a CSA IE with count == 1.

I wanted to check with you if my proposed change would have any
side-effects, especially with the ath9k driver, which is the only user
of this code in the mainline at the moment.

The potential danger here is if you don't check
ieee80211_csa_is_complete() before you send the first CSA beacon out.
With the previous code, there would always be a beacon with CSA (count
== 0), but now, if the count starts with 1, there won't be any.  If
you don't check, my patch will probably introduce a WARN when the
ath9k driver tries to get the beacon without checking for CSA
completion..

Any other comments or a sanity check would also be appreciated.

--
Cheers,
Luca.


 net/mac80211/tx.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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

