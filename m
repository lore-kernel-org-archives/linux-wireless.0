Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:27402 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0FNJ4S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 05:56:18 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH v2 3/3] mac80211: remove BSS from cfg80211 list when leaving IBSS
Date: Mon, 14 Jun 2010 12:55:33 +0300
Message-Id: <1276509333-19023-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276509333-19023-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276509333-19023-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276509333-19023-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276509333-19023-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove BSS from cfg80211 BSS list if we are only member in IBSS when
leaving it.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/mac80211/ibss.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff91265..59e46ee 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -968,6 +968,31 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_bss *cbss;
+	u16 capability;
+	int active_ibss = 0;
+
+	active_ibss = ieee80211_sta_active_ibss(sdata);
+
+	if (!active_ibss && !is_zero_ether_addr(ifibss->bssid)) {
+		capability = WLAN_CAPABILITY_IBSS;
+
+		if (ifibss->privacy)
+			capability |= WLAN_CAPABILITY_PRIVACY;
+
+		cbss = cfg80211_get_bss(local->hw.wiphy, ifibss->channel,
+					ifibss->bssid, ifibss->ssid,
+					ifibss->ssid_len, WLAN_CAPABILITY_IBSS |
+					WLAN_CAPABILITY_PRIVACY,
+					capability);
+
+		if (cbss) {
+			cfg80211_unlink_bss(local->hw.wiphy, cbss);
+			cfg80211_put_bss(cbss);
+		}
+	}
 
 	del_timer_sync(&sdata->u.ibss.timer);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
-- 
1.5.6.3

