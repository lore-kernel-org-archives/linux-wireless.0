Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:23309 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754278Ab3J0Pzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Oct 2013 11:55:36 -0400
From: Vladimir Kondratiev <qca_vkondrat@qti.qualcomm.com>
Cc: Vladimir Kondratiev <qca_vkondrat@qti.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH] nl80211: introduce NL80211_SCAN_FLAG_DISCOVERY_MODE
Date: Sun, 27 Oct 2013 17:54:41 +0200
Message-ID: <1382889282-12880-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20131027_165540_326592_28499FB3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

for the DMG (60GHz) networks, there is new scan parameter added in the 802.11 spec -
DiscoveryMode.  This parameter defines whether station performing active scan shall
generate special form of DMG beacons. In particular, this flag used in the P2P
discovery.

Introduce flag to support this feature.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/uapi/linux/nl80211.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index fde2c02..469ed2b 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3808,11 +3808,18 @@ enum nl80211_connect_failed_reason {
  *	dangerous because will destroy stations performance as a lot of frames
  *	will be lost while scanning off-channel, therefore it must be used only
  *	when really needed
+ * @NL80211_SCAN_FLAG_DISCOVERY_MODE: scan to use discovery mode, as in
+ *	802.11 spec for DMG (60GHz) networks in clause:
+ *	10.1.3.4 DMG Beacon generation before network initialization
+ *	If set, station should transmit special form of DMG beacons when
+ *	performing active scan. In 60GHz networks, this feature used
+ *	in the P2P discovery procedure.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
+	NL80211_SCAN_FLAG_DISCOVERY_MODE		= 1<<3,
 };
 
 /**
-- 
1.8.3.2

