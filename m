Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:19708 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065AbZIWHIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 03:08:16 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Comparison of wpa_supplicant with -Dnl80211 and -Dwext, WEP and WPA
Date: Wed, 23 Sep 2009 09:07:24 +0200
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
References: <200909221118.04569.hs4233@mail.mn-solutions.de> <1253689198.4458.24.camel@johannes.local>
In-Reply-To: <1253689198.4458.24.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909230907.24750.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Those are expected, and ok.

Okay, then here is a patch to silence this in wpa_supplicant.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wpasupplicant/src/drivers/driver_nl80211.c
===================================================================
--- wpasupplicant.orig/src/drivers/driver_nl80211.c	2009-09-22 12:28:58.000000000 +0200
+++ wpasupplicant/src/drivers/driver_nl80211.c	2009-09-22 12:30:29.000000000 +0200
@@ -1819,6 +1819,8 @@ static int nl_set_encr(int ifindex, stru
 	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, ifindex);
 
 	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
+	if (ret == -ENOLINK)
+		ret = 0;
 	if (ret == -ENOENT && alg == WPA_ALG_NONE)
 		ret = 0;
 	if (ret)
@@ -1850,7 +1852,7 @@ static int nl_set_encr(int ifindex, stru
 		NLA_PUT_FLAG(msg, NL80211_ATTR_KEY_DEFAULT);
 
 	ret = send_and_recv_msgs(drv, msg, NULL, NULL);
-	if (ret == -ENOENT)
+	if (ret == -ENOENT || ret == -ENOLINK)
 		ret = 0;
 	if (ret)
 		wpa_printf(MSG_DEBUG, "nl80211: set_key default failed; "



-- 
http://www.holgerschurig.de
