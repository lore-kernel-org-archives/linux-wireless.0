Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-da01.nokia.com ([147.243.128.24]:26086 "EHLO
	mgw-da01.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0KAMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Nov 2010 08:25:59 -0400
Received: from localhost.localdomain (chilepepper.research.nokia.com [172.21.50.167])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oA1BqGcL020116
	for <linux-wireless@vger.kernel.org>; Mon, 1 Nov 2010 13:52:25 +0200
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC 09/15] cfg80211: add channel support to periodic scan
Date: Mon,  1 Nov 2010 13:52:10 +0200
Message-Id: <1288612336-2830-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
References: <1288612336-2830-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just add channels in the periodic_request structure.  This is needed in order
to pass the desired channels to scan on down to the mac.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 include/net/cfg80211.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 41e7dc4..218e59f 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -721,13 +721,20 @@ struct cfg80211_scan_request {
 /**
  * struct cfg80211_periodic_request - periodic scan request description
  *
+ * @n_channels: total number of channels to scan
  * @wiphy: the wiphy this was for
  * @dev: the interface
+ * @channels: channels to scan
  */
 struct cfg80211_periodic_request {
+	u32 n_channels;
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
+
+	/* keep last */
+	struct ieee80211_channel *channels[0];
 };
 
 /**
-- 
1.7.0.4

