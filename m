Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39624 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932903AbcECNIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 09:08:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  3 May 2016 16:08:07 +0300
Message-Id: <1462280887-22917-1-git-send-email-luca@coelho.fi> (sfid-20160503_150819_034211_0F3A2103)
Subject: [PATCH] cfg80211: allow to find vendor with OUI without specifying the OUI type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This allows to find vendor IE from a specific vendor.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 include/net/cfg80211.h | 4 ++--
 net/wireless/scan.c    | 8 ++++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 1e008cd..5f6e98ad 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3893,7 +3893,7 @@ const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
  * cfg80211_find_vendor_ie - find vendor specific information element in data
  *
  * @oui: vendor OUI
- * @oui_type: vendor-specific OUI type
+ * @oui_type: vendor-specific OUI type (must be < 0xff), negative means any
  * @ies: data consisting of IEs
  * @len: length of data
  *
@@ -3905,7 +3905,7 @@ const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len);
  * Note: There are no checks on the element length other than having to fit into
  * the given data.
  */
-const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
+const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
 				  const u8 *ies, int len);
 
 /**
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index abdf651..ef2955c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -364,13 +364,16 @@ const u8 *cfg80211_find_ie(u8 eid, const u8 *ies, int len)
 }
 EXPORT_SYMBOL(cfg80211_find_ie);
 
-const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
+const u8 *cfg80211_find_vendor_ie(unsigned int oui, int oui_type,
 				  const u8 *ies, int len)
 {
 	struct ieee80211_vendor_ie *ie;
 	const u8 *pos = ies, *end = ies + len;
 	int ie_oui;
 
+	if (WARN_ON(oui_type > 0xff))
+		return NULL;
+
 	while (pos < end) {
 		pos = cfg80211_find_ie(WLAN_EID_VENDOR_SPECIFIC, pos,
 				       end - pos);
@@ -386,7 +389,8 @@ const u8 *cfg80211_find_vendor_ie(unsigned int oui, u8 oui_type,
 			goto cont;
 
 		ie_oui = ie->oui[0] << 16 | ie->oui[1] << 8 | ie->oui[2];
-		if (ie_oui == oui && ie->oui_type == oui_type)
+		if (ie_oui == oui &&
+		    (oui_type < 0 || ie->oui_type == oui_type))
 			return pos;
 cont:
 		pos += 2 + ie->len;
-- 
2.8.0.rc3

