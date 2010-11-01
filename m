Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26081 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcQ020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:30 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 14/15] cfg80211: add ie support for periodic scans
Date: Mon,  1 Nov 2010 13:52:15 +0200
Message-Id: <1288612336-2830-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add an array of pointers to ie (one element for each band) and the respective
array of ie lengths.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3ac6fc9..fdc6b31 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -732,6 +732,8 @@ struct cfg80211_periodic_request {
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
+	const u8 *ie[IEEE80211_NUM_BANDS];
+	size_t ie_len[IEEE80211_NUM_BANDS];
 
 	/* internal */
 	struct wiphy *wiphy;
-- 
1.7.0.4

