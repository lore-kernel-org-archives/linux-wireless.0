Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54104 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0JFSEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:04:06 -0400
Subject: Re: Crash in cfg80211_unlink_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CACB1D1.7090900@candelatech.com>
References: <4CACB1D1.7090900@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:04:05 +0200
Message-ID: <1286388245.3655.392.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 10:28 -0700, Ben Greear wrote:
> This test scenario has  72 stations on ath5k trying to connect to a cisco AP
> that supposedly only supports 63 stations.
> 
> The 72 STA were created without ssid's configured, then we re-configured all
> 72 'at once' to give them the proper SSID (ifdown, ifup, iwconfig to set values).

Eww, iwconfig ;-)

> The system crashed and rebooted.
> 
> Kernel is wireless-testing as of later yesterday, with a few additional
> patches mostly dealing with counters in /proc/net/wireless and some lockdep
> fixes pulled in from lkml etc.
> 
> We have seen this before, but this is the first good stacktrace we got.
> 
> Likely we can reproduce this if extra information is needed.

> list_del corruption, next is LIST_POISON1 (00100100)

This one's interesting.

But anyway, now that I look at it in more detail, it seems fairly
obvious. You should be able to trigger it with two stations, but it's
probably harder ...

I need to analyse the refcounting here again and in more detail, but in
the meantime can you try below patch?

johannes

---
 net/wireless/scan.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- wireless-testing.orig/net/wireless/scan.c	2010-10-06 19:59:41.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2010-10-06 20:01:20.000000000 +0200
@@ -668,11 +668,11 @@ void cfg80211_unlink_bss(struct wiphy *w
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&dev->bss_lock);
-
-	list_del(&bss->list);
-	dev->bss_generation++;
-	rb_erase(&bss->rbn, &dev->bss_tree);
-
+	if (!list_empty(&bss->list)) {
+		list_del_init(&bss->list);
+		dev->bss_generation++;
+		rb_erase(&bss->rbn, &dev->bss_tree);
+	}
 	spin_unlock_bh(&dev->bss_lock);
 
 	kref_put(&bss->ref, bss_release);


