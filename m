Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:35485 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab3BPDQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 22:16:07 -0500
Date: Sat, 16 Feb 2013 06:43:16 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@lists.open80211s.org
Subject: improve operational ANI in Mesh mode
Message-ID: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> (sfid-20130216_041619_900205_57BFAB7C)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-821458972-1360982596=:4293"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-821458972-1360982596=:4293
Content-Type: TEXT/PLAIN; format=flowed; charset=KOI8-R
Content-Transfer-Encoding: 8BIT


Hi, in our setups we experience pure ANI operational in mesh mode
VS AP mode, after debuffing and digging in ANI code i find what ANI
in AP mode work in limited mode, i try this mode with mesh and seems
getting same good operation as in AP mode, i am not familiar with ANI
may be there is another better way to fix this issue?

changes what i made:

diff -ruN compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c
--- compat-drivers-3.7.6-1/drivers/net/wireless/ath/ath9k/ani.c	2013-02-11 04:23:53.000000000 +0400
+++ compat-drivers-3.7.6-1-new/drivers/net/wireless/ath/ath9k/ani.c	2013-02-16 05:03:46.640746411 +0400
@@ -303,7 +303,8 @@
  	ah->stats.ast_ani_reset++;

  	/* only allow a subset of functions in AP mode */
-	if (ah->opmode == NL80211_IFTYPE_AP) {
+	if (ah->opmode == NL80211_IFTYPE_AP || ah->opmode == NL80211_IFTYPE_MESH_POINT) {
+		ath_dbg(common, ANI, "only allow a subset of functions in AP or MESH mode");
  		if (IS_CHAN_2GHZ(chan)) {
  			ah->ani_function = (ATH9K_ANI_SPUR_IMMUNITY_LEVEL |
  					    ATH9K_ANI_FIRSTEP_LEVEL);
@@ -323,7 +324,8 @@

  	if (is_scanning ||
  	    (ah->opmode != NL80211_IFTYPE_STATION &&
-	     ah->opmode != NL80211_IFTYPE_ADHOC)) {
+	     ah->opmode != NL80211_IFTYPE_ADHOC && 
+	     ah->opmode != NL80211_IFTYPE_MESH_POINT)) {
  		/*
  		 * If we're scanning or in AP mode, the defaults (ini)
  		 * should be in place. For an AP we assume the historical



C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-821458972-1360982596=:4293--
