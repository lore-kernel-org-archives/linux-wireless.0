Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42982 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319AbZKMXXO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2009 18:23:14 -0500
Received: by bwz27 with SMTP id 27so4019742bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 13 Nov 2009 15:23:19 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] wireless: add BlockAck frame structure
Date: Sat, 14 Nov 2009 00:23:07 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200911140023.08161.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the BlockAck frame structure as described in
802.11n specification section 7.2.1.8.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
I'm not sure if:
 - everyone will be happy about ext. ieee80211_ba_cb structure?
 - this structure should a part of ieee80211_bar?
---
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 49b1abd..cda0b23 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -747,10 +747,48 @@ struct ieee80211_bar {
 	__le16 start_seq_num;
 } __attribute__((packed));
 
-/* 802.11 BAR control masks */
+/* 802.11 BA(R) control masks */
 #define IEEE80211_BAR_CTRL_ACK_POLICY_NORMAL     0x0000
+#define IEEE80211_BAR_CTRL_MULTI_TID		 0x0002
 #define IEEE80211_BAR_CTRL_CBMTID_COMPRESSED_BA  0x0004
 
+/**
+ * struct ieee80211_ba_cb - Compressed BlockAck variant
+ *
+ * This structure refers to "BA Information field" as
+ * described in 802.11n specification section 7.2.1.8.3
+ */
+struct ieee80211_ba_cb {
+	__le16 start_seq_num;
+	__u8 bitmap[8];
+} __attribute__((packed));
+
+/**
+ * struct ieee80211_ba - BlockAck frame
+ *
+ * This structure refers to "BlockAck frame" as
+ * described in 802.11n specification section 7.2.1.8.1
+ */
+struct ieee80211_ba {
+	__le16 frame_control;
+	__le16 duration;
+	__u8 ra[6];
+	__u8 ta[6];
+	__le16 control;
+	union {
+		struct {
+			__le16 start_seq_num;
+			__u8 bitmap[128];
+		} basic __attribute__((packed));
+
+		struct ieee80211_ba_cb cb;
+
+		struct {
+			__le16 per_tid;
+			struct ieee80211_ba_cb cb;
+		} cbmtid[0] __attribute__((packed));
+	} __attribute__((packed));
+} __attribute__((packed));
 
 #define IEEE80211_HT_MCS_MASK_LEN		10
 
