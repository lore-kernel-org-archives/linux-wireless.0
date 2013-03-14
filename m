Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:63529 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab3CNHdF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Mar 2013 03:33:05 -0400
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>
Date: Thu, 14 Mar 2013 09:32:59 +0200
Subject: [RFC 1/3] cfg80211: add P2P Notice of Absence attribute
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912FA1693F25@EXMB01.eu.tieto.com> (sfid-20130314_083310_868899_805F8803)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add P2P Notice of Absence attribute structure.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 include/linux/ieee80211.h |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 4cf0c9e..2941644 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1027,6 +1027,23 @@ enum ieee80211_p2p_attr_id {
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
 /**
  * struct ieee80211_bar - HT Block Ack Request
  *
-- 
1.7.9.5
