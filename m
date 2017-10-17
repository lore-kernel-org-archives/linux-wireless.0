Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44570 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763919AbdJQT4H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:56:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Antonio Quartulli <ordex@autistici.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: don't expose wdev->ssid for most interfaces
Date: Tue, 17 Oct 2017 21:56:01 +0200
Message-Id: <20171017195601.805-1-johannes@sipsolutions.net> (sfid-20171017_215610_377287_9820BD9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For mesh, this is simply wrong - there's no SSID, only the
mesh ID, so don't expose it at all.
For (P2P) client, it's wrong, because it exposes an internal
value that's only used when certain APIs are used.
For AP, it's actually the only correct case, so leave that.
All other interface types shouldn't be setting this anyway,
so there it won't change anything.

Fixes: b84e7a05f619 ("nl80211: send the NL80211_ATTR_SSID in nl80211_send_iface()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fce2cbe6a193..d23eb5700788 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2605,10 +2605,32 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 			goto nla_put_failure;
 	}
 
-	if (wdev->ssid_len) {
-		if (nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
+	wdev_lock(wdev);
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_AP:
+		if (wdev->ssid_len &&
+		    nla_put(msg, NL80211_ATTR_SSID, wdev->ssid_len, wdev->ssid))
 			goto nla_put_failure;
+		break;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_ADHOC: {
+		const u8 *ssid_ie;
+		if (!wdev->current_bss)
+			break;
+		ssid_ie = ieee80211_bss_get_ie(&wdev->current_bss->pub,
+					       WLAN_EID_SSID);
+		if (!ssid_ie)
+			break;
+		if (nla_put(msg, NL80211_ATTR_SSID, ssid_ie[1], ssid_ie + 2))
+			goto nla_put_failure;
+		break;
+		}
+	default:
+		/* nothing */
+		break;
 	}
+	wdev_unlock(wdev);
 
 	genlmsg_end(msg, hdr);
 	return 0;
-- 
2.14.2
