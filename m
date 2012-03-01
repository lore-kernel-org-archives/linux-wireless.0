Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55304 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030350Ab2CAO2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 09:28:20 -0500
Subject: [PATCH] cfg80211: fix kernel-doc
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Mar 2012 15:28:19 +0100
Message-ID: <1330612099.3623.8.camel@jlt3.sipsolutions.net> (sfid-20120301_152824_102778_67A11174)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

I forgot to update the kernel-doc in my patch
to redesign AP mode APIs, fix that now.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Cc Randy, just in case you notice it too :)

 include/net/cfg80211.h |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/include/net/cfg80211.h	2012-02-25 10:21:14.000000000 +0100
+++ b/include/net/cfg80211.h	2012-03-01 15:26:54.000000000 +0100
@@ -1356,12 +1356,10 @@ struct cfg80211_gtk_rekey_data {
  *
  * @set_rekey_data: give the data necessary for GTK rekeying to the driver
  *
- * @add_beacon: Add a beacon with given parameters, @head, @interval
- *	and @dtim_period will be valid, @tail is optional.
- * @set_beacon: Change the beacon parameters for an access point mode
- *	interface. This should reject the call when no beacon has been
- *	configured.
- * @del_beacon: Remove beacon configuration and stop sending the beacon.
+ * @start_ap: Start acting in AP mode defined by the parameters.
+ * @change_beacon: Change the beacon parameters for an access point mode
+ *	interface. This should reject the call when AP mode wasn't started.
+ * @stop_ap: Stop being an AP, including stopping beaconing.
  *
  * @add_station: Add a new station.
  * @del_station: Remove a station; @mac may be NULL to remove all stations.


