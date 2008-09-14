Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:24196 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755425AbYINPpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Sep 2008 11:45:30 -0400
Received: from gollum.odi.ch ([84.74.148.76]) by viefep27-int.chello.at
          (InterMail vM.7.08.02.02 201-2186-121-104-20070414) with ESMTP
          id <20080914154413.BXMS5786.viefep27-int.chello.at@gollum.odi.ch>
          for <linux-wireless@vger.kernel.org>;
          Sun, 14 Sep 2008 17:44:13 +0200
Received: from [192.168.111.10] (mithril [192.168.111.10])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by gollum.odi.ch (Postfix) with ESMTPSA id 397D6967AB
	for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2008 17:44:12 +0200 (CEST)
Message-ID: <48CD314C.40105@odi.ch> (sfid-20080914_174551_302067_71E225F3)
Date: Sun, 14 Sep 2008 17:44:12 +0200
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: WEP and enc restricted
Content-Type: multipart/mixed;
 boundary="------------030206050106060902030205"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030206050106060902030205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am pretty sure that the mac80211 code doesn't handle WEP with shared keys 
correctly. Using the ath9k driver on my MacBook I am unable to put the driver 
into restricted mode (shared key). It stays in open mode. That is the following 
command has no effect: iwconfig wlan0 enc restricted. I can also confirm this 
when looking at the authentication packets that go over the air: they are sent 
with the open flag, and not the shared key flag.

Surprisingly nowhere in the mac80211 code the ifsta->auth_alg is set to 
WLAN_AUTH_SHARED_KEY so far. The attached small patch does just that. I am not 
100% sure if that's the way to do it, so please review carefully.

With this patch authentication works. The AP now denies association, but that is 
another problem.

Cheers

Ortwin

--------------030206050106060902030205
Content-Type: text/plain;
 name="patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch.diff"

--- wext.c.orig	2008-07-21 22:18:29.000000000 +0200
+++ wext.c	2008-09-14 16:46:09.000000000 +0200
@@ -929,6 +929,14 @@
 	else
 		idx--;
 
+	if (sdata->vif.type == IEEE80211_IF_TYPE_STA) {
+		struct ieee80211_if_sta *ifsta = &sdata->u.sta;
+		if (erq->flags & IW_ENCODE_OPEN)
+			ifsta->auth_alg = WLAN_AUTH_OPEN;
+		else if (erq->flags & IW_ENCODE_RESTRICTED)
+			ifsta->auth_alg = WLAN_AUTH_SHARED_KEY;
+	}
+
 	if (erq->flags & IW_ENCODE_DISABLED)
 		remove = 1;
 	else if (erq->length == 0) {

--------------030206050106060902030205--
