Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.196]:39865 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750785AbeCXEQs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 00:16:48 -0400
From: Quytelda Kahja <quytelda@tamalin.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quytelda Kahja <quytelda@tamalin.org>
Subject: [PATCH 2/3] ieee80211: Replace bit shifts with the BIT() macro for measurement masks.
Date: Fri, 23 Mar 2018 21:10:26 -0700
Message-Id: <20180324041027.6498-2-quytelda@tamalin.org> (sfid-20180324_051658_374010_9C76995D)
In-Reply-To: <20180324041027.6498-1-quytelda@tamalin.org>
References: <20180324041027.6498-1-quytelda@tamalin.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is neater and more consistent with the rest of the document to use the
BIT() macro from 'linux/bitops.h' to define the
IEEE80211_SPCT_MSR_RPRT_MODE_* bitmasks.

Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
---
 include/linux/ieee80211.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 58069176b432..dc361ed2fb7e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1632,9 +1632,9 @@ struct ieee80211_vht_operation {
 #define WLAN_CAPABILITY_DMG_RADIO_MEASURE	BIT(12)
 
 /* measurement */
-#define IEEE80211_SPCT_MSR_RPRT_MODE_LATE	(1<<0)
-#define IEEE80211_SPCT_MSR_RPRT_MODE_INCAPABLE	(1<<1)
-#define IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED	(1<<2)
+#define IEEE80211_SPCT_MSR_RPRT_MODE_LATE	BIT(0)
+#define IEEE80211_SPCT_MSR_RPRT_MODE_INCAPABLE	BIT(1)
+#define IEEE80211_SPCT_MSR_RPRT_MODE_REFUSED	BIT(2)
 
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_BASIC	0
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_CCA	1
-- 
2.16.2
