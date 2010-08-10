Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756556Ab0HJHvE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 03:51:04 -0400
Message-Id: <20100810074700.566831120@sipsolutions.net>
Date: Tue, 10 Aug 2010 09:46:41 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 4/5] mac80211: dont advertise WEP if unavailable
References: <20100810074637.034583799@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When WEP is unavailable, don't advertise it
to cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2010-08-08 11:11:08.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2010-08-08 11:21:24.000000000 +0200
@@ -509,6 +509,7 @@ int ieee80211_register_hw(struct ieee802
 	int channels, max_bitrates;
 	bool supp_ht;
 	static const u32 cipher_suites[] = {
+		/* keep WEP first, it may be removed below */
 		WLAN_CIPHER_SUITE_WEP40,
 		WLAN_CIPHER_SUITE_WEP104,
 		WLAN_CIPHER_SUITE_TKIP,
@@ -596,6 +597,10 @@ int ieee80211_register_hw(struct ieee802
 	local->hw.wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
 	if (!(local->hw.flags & IEEE80211_HW_MFP_CAPABLE))
 		local->hw.wiphy->n_cipher_suites--;
+	if (IS_ERR(local->wep_tx_tfm) || IS_ERR(local->wep_rx_tfm)) {
+		local->hw.wiphy->cipher_suites += 2;
+		local->hw.wiphy->n_cipher_suites -= 2;
+	}
 
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)


