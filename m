Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:43780 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYFKM67 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 08:58:59 -0400
Date: Wed, 11 Jun 2008 08:58:57 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	Tim Gardner <tim.gardner@canonical.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for older kernels
Message-ID: <20080611125857.GG17936@ruslug.rutgers.edu> (sfid-20080611_145902_634260_54720C4C)
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com> <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com> <1213001797.698.57.camel@johannes.berg> <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com> <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com> <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com> <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com> <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com> <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com> <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 02:12:41PM +0200, Johannes Berg wrote:
> 
> > Johannes -- why do we have the requirement for NETDEVICES_MULTIQUEUE
> > on CONFIG_MAC80211_QOS? My current config doesn't have it it and
> > CONFIG_MAC80211_QOS still works right now enabled. Of course the
> > driver I'm testing doesn't have 11n though.
> 
> because otherwise skb_get_queu_mapping always returns 0 and you use only
> one queue.
> 
> > Shouldn't we just make MAC80211_QOS depend on NET_SCHED and figure out
> > we can't support 11n based on NETDEVICES_MULTIQUEUE?
> 
> no, 11e also needs multiple queues.

Thanks, since MAC80211_QOS was there before the issue is some
kernels may have this enabled but they never got to MQ. This is why
certain compiles will complain about missing symbols.

So how about we disable it if we determine MQ and NET_SCHED are off?
Like this:

diff --git a/config.mk b/config.mk
index e8dc469..b72e37e 100644
--- a/config.mk
+++ b/config.mk
@@ -27,7 +27,16 @@ ifeq ($(shell test $(KERNEL_SUBLEVEL) -lt 23 && echo yes),yes)
 CONFIG_MAC80211_QOS=y
 else
 ifeq ($(CONFIG_NETDEVICES_MULTIQUEUE),)
-$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11n support")
+ifeq ($(CONFIG_NET_SCHED),)
+$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE and CONFIG_NET_SCHED for 802.11[ne] support")
+else
+# Disable CONFIG_MAC80211_QOS if you had it enabled befofre in your old .config
+$(warning "WARNING: You are running a kernel >= 2.6.23, you should enable CONFIG_NETDEVICES_MULTIQUEUE for 802.11[ne] support")
+CONFIG_MAC80211_QOS=n
+endif
+else
+# Disable CONFIG_MAC80211_QOS if you had it enabled befofre in your old .config
+CONFIG_MAC80211_QOS=n
 endif
 endif
 endif
