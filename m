Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:38038 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237AbZESOCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:43 -0400
Message-Id: <20090519140236.866613677@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:43 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 6/7] mac80211: PS processing for every Beacon with our AID in TIM
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the AP includes our AID in the TIM IE, we need to process the
Beacon frame as far as PS is concerned (send PS-Poll or nullfunc data
with PM=0). The previous code skipped this in cases where the CRC
value did not change and it would not change if the AP continues
including our AID in the TIM..

There is no need to count the crc32 value for directed_tim with this
change, so we can remove that part. In order not to change the order
of operations (i.e., update WMM parameters prior to sending PS-Poll),
the CRC match is checked twice as only after the PS processing step,
the rest of the function is skipped if nothing changed in the Beacon.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 net/mac80211/mlme.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-19 16:32:25.000000000 +0300
+++ wireless-testing/net/mac80211/mlme.c	2009-05-19 16:32:39.000000000 +0300
@@ -1958,16 +1958,13 @@ static void ieee80211_rx_mgmt_beacon(str
 		directed_tim = ieee80211_check_tim(elems.tim, elems.tim_len,
 						   ifmgd->aid);
 
-	ncrc = crc32_be(ncrc, (void *)&directed_tim, sizeof(directed_tim));
+	if (ncrc != ifmgd->beacon_crc) {
+		ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems,
+				      true);
 
-	if (ncrc == ifmgd->beacon_crc)
-		return;
-	ifmgd->beacon_crc = ncrc;
-
-	ieee80211_rx_bss_info(sdata, mgmt, len, rx_status, &elems, true);
-
-	ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
-				 elems.wmm_param_len);
+		ieee80211_sta_wmm_params(local, ifmgd, elems.wmm_param,
+					 elems.wmm_param_len);
+	}
 
 	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) {
 		if (directed_tim) {
@@ -1992,6 +1989,10 @@ static void ieee80211_rx_mgmt_beacon(str
 		}
 	}
 
+	if (ncrc == ifmgd->beacon_crc)
+		return;
+	ifmgd->beacon_crc = ncrc;
+
 	if (elems.erp_info && elems.erp_info_len >= 1) {
 		erp_valid = true;
 		erp_value = elems.erp_info[0];

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
