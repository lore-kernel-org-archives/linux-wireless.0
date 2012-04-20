Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:16753 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757441Ab2DTTBr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 15:01:47 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH v4 1/1] mac80211: declare ieee80211_ave_rssi as EXPORT
Date: Fri, 20 Apr 2012 11:57:00 -0700
Message-Id: <1334948220-22050-1-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120420_210156_601058_AF5ADC02)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_ave_rssi need to be declare as export for driver to use it.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
v3: provide documentation
v4: move the documentation to the header file
---
 include/net/mac80211.h |    8 ++++++++
 net/mac80211/util.c    |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index bebd89f..da36581 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3802,6 +3802,14 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif,
 int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
 				struct sk_buff *skb, bool need_basic);
 
+/**
+ * ieee80211_ave_rssi - report the average rssi for the specified interface
+ *
+ * @vif: the specified virtual interface
+ *
+ * This function return the average rssi value for the requested interface.
+ * It assumes that the given vif is valid.
+ */
 int ieee80211_ave_rssi(struct ieee80211_vif *vif);
 
 #endif /* MAC80211_H */
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 89c1e5b..c42c49c 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1801,3 +1801,4 @@ int ieee80211_ave_rssi(struct ieee80211_vif *vif)
 
 	return ifmgd->ave_beacon_signal;
 }
+EXPORT_SYMBOL_GPL(ieee80211_ave_rssi);
-- 
1.7.0.4

