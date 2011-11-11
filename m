Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33934 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116Ab1KKTWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 14:22:34 -0500
Subject: Re: [PATCH] mac80211: fix warning in ieee80211_probe_client
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
References: <1321036348-32272-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Nov 2011 20:22:30 +0100
Message-ID: <1321039350.22919.6.camel@jlt3.sipsolutions.net> (sfid-20111111_202237_814503_4E6FAFC5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-11 at 13:32 -0500, John W. Linville wrote:
> CC [M]  net/mac80211/cfg.o
> net/mac80211/cfg.c: In function ‘ieee80211_probe_client’:
> net/mac80211/cfg.c:2567:7: warning: ‘qos’ may be used uninitialized in this function

Hm, you need a better compiler ;-) How about below instead (keeping the
subject)? I kinda don't like just initialising the variable "randomly".

johannes


From: Johannes Berg <johannes.berg@intel.com>

The warning is spurious -- if !sta we always exit without using the
unassigned qos variable, and if we do find the sta we assign it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---

--- wireless-testing.orig/net/mac80211/cfg.c	2011-11-10 09:29:29.000000000 +0100
+++ wireless-testing/net/mac80211/cfg.c	2011-11-11 20:21:08.000000000 +0100
@@ -2530,12 +2530,13 @@ static int ieee80211_probe_client(struct
 
 	rcu_read_lock();
 	sta = sta_info_get(sdata, peer);
-	if (sta)
+	if (sta) {
 		qos = test_sta_flag(sta, WLAN_STA_WME);
-	rcu_read_unlock();
-
-	if (!sta)
+		rcu_read_unlock();
+	} else {
+		rcu_read_unlock();
 		return -ENOLINK;
+	}
 
 	if (qos) {
 		fc = cpu_to_le16(IEEE80211_FTYPE_DATA |


