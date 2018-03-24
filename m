Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.197]:40121 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750743AbeCXEQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Mar 2018 00:16:47 -0400
From: Quytelda Kahja <quytelda@tamalin.org>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Quytelda Kahja <quytelda@tamalin.org>
Subject: [PATCH 3/3] ieee80211: Replace bit shifts with the BIT() macro for 802.11g ERP IEs.
Date: Fri, 23 Mar 2018 21:10:27 -0700
Message-Id: <20180324041027.6498-3-quytelda@tamalin.org> (sfid-20180324_051656_740036_71A0B778)
In-Reply-To: <20180324041027.6498-1-quytelda@tamalin.org>
References: <20180324041027.6498-1-quytelda@tamalin.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is neater and more consistent with the rest of the document to use the
BIT() macro from 'linux/bitops.h' to define the WLAN_ERP_* bitmasks.

Signed-off-by: Quytelda Kahja <quytelda@tamalin.org>
---
 include/linux/ieee80211.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index dc361ed2fb7e..bc68d542f082 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1641,9 +1641,9 @@ struct ieee80211_vht_operation {
 #define IEEE80211_SPCT_MSR_RPRT_TYPE_RPI	2
 
 /* 802.11g ERP information element */
-#define WLAN_ERP_NON_ERP_PRESENT (1<<0)
-#define WLAN_ERP_USE_PROTECTION (1<<1)
-#define WLAN_ERP_BARKER_PREAMBLE (1<<2)
+#define WLAN_ERP_NON_ERP_PRESENT BIT(0)
+#define WLAN_ERP_USE_PROTECTION  BIT(1)
+#define WLAN_ERP_BARKER_PREAMBLE BIT(2)
 
 /* WLAN_ERP_BARKER_PREAMBLE values */
 enum {
-- 
2.16.2
