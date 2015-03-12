Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:19662 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbbCLGxd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 02:53:33 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/7] mac80211: allow to get wireless_dev structure from ieee80211_vif
Date: Thu, 12 Mar 2015 08:53:24 +0200
Message-Id: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_075346_708466_5340CF93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will allow mac80211 drivers to call cfg80211 APIs with
the right handle.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 include/net/mac80211.h | 13 +++++++++++++
 net/mac80211/util.c    | 12 ++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index a7756e4..157c0f1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1282,6 +1282,19 @@ static inline bool ieee80211_vif_is_mesh(struct ieee80211_vif *vif)
 struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev);
 
 /**
+ * ieee80211_vif_to_wdev - return a wdev struct from a vif
+ * @vif: the vif to get the wdev for
+ *
+ * This can be used by mac80211 drivers with direct cfg80211 APIs
+ * (like the vendor commands) that needs to get the wdev for a vif.
+ *
+ * Note that this function may return %NULL if the given wdev isn't
+ * associated with a vif that the driver knows about (e.g. monitor
+ * or AP_VLAN interfaces.)
+ */
+struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif);
+
+/**
  * enum ieee80211_key_flags - key flags
  *
  * These flags are used for communication about keys between the driver
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 37d85d3..e664b28 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -745,6 +745,18 @@ struct ieee80211_vif *wdev_to_ieee80211_vif(struct wireless_dev *wdev)
 }
 EXPORT_SYMBOL_GPL(wdev_to_ieee80211_vif);
 
+struct wireless_dev *ieee80211_vif_to_wdev(struct ieee80211_vif *vif)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	if (!ieee80211_sdata_running(sdata) ||
+	    !(sdata->flags & IEEE80211_SDATA_IN_DRIVER))
+		return NULL;
+
+	return &sdata->wdev;
+}
+EXPORT_SYMBOL_GPL(ieee80211_vif_to_wdev);
+
 /*
  * Nothing should have been stuffed into the workqueue during
  * the suspend->resume cycle. Since we can't check each caller
-- 
1.9.1

