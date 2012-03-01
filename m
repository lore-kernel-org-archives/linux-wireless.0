Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35338 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030546Ab2CAKYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 05:24:03 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH] mac80211: use 16 bit alignment for the if_ibss bssid field
Date: Thu,  1 Mar 2012 11:23:37 +0100
Message-Id: <1330597417-74535-1-git-send-email-nbd@openwrt.org> (sfid-20120301_112420_223525_304D0884)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several MAC address comparison functions assume 16 bit alignment for pointers
passed to them. Since the addition of the control_port field, alignment
for the IBSS bssid was off by one, causing a severe performance hit on
architectures without efficient unaligned access (e.g. MIPS).

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/ieee80211_i.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index cee0c74..c413058 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -480,7 +480,7 @@ struct ieee80211_if_ibss {
 
 	bool control_port;
 
-	u8 bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN] __aligned(2);
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len, ie_len;
 	u8 *ie;
-- 
1.7.3.2

