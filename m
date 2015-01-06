Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45650 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148AbbAFMWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 07:22:37 -0500
Received: by mail-wi0-f178.google.com with SMTP id em10so5207464wid.5
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2015 04:22:36 -0800 (PST)
Message-ID: <54ABD389.8030409@gmail.com> (sfid-20150106_132240_882508_B9685B2C)
Date: Tue, 06 Jan 2015 13:22:33 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: linville@tuxdriver.com
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH} mac80211: correction of IFTYPE_AP and IFTYPE_AP_VLAN in ieee80211_do_stop
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While doing a code review, I noticed that in the latest stable version 
of the kernel (3.18.1) the functionality of IFTYPE_AP and IFTYPE_AP_VLAN 
is switched in ieee80211_do_stop. In the case of IEEE80211_IFTYPE_AP, 
the list of devices in sdata->u.ap.vlans are closed, while in the case 
of IEEE80211_IFTYPE_AP_VLAN the skbs in sdata->bss->ps->bc_buf are 
freed. I believe this should be the other way around.

I found that the error already existed since 3.9.13, but was not yet 
present in 3.2. I didn't check any versions between those.

The following patch corrects the above stated error. This correction has 
not been tested, it was discovered during a code review.

Signed-off-by: Wim Torfs wtorfs@gmail.com

---

diff -uprN linux-3.18.1.orig/net/mac80211/iface.c 
linux-3.18.1.patched/net/mac80211/iface.c
--- linux-3.18.1.orig/net/mac80211/iface.c	2014-12-16 18:39:45.000000000 
+0100
+++ linux-3.18.1.patched/net/mac80211/iface.c	2015-01-06 
12:49:50.000000000 +0100
@@ -868,7 +868,7 @@ static void ieee80211_do_stop(struct iee
  	}

  	/* APs need special treatment */
-	if (sdata->vif.type == NL80211_IFTYPE_AP) {
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
  		struct ieee80211_sub_if_data *vlan, *tmpsdata;

  		/* down all dependent devices, that is VLANs */
@@ -876,7 +876,7 @@ static void ieee80211_do_stop(struct iee
  					 u.vlan.list)
  			dev_close(vlan->dev);
  		WARN_ON(!list_empty(&sdata->u.ap.vlans));
-	} else if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
+	} else if (sdata->vif.type == NL80211_IFTYPE_AP) {
  		/* remove all packets in parent bc_buf pointing to this dev */
  		ps = &sdata->bss->ps;

