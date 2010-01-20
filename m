Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:35030 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab0ATLzW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jan 2010 06:55:22 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id harnik0171sa for <linux-wireless@vger.kernel.org>; Wed, 20 Jan 2010 17:25:18 +0530 (envelope-from <andrit@ukr.net>)
Message-ID: <4B56EF1A.4050503@ukr.net>
Date: Wed, 20 Jan 2010 13:55:06 +0200
From: Andriy Tkachuk <andrit@ukr.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: Account HT Control field in Data frame hdrlen according
 to 802.11n-2009
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_hdrlen() should account account new HT Control field in 802.11
data frame header introduced by IEEE 802.11n standard.

According to 802.11n-2009 HT Control field is present in data frames
when both of following are met:

   1. It is QoS data frame.
   2. Order bit is set in Frame Control field.

The change might be totally compatible with legacy non-11n aware frames,
because 802.11-2007 standard states that "all QoS STAs set this subfield
to 0".

Signed-off-by: Andriy V. Tkachuk <andrit@ukr.net>
Acked-by : Benoit Papillault <benoit.papillault@free.fr>

---
 include/linux/ieee80211.h |    2 ++
 net/wireless/util.c       |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

Prev. patch may be ignored since its format was invalid - it extended
tabs to spaces (copy/paste from PuTTY issue). Hope this one will be
better. Sorry for inconvenience.

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8427019..1998495 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -138,6 +138,8 @@
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5

+#define IEEE80211_HT_CTL_LEN		4
+
 struct ieee80211_hdr {
 	__le16 frame_control;
 	__le16 duration_id;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 23557c1..be2ab8c 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -227,8 +227,11 @@ unsigned int ieee80211_hdrlen(__le16 fc)
 	if (ieee80211_is_data(fc)) {
 		if (ieee80211_has_a4(fc))
 			hdrlen = 30;
-		if (ieee80211_is_data_qos(fc))
+		if (ieee80211_is_data_qos(fc)) {
 			hdrlen += IEEE80211_QOS_CTL_LEN;
+			if (ieee80211_has_order(fc))
+				hdrlen += IEEE80211_HT_CTL_LEN;
+		}
 		goto out;
 	}

