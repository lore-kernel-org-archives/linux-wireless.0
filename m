Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:44052 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757170AbXD0T7N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 15:59:13 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: [PATCH] mac80211: don't export linux/ieee80211.h
Date: Fri, 27 Apr 2007 15:54:55 -0400
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200704271554.55770.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

The definitions in linux/ieee80211.h don't need to be exported.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 include/linux/Kbuild      |    1 -
 include/linux/ieee80211.h |   56 +++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 2781d33..7a1bb18 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -70,7 +70,6 @@ header-y += hysdn_if.h
 header-y += i2c-dev.h
 header-y += i8k.h
 header-y += icmp.h
-header-y += ieee80211.h
 header-y += if_arcnet.h
 header-y += if_arp.h
 header-y += if_bonding.h
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ae19306..ecd61e8 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -98,20 +98,20 @@
 struct ieee80211_hdr {
 	__le16 frame_control;
 	__le16 duration_id;
-	__u8 addr1[6];
-	__u8 addr2[6];
-	__u8 addr3[6];
+	u8 addr1[6];
+	u8 addr2[6];
+	u8 addr3[6];
 	__le16 seq_ctrl;
-	__u8 addr4[6];
+	u8 addr4[6];
 } __attribute__ ((packed));
 
 
 struct ieee80211_mgmt {
 	__le16 frame_control;
 	__le16 duration;
-	__u8 da[6];
-	__u8 sa[6];
-	__u8 bssid[6];
+	u8 da[6];
+	u8 sa[6];
+	u8 bssid[6];
 	__le16 seq_ctrl;
 	union {
 		struct {
@@ -119,7 +119,7 @@ struct ieee80211_mgmt {
 			__le16 auth_transaction;
 			__le16 status_code;
 			/* possibly followed by Challenge text */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) auth;
 		struct {
 			__le16 reason_code;
@@ -135,14 +135,14 @@ struct ieee80211_mgmt {
 			__le16 status_code;
 			__le16 aid;
 			/* followed by Supported rates */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) assoc_resp, reassoc_resp;
 		struct {
 			__le16 capab_info;
 			__le16 listen_interval;
-			__u8 current_ap[6];
+			u8 current_ap[6];
 			/* followed by SSID and Supported rates */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) reassoc_req;
 		struct {
 			__le16 reason_code;
@@ -153,11 +153,11 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params, TIM */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) beacon;
 		struct {
 			/* only variable items: SSID, Supported rates */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) probe_req;
 		struct {
 			__le64 timestamp;
@@ -165,24 +165,24 @@ struct ieee80211_mgmt {
 			__le16 capab_info;
 			/* followed by some of SSID, Supported rates,
 			 * FH Params, DS Params, CF Params, IBSS Params */
-			__u8 variable[0];
+			u8 variable[0];
 		} __attribute__ ((packed)) probe_resp;
 		struct {
-			__u8 category;
+			u8 category;
 			union {
 				struct {
-					__u8 action_code;
-					__u8 dialog_token;
-					__u8 status_code;
-					__u8 variable[0];
+					u8 action_code;
+					u8 dialog_token;
+					u8 status_code;
+					u8 variable[0];
 				} __attribute__ ((packed)) wme_action;
 				struct{
-					__u8 action_code;
-					__u8 element_id;
-					__u8 length;
-					__u8 switch_mode;
-					__u8 new_chan;
-					__u8 switch_count;
+					u8 action_code;
+					u8 element_id;
+					u8 length;
+					u8 switch_mode;
+					u8 new_chan;
+					u8 switch_count;
 				} __attribute__((packed)) chan_switch;
 			} u;
 		} __attribute__ ((packed)) action;
@@ -194,14 +194,14 @@ struct ieee80211_mgmt {
 struct ieee80211_rts {
 	__le16 frame_control;
 	__le16 duration;
-	__u8 ra[6];
-	__u8 ta[6];
+	u8 ra[6];
+	u8 ta[6];
 } __attribute__ ((packed));
 
 struct ieee80211_cts {
 	__le16 frame_control;
 	__le16 duration;
-	__u8 ra[6];
+	u8 ra[6];
 } __attribute__ ((packed));
 
 
