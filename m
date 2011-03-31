Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:34203 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933024Ab1CaA5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 20:57:24 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] ieee80211: add HT extended capabilities masks
Date: Wed, 30 Mar 2011 18:01:15 -0700
Message-Id: <1301533275-10681-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

IEEE Std 802.11n, Oct. 29, 2009:
7.3.2.56.5 HT Extended Capabilities field

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 include/linux/ieee80211.h |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 2d1c611..79690b7 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -884,6 +884,15 @@ struct ieee80211_ht_cap {
 #define IEEE80211_HT_CAP_40MHZ_INTOLERANT	0x4000
 #define IEEE80211_HT_CAP_LSIG_TXOP_PROT		0x8000
 
+/* 802.11n HT extended capabilities masks (for extended_ht_cap_info) */
+#define IEEE80211_HT_EXT_CAP_PCO		0x0001
+#define IEEE80211_HT_EXT_CAP_PCO_TIME		0x0006
+#define		IEEE80211_HT_EXT_CAP_PCO_TIME_SHIFT	1
+#define IEEE80211_HT_EXT_CAP_MCS_FB		0x0300
+#define		IEEE80211_HT_EXT_CAP_MCS_FB_SHIFT	8
+#define IEEE80211_HT_EXT_CAP_HTC_SUP		0x0400
+#define IEEE80211_HT_EXT_CAP_RD_RESPONDER	0x0800
+
 /* 802.11n HT capability AMPDU settings (for ampdu_params_info) */
 #define IEEE80211_HT_AMPDU_PARM_FACTOR		0x03
 #define IEEE80211_HT_AMPDU_PARM_DENSITY		0x1C
-- 
1.7.0.2

