Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44916 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759526Ab0JFSLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 14:11:38 -0400
Subject: Re: Crash in cfg80211_unlink_bss
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286388245.3655.392.camel@jlt3.sipsolutions.net>
References: <4CACB1D1.7090900@candelatech.com>
	 <1286388245.3655.392.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 20:11:37 +0200
Message-ID: <1286388697.3655.393.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 20:04 +0200, Johannes Berg wrote:

> But anyway, now that I look at it in more detail, it seems fairly
> obvious. You should be able to trigger it with two stations, but it's
> probably harder ...
> 
> I need to analyse the refcounting here again and in more detail, but in
> the meantime can you try below patch?

Ok, I did that, and it's because the BSS list owns a reference, so
this'll just crash somewhere else for you now ... Below should fix it
completely.

johannes

---
 net/wireless/scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- wireless-testing.orig/net/wireless/scan.c	2010-10-06 19:59:41.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2010-10-06 20:10:41.000000000 +0200
@@ -668,14 +668,14 @@ void cfg80211_unlink_bss(struct wiphy *w
 	bss = container_of(pub, struct cfg80211_internal_bss, pub);
 
 	spin_lock_bh(&dev->bss_lock);
+	if (!list_empty(&bss->list)) {
+		list_del_init(&bss->list);
+		dev->bss_generation++;
+		rb_erase(&bss->rbn, &dev->bss_tree);
 
-	list_del(&bss->list);
-	dev->bss_generation++;
-	rb_erase(&bss->rbn, &dev->bss_tree);
-
+		kref_put(&bss->ref, bss_release);
+	}
 	spin_unlock_bh(&dev->bss_lock);
-
-	kref_put(&bss->ref, bss_release);
 }
 EXPORT_SYMBOL(cfg80211_unlink_bss);
 


