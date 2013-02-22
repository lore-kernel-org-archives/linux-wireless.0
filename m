Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53083 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516Ab3BVQ2v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 11:28:51 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] ieee80211: mark 802.11 related structs as being 2-byte aligned
Date: Fri, 22 Feb 2013 17:28:49 +0100
Message-Id: <1361550529-96159-1-git-send-email-nbd@openwrt.org> (sfid-20130222_172855_596053_A53BDE53)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Regardless of what header features they use, or if they align the IP
header or not, 802.11 packets from all drivers guarantee a 2-byte
alignment (and there's a debug WARN_ON in case they don't).

Annotate packet structs with __aligned(2) to allow the compiler to use
16-bit load/store operations on platforms with extremely inefficient
unaligned access (e.g. MIPS).

This reduces code size and improves performance on affected platforms
and causes no binary code change on others.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 include/linux/ieee80211.h | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7e24fe0..bbccc2e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -185,7 +185,7 @@ struct ieee80211_hdr {
 	u8 addr3[6];
 	__le16 seq_ctrl;
 	u8 addr4[6];
-} __packed;
+} __packed __aligned(2);
 
 struct ieee80211_hdr_3addr {
 	__le16 frame_control;
@@ -194,7 +194,7 @@ struct ieee80211_hdr_3addr {
 	u8 addr2[6];
 	u8 addr3[6];
 	__le16 seq_ctrl;
-} __packed;
+} __packed __aligned(2);
 
 struct ieee80211_qos_hdr {
 	__le16 frame_control;
@@ -204,7 +204,7 @@ struct ieee80211_qos_hdr {
 	u8 addr3[6];
 	__le16 seq_ctrl;
 	__le16 qos_ctrl;
-} __packed;
+} __packed __aligned(2);
 
 /**
  * ieee80211_has_tods - check if IEEE80211_FCTL_TODS is set
@@ -581,7 +581,7 @@ struct ieee80211s_hdr {
 	__le32 seqnum;
 	u8 eaddr1[6];
 	u8 eaddr2[6];
-} __packed;
+} __packed __aligned(2);
 
 /* Mesh flags */
 #define MESH_FLAGS_AE_A4 	0x1
@@ -875,7 +875,7 @@ struct ieee80211_mgmt {
 			} u;
 		} __packed action;
 	} u;
-} __packed;
+} __packed __aligned(2);
 
 /* Supported Rates value encodings in 802.11n-2009 7.3.2.2 */
 #define BSS_MEMBERSHIP_SELECTOR_HT_PHY	127
@@ -906,20 +906,20 @@ struct ieee80211_rts {
 	__le16 duration;
 	u8 ra[6];
 	u8 ta[6];
-} __packed;
+} __packed __aligned(2);
 
 struct ieee80211_cts {
 	__le16 frame_control;
 	__le16 duration;
 	u8 ra[6];
-} __packed;
+} __packed __aligned(2);
 
 struct ieee80211_pspoll {
 	__le16 frame_control;
 	__le16 aid;
 	u8 bssid[6];
 	u8 ta[6];
-} __packed;
+} __packed __aligned(2);
 
 /* TDLS */
 
-- 
1.8.0.2

