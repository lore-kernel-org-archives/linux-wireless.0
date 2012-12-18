Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:28847 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2LRIBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 03:01:11 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W . Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] wireless: more 'capability info' bits
Date: Tue, 18 Dec 2012 10:01:06 +0200
Message-ID: <1439651.zKbLy76ZDy@lx-vladimir> (sfid-20121218_090115_533597_6222FA18)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 5b9cd73d0df1733b33b7fbb6ae5682c8c8716602 Mon Sep 17 00:00:00 2001
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Date: Tue, 18 Dec 2012 09:55:33 +0200
Subject: [PATCH] wireless: more 'capability info' bits

define bits for 'capability info', as in recent spec edition
IEEE802.11-2012

Also, add mask for 2-bit field 'bss type', as it is in 802.11ad

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/linux/ieee80211.h |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index f0859cc..09879eb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1311,16 +1311,21 @@ struct ieee80211_vht_operation {
 #define WLAN_CAPABILITY_SPECTRUM_MGMT	(1<<8)
 #define WLAN_CAPABILITY_QOS		(1<<9)
 #define WLAN_CAPABILITY_SHORT_SLOT_TIME	(1<<10)
+#define WLAN_CAPABILITY_APSD		(1<<11)
+#define WLAN_CAPABILITY_RADIO_MEASURE	(1<<12)
 #define WLAN_CAPABILITY_DSSS_OFDM	(1<<13)
+#define WLAN_CAPABILITY_DEL_BACK	(1<<14)
+#define WLAN_CAPABILITY_IMM_BACK	(1<<15)
 
 /* DMG (60gHz) 802.11ad */
 /* type - bits 0..1 */
+#define WLAN_CAPABILITY_DMG_TYPE_MASK		(3<<0)
 #define WLAN_CAPABILITY_DMG_TYPE_IBSS		(1<<0) /* Tx by: STA */
 #define WLAN_CAPABILITY_DMG_TYPE_PBSS		(2<<0) /* Tx by: PCP */
 #define WLAN_CAPABILITY_DMG_TYPE_AP		(3<<0) /* Tx by: AP */
 
 #define WLAN_CAPABILITY_DMG_CBAP_ONLY		(1<<2)
-#define WLAN_CAPABILITY_DMG_CBAP_SOURCE	(1<<3)
+#define WLAN_CAPABILITY_DMG_CBAP_SOURCE		(1<<3)
 #define WLAN_CAPABILITY_DMG_PRIVACY		(1<<4)
 #define WLAN_CAPABILITY_DMG_ECPAC		(1<<5)
 
-- 
1.7.10.4


