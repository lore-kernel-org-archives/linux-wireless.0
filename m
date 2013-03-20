Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:37301 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756079Ab3CTTN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 15:13:26 -0400
Received: by mail-ie0-f180.google.com with SMTP id a11so2285164iee.25
        for <linux-wireless@vger.kernel.org>; Wed, 20 Mar 2013 12:13:26 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 20:13:26 +0100
Message-ID: <CAFED-jmrmbMb=puPn1Nu6zc2SnZvJNWFnwV4CHNNjo7E_yKr1g@mail.gmail.com> (sfid-20130320_201330_576750_EC999E13)
Subject: [PATCH 1/4] cfg80211: add P2P Notice of Absence attribute
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add P2P Notice of Absence attribute structure.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/linux/ieee80211.h |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4cf0c9e..9dc9e1c 100644
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
+	u8	count;
+	__le32	duration;
+	__le32	interval;
+	__le32	start_time;
+} __packed;
+
+struct ieee80211_p2p_noa_attr {
+	u8	index;
+	u8	oppps_ctwindow;
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
