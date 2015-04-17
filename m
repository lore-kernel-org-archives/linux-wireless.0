Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47618 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbbDQPQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 11:16:04 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 05/11] mac80211: extend fast-xmit to cover IBSS
Date: Fri, 17 Apr 2015 17:15:45 +0200
Message-Id: <1429283751-5104-5-git-send-email-johannes@sipsolutions.net> (sfid-20150417_171612_624042_E1E239E9)
In-Reply-To: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

IBSS can be supported very easily since it uses the standard station
authorization state etc. so it just needs to be covered by the header
building switch statement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 02aafe1cc121..0f18ee11f097 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2455,6 +2455,13 @@ void ieee80211_check_fast_xmit(struct sta_info *sta, gfp_t gfp)
 	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_DATA);
 
 	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_ADHOC:
+		/* DA SA BSSID */
+		build.da_offs = offsetof(struct ieee80211_hdr, addr1);
+		build.sa_offs = offsetof(struct ieee80211_hdr, addr2);
+		memcpy(hdr->addr3, sdata->u.ibss.bssid, ETH_ALEN);
+		build.hdr_len = 24;
+		break;
 	case NL80211_IFTYPE_STATION:
 		if (test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
 			/* DA SA BSSID */
-- 
2.1.4

