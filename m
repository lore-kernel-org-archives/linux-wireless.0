Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51749 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3CUOsL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Mar 2013 10:48:11 -0400
Received: by mail-ea0-f175.google.com with SMTP id o10so913772eaj.20
        for <linux-wireless@vger.kernel.org>; Thu, 21 Mar 2013 07:48:10 -0700 (PDT)
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	Janusz Dziedzic <janusz.dziedzic@gmail.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH v2 1/4] cfg80211: add P2P Notice of Absence attribute
Date: Thu, 21 Mar 2013 15:47:54 +0100
Message-Id: <1363877277-5108-1-git-send-email-janusz.dziedzic@gmail.com> (sfid-20130321_154842_568240_37057BAC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add P2P Notice of Absence attribute structure.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/linux/ieee80211.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4cf0c9e..d10b5bb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1027,6 +1027,26 @@ enum ieee80211_p2p_attr_id {
 	IEEE80211_P2P_ATTR_MAX
 };
 
+/* Notice of Absence attribute - described in P2P spec 4.1.14 */
+/* Typical max value used here */
+#define IEEE80211_P2P_NOA_DESC_MAX	4
+
+struct ieee80211_p2p_noa_desc {
+	u8 count;
+	__le32 duration;
+	__le32 interval;
+	__le32 start_time;
+} __packed;
+
+struct ieee80211_p2p_noa_attr {
+	u8 index;
+	u8 oppps_ctwindow;
+	struct ieee80211_p2p_noa_desc desc[IEEE80211_P2P_NOA_DESC_MAX];
+} __packed;
+
+#define IEEE80211_P2P_OPPPS_ENABLE_BIT		BIT(7)
+#define IEEE80211_P2P_OPPPS_CTWINDOW_MASK	0x7F
+
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *
-- 
1.7.9.5

