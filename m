Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:19665 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933928AbbFJRTA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 13:19:00 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: allow passing NULL to ieee80211_vif_to_wdev()
Date: Wed, 10 Jun 2015 20:18:55 +0300
Message-Id: <1433956735-22919-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150610_191923_848384_0AC94DE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Simply return NULL in this case, instead of crashing. This can
simplify callers that would otherwise have to check for this
explicitly.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index b864ebc..28858b4 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -752,7 +752,12 @@ EXPORT_SYMBOL_GPL(wdev_to_ieee80211_vif);
 
 struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_sub_if_data *sdata;
+
+	if (!vif)
+		return NULL;
+
+	sdata = vif_to_sdata(vif);
 
 	if (!ieee80211_sdata_running(sdata) ||
 	    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
-- 
2.1.4

