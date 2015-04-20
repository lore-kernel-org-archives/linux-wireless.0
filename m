Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14340 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbbDTTwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2015 15:52:21 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] mac80211: Disable U-APSD if connected to a SISO AP
Date: Mon, 20 Apr 2015 22:52:16 +0300
Message-Id: <1429559536-22907-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150420_215224_618619_4354B500)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

This concerns a bugy behavior of some APs, that advertise themselves
falsely as supporting U-APSD, but they don't which affects throughput.
It was detected in iPhones, but recently also with some Netgear models.
Those devices also advertise their capabilities as SISO, so use that
and disable U-APSD if connected to a SISO AP.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/scan.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 7bb6a93..400ff62 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -42,6 +42,7 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
 static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 {
 	u8 qos_info;
+	int i;
 
 	if (elems->wmm_info && elems->wmm_info_len == 7
 	    && elems->wmm_info[5] == 1)
@@ -53,6 +54,22 @@ static bool is_uapsd_supported(struct ieee802_11_elems *elems)
 		/* no valid wmm information or parameter element found */
 		return false;
 
+	/*
+	 * if the AP does not advertise MIMO capabilities -
+	 * disable U-APSD. iPhones, among others, advertise themselves
+	 * as U-APSD capable when they aren't. Avoid connecting to
+	 * those devices in U-APSD enabled.
+	 */
+	if (elems->parse_error || !elems->ht_cap_elem)
+		goto mimo;
+
+	for (i = 1; i < 4; i++) {
+		if (elems->ht_cap_elem->mcs.rx_mask[i])
+			goto mimo;
+	}
+	return false;
+
+mimo:
 	return qos_info & IEEE80211_WMM_IE_AP_QOSINFO_UAPSD;
 }
 
-- 
2.1.0

