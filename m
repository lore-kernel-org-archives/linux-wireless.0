Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:39368 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab0FNGQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 02:16:12 -0400
From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Subject: [PATCH 3/3] mac80211: remove BSS from cfg80211 list when leaving IBSS
Date: Mon, 14 Jun 2010 09:15:45 +0300
Message-Id: <1276496145-5623-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
References: <1276496145-5623-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276496145-5623-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
 <1276496145-5623-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove BSS from cfg80211 BSS list if we are only member in IBSS when
leaving it.

Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
---
 net/mac80211/ibss.c |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff91265..6d5489b 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -969,6 +969,39 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 {
 	struct sk_buff *skb;
 
+	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
+	struct ieee80211_local *local = sdata->local;
+	struct cfg80211_bss *cbss;
+	struct ieee80211_channel *chan = NULL;
+	const u8 *bssid = NULL;
+	u16 capability;
+	int active_ibss = 0;
+
+
+	active_ibss = ieee80211_sta_active_ibss(sdata);
+
+	if (!active_ibss) {
+		capability = WLAN_CAPABILITY_IBSS;
+		if (ifibss->privacy)
+			capability |= WLAN_CAPABILITY_PRIVACY;
+		if (ifibss->fixed_bssid)
+			bssid = ifibss->bssid;
+		if (ifibss->fixed_channel)
+			chan = ifibss->channel;
+		if (!is_zero_ether_addr(ifibss->bssid))
+			bssid = ifibss->bssid;
+		cbss = cfg80211_get_bss(local->hw.wiphy, chan, bssid,
+					ifibss->ssid, ifibss->ssid_len,
+					WLAN_CAPABILITY_IBSS |
+					WLAN_CAPABILITY_PRIVACY,
+					capability);
+
+		if (cbss) {
+			cfg80211_unlink_bss(local->hw.wiphy, cbss);
+			cfg80211_put_bss(cbss);
+		}
+	}
+
 	del_timer_sync(&sdata->u.ibss.timer);
 	clear_bit(IEEE80211_IBSS_REQ_RUN, &sdata->u.ibss.request);
 	cancel_work_sync(&sdata->u.ibss.work);
-- 
1.5.6.3

