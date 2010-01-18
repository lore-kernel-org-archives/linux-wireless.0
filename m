Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:41396 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab0AROZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 09:25:52 -0500
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hahn280171sc for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 19:29:09 +0530 (envelope-from <Andriy.Tkachuk2@globallogic.com>)
Message-ID: <4B546A68.5050503@globallogic.com>
Date: Mon, 18 Jan 2010 16:04:24 +0200
From: Andriy Tkachuk <andriy.v.tkachuk@globallogic.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: Account HT Control field also in Data frame hdrlen according to 802.11n-2009
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 8427019..1998495 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -138,6 +138,8 @@
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK   0x03
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT  5

+#define IEEE80211_HT_CTL_LEN           4
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
-               if (ieee80211_is_data_qos(fc))
+               if (ieee80211_is_data_qos(fc)) {
                        hdrlen += IEEE80211_QOS_CTL_LEN;
+                       if (ieee80211_has_order(fc))
+                               hdrlen += IEEE80211_HT_CTL_LEN;
+               }
                goto out;
        }



