Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:41262 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755812Ab1FWLwr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jun 2011 07:52:47 -0400
From: Yogesh Powar <yogeshp@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Andreas Hartmann <andihartmann@01019freenet.de>
Date: Thu, 23 Jun 2011 04:52:39 -0700
Subject: RE: [PATCH 2/2] mac80211: Fixing Races for skipping tailroom
 reservation
Message-ID: <7DDF37406E10F0438561DBB78326DF3902F5D190EB@SC-VEXCH1.marvell.com> (sfid-20110623_135250_167265_59DBB593)
References: <7DDF37406E10F0438561DBB78326DF3902F5D190E2@SC-VEXCH1.marvell.com>
	 <1308590980.4322.19.camel@jlt3.sipsolutions.net>
	 <20110621130305.GB32464@hertz.marvell.com>
	 <1308663814.4276.3.camel@jlt3.sipsolutions.net>
	 <20110621141017.GC32464@hertz.marvell.com>
	 <1308667215.4276.7.camel@jlt3.sipsolutions.net>
	 <20110621163351.GD32464@hertz.marvell.com>
	 <20110622071743.GA4087@hertz.marvell.com>
	 <20110622123118.GA4800@hertz.marvell.com>
	 <1308746965.29571.1.camel@jlt3.sipsolutions.net>
	 <20110622125853.GA4982@hertz.marvell.com>,<1308748326.29571.6.camel@jlt3.sipsolutions.net>
In-Reply-To: <1308748326.29571.6.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>What I'm worried about is that there's no memory barrier after the
>counter update, so how do we know it cannot happen after
>synchronize_rcu()? I think we need something like rcu_assign_pointer()
>but I don't see rcu_assign_index() (any more?)

I did not find much on rcu_assign_index other than
http://markmail.org/thread/h53fuecyo5odg6xv which has this function defined as

+#define rcu_assign_index(p, v) ({ \
+               smp_wmb(); \
+               (p) = (v); \
+        })      

Will smp_wmb() do the trick?
counter++;
smp_wmb();
synchronize_rcu();

or will have to move to pointer logic? And use rcu_assign_pointer at key.c and
rcu_dereference at tx.c with overhead of kmalloc and kfree?

Thanks
Yogesh
