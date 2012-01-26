Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:36869 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2AZMju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:50 -0500
Received: by mail-gy0-f176.google.com with SMTP id g2so205274ghb.21
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:49 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 8/9] mac80211: add DFS capabilities flag
Date: Thu, 26 Jan 2012 14:38:03 +0200
Message-Id: <1327581484-22047-9-git-send-email-victorg@ti.com> (sfid-20120126_133954_523017_60AB8ACA)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new IEEE80211_HW_SUPPORTS_RADAR_DETECTION attribute which
indicates that hw supports radar detection.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h |    3 +++
 net/mac80211/main.c    |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index b0f4e67..90564b4 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1138,6 +1138,8 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_TX_AMPDU_SETUP_IN_HW: The device handles TX A-MPDU session
  *	setup strictly in HW. mac80211 should not attempt to do this in
  *	software.
+ *
+ * @IEEE80211_HW_SUPPORTS_RADAR_DETECTION: Hardware supports radar detection.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
@@ -1164,6 +1166,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_SUPPORTS_PER_STA_GTK		= 1<<21,
 	IEEE80211_HW_AP_LINK_PS				= 1<<22,
 	IEEE80211_HW_TX_AMPDU_SETUP_IN_HW		= 1<<23,
+	IEEE80211_HW_SUPPORTS_RADAR_DETECTION		= 1<<24,
 };
 
 /**
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0a0d94a..4ec847c 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -866,6 +866,9 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	if (local->hw.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS)
 		local->hw.wiphy->flags |= WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
 
+	if (local->hw.flags & IEEE80211_HW_SUPPORTS_RADAR_DETECTION)
+		local->hw.wiphy->flags |= WIPHY_FLAG_SUPPORTS_DFS;
+
 	result = wiphy_register(local->hw.wiphy);
 	if (result < 0)
 		goto fail_wiphy_register;
-- 
1.7.5.4

