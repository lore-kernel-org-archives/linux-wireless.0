Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:55152 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083AbYHSHzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2008 03:55:25 -0400
Date: Tue, 19 Aug 2008 10:54:32 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: Use IWEVASSOCREQIE instead of IWEVCUSTOM
Message-ID: <20080819075431.GA4805@jm.kir.nu> (sfid-20080819_095529_999484_8A58C7F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The previous code was using IWEVCUSTOM to report IEs from AssocReq and
AssocResp frames into user space. This can easily hit the 256 byte
limit (IW_CUSTOM_MAX) with APs that include number of vendor IEs in
AssocResp. This results in the event message not being sent and dmesg
showing "wlan0 (WE) : Wireless Event too big (366)" type of errors.

Convert mac80211 to use IWEVASSOCREQIE/IWEVASSOCRESPIE to avoid the
issue of being unable to send association IEs as wireless events. These
newer event types use binary encoding and larger maximum size
(IW_GENERIC_IE_MAX = 1024), so the likelyhood of not being able to send
the IEs is much smaller than with IWEVCUSTOM. As an extra benefit, the
code is also quite a bit simpler since there is no need to allocate an
extra buffer for hex encoding.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/net/mac80211/mlme.c
===================================================================
--- wireless-testing.orig/net/mac80211/mlme.c
+++ wireless-testing/net/mac80211/mlme.c
@@ -501,51 +501,21 @@ int ieee80211_ht_addt_info_ie_to_ht_bss_
 static void ieee80211_sta_send_associnfo(struct net_device *dev,
 					 struct ieee80211_if_sta *ifsta)
 {
-	char *buf;
-	size_t len;
-	int i;
 	union iwreq_data wrqu;
 
-	if (!ifsta->assocreq_ies && !ifsta->assocresp_ies)
-		return;
-
-	buf = kmalloc(50 + 2 * (ifsta->assocreq_ies_len +
-				ifsta->assocresp_ies_len), GFP_KERNEL);
-	if (!buf)
-		return;
-
-	len = sprintf(buf, "ASSOCINFO(");
 	if (ifsta->assocreq_ies) {
-		len += sprintf(buf + len, "ReqIEs=");
-		for (i = 0; i < ifsta->assocreq_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocreq_ies[i]);
-		}
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = ifsta->assocreq_ies_len;
+		wireless_send_event(dev, IWEVASSOCREQIE, &wrqu,
+				    ifsta->assocreq_ies);
 	}
+
 	if (ifsta->assocresp_ies) {
-		if (ifsta->assocreq_ies)
-			len += sprintf(buf + len, " ");
-		len += sprintf(buf + len, "RespIEs=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
-		}
-	}
-	len += sprintf(buf + len, ")");
-
-	if (len > IW_CUSTOM_MAX) {
-		len = sprintf(buf, "ASSOCRESPIE=");
-		for (i = 0; i < ifsta->assocresp_ies_len; i++) {
-			len += sprintf(buf + len, "%02x",
-				       ifsta->assocresp_ies[i]);
-		}
+		memset(&wrqu, 0, sizeof(wrqu));
+		wrqu.data.length = ifsta->assocresp_ies_len;
+		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu,
+				    ifsta->assocresp_ies);
 	}
-
-	memset(&wrqu, 0, sizeof(wrqu));
-	wrqu.data.length = len;
-	wireless_send_event(dev, IWEVCUSTOM, &wrqu, buf);
-
-	kfree(buf);
 }
 
 

-- 
Jouni Malinen                                            PGP id EFC895FA
