Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:42040
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753361AbbIXM74 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2015 08:59:56 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 4.3 2/2] mac80211: fix handling of PS filtering with fast-xmit
Date: Thu, 24 Sep 2015 14:59:49 +0200
Message-Id: <1443099589-69793-2-git-send-email-nbd@openwrt.org> (sfid-20150924_150001_043155_50DE3E09)
In-Reply-To: <1443099589-69793-1-git-send-email-nbd@openwrt.org>
References: <1443099589-69793-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes dropped packets in the tx path in case a non-PS station triggers
the tx filter.

Cc: stable@vger.kernel.org # 4.2
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/status.c | 1 +
 net/mac80211/tx.c     | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 8ba5832..3ed7ddf 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -101,6 +101,7 @@ static void ieee80211_handle_filtered_frame(struct ieee80211_local *local,
 	 * when it wakes up for the next time.
 	 */
 	set_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT);
+	ieee80211_clear_fast_xmit(sta);
 
 	/*
 	 * This code races in the following way:
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index af058eb..77a7726 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1218,8 +1218,10 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 
 	if (!tx->sta)
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
-	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT))
+	else if (test_and_clear_sta_flag(tx->sta, WLAN_STA_CLEAR_PS_FILT)) {
 		info->flags |= IEEE80211_TX_CTL_CLEAR_PS_FILT;
+		ieee80211_check_fast_xmit(tx->sta);
+	}
 
 	info->flags |= IEEE80211_TX_CTL_FIRST_FRAGMENT;
 
@@ -2451,7 +2453,8 @@ void ieee80211_check_fast_xmit(struct sta_info *sta)
 
 	if (test_sta_flag(sta, WLAN_STA_PS_STA) ||
 	    test_sta_flag(sta, WLAN_STA_PS_DRIVER) ||
-	    test_sta_flag(sta, WLAN_STA_PS_DELIVER))
+	    test_sta_flag(sta, WLAN_STA_PS_DELIVER) ||
+	    test_sta_flag(sta, WLAN_STA_CLEAR_PS_FILT))
 		goto out;
 
 	if (sdata->noack_map)
-- 
2.2.2

