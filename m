Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbYFZSAo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:00:44 -0400
Subject: [PATCH] mac80211: make workqueue freezable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Jun 2008 19:59:56 +0200
Message-Id: <1214503196.3783.13.camel@johannes.berg> (sfid-20080626_200059_514561_B92AB8D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the mac80211 workqueue freezable making it
interact a bit better with system suspend and not try to ping
the AP while the hardware is down.

This doesn't really help with implementing proper suspend in
any way but makes some bad things trigger less.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I'm not sure whether we should put this into 2.6.26 or not, while it
might help a bit it doesn't really do much over what the tx bugs finder
already does except avoid sending out the packets that froze b43 in the
first place...

Ivo, you might consider using =EF=BB=BFcreate_freezeable_workqueue for =
your
rt2x00 patch though.

 net/mac80211/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/net/mac80211/main.c	2008-06-26 18:21:14.000000000 +=
0200
+++ everything/net/mac80211/main.c	2008-06-26 18:21:16.000000000 +0200
@@ -1774,7 +1774,7 @@ int ieee80211_register_hw(struct ieee802
 	list_add_tail(&sdata->list, &local->interfaces);
=20
 	name =3D wiphy_dev(local->hw.wiphy)->driver->name;
-	local->hw.workqueue =3D create_singlethread_workqueue(name);
+	local->hw.workqueue =3D create_freezeable_workqueue(name);
 	if (!local->hw.workqueue) {
 		result =3D -ENOMEM;
 		goto fail_workqueue;


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
