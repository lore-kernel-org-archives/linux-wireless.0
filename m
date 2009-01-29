Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59482 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbZA2ROB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2009 12:14:01 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2009 09:14:01 -0800
Date: Thu, 29 Jan 2009 09:13:17 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Jack Bates <ms419@freezone.co.uk>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] compat-wireless-old redefinition of
	'ieee80211_install_qdisc'
Message-ID: <20090129171316.GA10772@tesla> (sfid-20090129_181408_015836_9C73044D)
References: <1232918295.3448.9.camel@tad.lat>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232918295.3448.9.camel@tad.lat>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 01:18:15PM -0800, Jack Bates wrote:
> http://cgi.sfu.ca/~jdbates/tmp/linux/200901250/patch
> 
> I installed Debian Lenny on my new Eee PC 1000HA this weekend, and to
> get the Atheros AR242x working, I compiled the compat-wireless-old
> package.
> 
> I installed the Debian linux-headers-2.6.26-1-686 package, version
> 2.6.26-13 but got errors such as this compiling compat-wireless-old:
> 
> [...]/wme.c:594: error: redefinition of 'ieee80211_install_qdisc'
> [...]/wme.h:39: error: previous definition of 'ieee80211_install_qdisc'
> was here
> 
> After applying the linked patch to wme.c, I successfully compiled
> compat-wireless-old, and am sending this message from my Eee PC with
> wireless : )
> --

Thanks for the report and the patch. I'm pasting it inline here to comment on it:

--- a/compat-wireless-2.6-old/net/mac80211/wme.c	2009-01-24 15:15:21.000000000 -0800
+++ b/compat-wireless-2.6-old/net/mac80211/wme.c	2009-01-24 15:30:11.000000000 -0800
@@ -590,6 +590,7 @@
 };
 
 
+#ifdef CONFIG_MAC80211_QOS
 void ieee80211_install_qdisc(struct net_device *dev)
 {
 	struct Qdisc *qdisc;
@@ -706,3 +707,4 @@
 			wme_qdiscop_enqueue(skb, root_qd);
 	}
 }
+#endif /* CONFIG_MAC80211_QOS */

----

This is incorrect as wme.c should not be compiled unless you have
CONFIG_MAC80211_QOS and CONFIG_MAC80211_QOS will only be defined:

 * if you have 2.6.22
 * you are on 2.6.23..2.6.26 AND
	- You have CONFIG_NETDEVICES_MULTIQUEUE
	- You have CONFIG_NET_SCHED

This logic is in config.mk. Then our mac80211 Makefile has:

mac80211-$(CONFIG_MAC80211_QOS) += wme.o

In your case you have 2.6.26 and you seem to be having compilation issues
with wme.o. Note that the 2.6.26 kernel has its own mac80211 and its Makeifle has:

mac80211-$(CONFIG_NET_SCHED) += wme.o

CONFIG_MAC80211_QOS is no longer an option on 2.6.26, I'm curious
where it got enabled then as config.mk shouldn't have enabled it unless
you had both:

CONFIG_NETDEVICES_MULTIQUEUE
CONFIG_NET_SCHED

I just updated compat-wireless old to bail out if you have CONFIG_MAC80211_QOS
from your own kernel if you are on 2.6.23..2.6.26 as it should not be enabled.

  Luis
