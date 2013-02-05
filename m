Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47636 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab3BEPxm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 10:53:42 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: remove scan ies NULL check
Date: Tue,  5 Feb 2013 16:54:01 +0100
Message-Id: <1360079641-14357-1-git-send-email-johannes@sipsolutions.net> (sfid-20130205_165345_419164_1209E500)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no way scan BSS IEs can be NULL as even
if the allocation fails the frame is discarded.
Remove some code checking for this and document
that it is always non-NULL.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mwifiex/sta_ioctl.c |  5 -----
 include/net/cfg80211.h                   |  8 ++++----
 net/wireless/scan.c                      | 11 +++--------
 3 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index ee85b41..8866a2b 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -162,11 +162,6 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 
 	rcu_read_lock();
 	ies = rcu_dereference(bss->ies);
-	if (WARN_ON(!ies)) {
-		/* should never happen */
-		rcu_read_unlock();
-		return -EINVAL;
-	}
 	beacon_ie = kmemdup(ies->data, ies->len, GFP_ATOMIC);
 	beacon_ie_len = ies->len;
 	rcu_read_unlock();
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2907cec..7b73267 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1299,10 +1299,10 @@ struct cfg80211_bss_ies {
  * @tsf: timestamp of last received update
  * @beacon_interval: the beacon interval as from the frame
  * @capability: the capability field in host byte order
- * @ies: the information elements (Note that there
- *	is no guarantee that these are well-formed!); this is a pointer to
- *	either the beacon_ies or proberesp_ies depending on whether Probe
- *	Response frame has been received
+ * @ies: the information elements (Note that there is no guarantee that these
+ *	are well-formed!); this is a pointer to either the beacon_ies or
+ *	proberesp_ies depending on whether Probe Response frame has been
+ *	received. It is always non-%NULL.
  * @beacon_ies: the information elements from the last Beacon frame
  *	(implementation note: if @hidden_beacon_bss is set this struct doesn't
  *	own the beacon_ies, but they're just pointers to the ones from the
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 5e0983d..02a2383 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1293,15 +1293,10 @@ ieee80211_bss(struct wiphy *wiphy, struct iw_request_info *info,
 
 	rcu_read_lock();
 	ies = rcu_dereference(bss->pub.ies);
-	if (ies) {
-		rem = ies->len;
-		ie = ies->data;
-	} else {
-		rem = 0;
-		ie = NULL;
-	}
+	rem = ies->len;
+	ie = ies->data;
 
-	while (ies && rem >= 2) {
+	while (rem >= 2) {
 		/* invalid data */
 		if (ie[1] > rem - 2)
 			break;
-- 
1.8.0

