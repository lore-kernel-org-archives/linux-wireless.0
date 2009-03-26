Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbZCZRwE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:52:04 -0400
Subject: [PATCH v2] mac80211: include HT capabilities in probe request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1238088685.4331.72.camel@johannes.local> (sfid-20090326_183202_056572_CFB0861F)
References: <1238088685.4331.72.camel@johannes.local>
	 (sfid-20090326_183202_056572_CFB0861F)
Content-Type: text/plain
Date: Thu, 26 Mar 2009 18:51:27 +0100
Message-Id: <1238089887.4331.78.camel@johannes.local> (sfid-20090326_185209_182164_232771CD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the HT capabilities in the probe request frame.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
v2: fix the HT IE

 net/mac80211/ieee80211_i.h |    3 ++-
 net/mac80211/util.c        |   16 ++++++++++++++++
 2 files changed, 18 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-26 18:21:59.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-26 18:28:44.000000000 +0100
@@ -53,7 +53,8 @@ struct ieee80211_local;
 
 /* cfg80211 only supports 32 rates */
 #define MAC80211_PREQ_IE_LEN	( 2 + 32 /* SSID */\
-				+ 4 + 32 /* (ext) supp rates */)
+				+ 4 + 32 /* (ext) supp rates */\
+				+ sizeof(struct ieee80211_ht_cap))
 
 /*
  * Time after which we ignore scan results and no longer report/use
--- wireless-testing.orig/net/mac80211/util.c	2009-03-26 18:21:59.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-03-26 18:46:22.000000000 +0100
@@ -862,6 +862,22 @@ int ieee80211_build_preq_ies(struct ieee
 		*pos++ = rate->bitrate / 5;
 	}
 
+	if (sband->ht_cap.ht_supported) {
+		__le16 tmp = cpu_to_le16(sband->ht_cap.cap);
+
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		memset(pos, 0, sizeof(struct ieee80211_ht_cap));
+		memcpy(pos, &tmp, sizeof(u16));
+		pos += sizeof(u16);
+		/* TODO: needs a define here for << 2 */
+		*pos++ = sband->ht_cap.ampdu_factor |
+			 (sband->ht_cap.ampdu_density << 2);
+		memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
+		pos += sizeof(sband->ht_cap.mcs);
+		pos += 2 + 4 + 1; /* ext info, BF cap, antsel */
+	}
+
 	/* if adding more here, adjust MAC80211_PREQ_IE_LEN */
 
 	if (ie) {


