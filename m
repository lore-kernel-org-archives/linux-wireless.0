Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:30909 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756938AbaCSLOz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 07:14:55 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"John W . Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH] wireless: max MSDU size for DMG networks
Date: Wed, 19 Mar 2014 13:14:40 +0200
Message-ID: <1395227680-30007-1-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140319_121522_735482_2B463D0F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the 802.11ad, aka DMG (Dynamic Multi-Gigabit), aka 60Ghz
spec, maximum MSDU size extended to 7920 bytes.
add #define for this.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/linux/ieee80211.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 0629904..f194ccb 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -154,6 +154,10 @@ static inline u16 ieee80211_sn_sub(u16 sn1, u16 sn2)
    802.11e clarifies the figure in section 7.1.2. The frame body is
    up to 2304 octets long (maximum MSDU size) plus any crypt overhead. */
 #define IEEE80211_MAX_DATA_LEN		2304
+/* 802.11ad extends maximum MSDU size for DMG (freq > 40Ghz) networks
+ * to 7920 bytes, see 8.2.3 General frame format
+ */
+#define IEEE80211_MAX_DATA_LEN_DMG	7920
 /* 30 byte 4 addr hdr, 2 byte QoS, 2304 byte MSDU, 12 byte crypt, 4 byte FCS */
 #define IEEE80211_MAX_FRAME_LEN		2352
 
-- 
1.8.3.2

