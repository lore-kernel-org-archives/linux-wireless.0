Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:34940 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1K3P4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 10:56:36 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	stable@vger.kernel.org
Subject: [PATCH] mac80211: fill rate filter for internal scan requests
Date: Wed, 30 Nov 2011 16:56:30 +0100
Message-Id: <1322668590-18801-1-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111130_165639_737073_FA7F2A85)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The rates bitmap for internal scan requests shoud be filled,
otherwise there will be probe requests with zero rates supported.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 net/mac80211/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index dddedfa..3e15f75 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -779,6 +779,12 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (!local->int_scan_req)
 		return -ENOMEM;
 
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (!local->hw.wiphy->bands[band])
+			continue;
+		local->int_scan_req->rates[band] = (u32) -1;
+	}
+
 	/* if low-level driver supports AP, we also support VLAN */
 	if (local->hw.wiphy->interface_modes & BIT(NL80211_IFTYPE_AP)) {
 		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
-- 
1.7.7.3

