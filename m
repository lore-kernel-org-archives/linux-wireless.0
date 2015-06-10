Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5916 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbbFJNtq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 09:49:46 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Disable U-APSD if connected to a SISO or non-HT AP
Date: Wed, 10 Jun 2015 16:49:40 +0300
Message-Id: <1433944180-17321-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150610_154950_346193_4B25E50C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

There are a few APs our there that advertise U-APSD
capabilities but don't implement it right which leads to
poor traffic. These APs don't support MIMO or don't even
support HT. Use this heuristic to detect them and disable
U-APSD accordingly.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/scan.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7bb6a93..3791c8a 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -39,6 +39,28 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 			 container_of((void *)bss, struct cfg80211_bss, priv));
 }
 
+/*
+ * An incompatible AP workaround:
+ * if the AP does not advertise MIMO capabilities disable U-APSD.
+ * iPhones, among others, advertise themselves as U-APSD capable when
+ * they aren't. Avoid connecting to those devices in U-APSD enabled.
+ */
+static bool broken_uapsd_workarounds(struct ieee802_11_elems *elems)
+{
+	int i;
+
+	/* iPhone 4/4s with this problem doesn't have ht_capa */
+	if (!elems->ht_cap_elem)
+		return true;
+
+	for (i = 1; i < 4; i++) {
+		if (elems->ht_cap_elem->mcs.rx_mask[i])
+			return false;
+	}
+
+	return true;
+}
+
 static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 {
 	u8 qos_info;
@@ -53,6 +75,9 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 		/* no valid wmm information or parameter element found */
 		return false;
 
+	if (broken_uapsd_workarounds(elems))
+		return false;
+
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
-- 
2.1.4

