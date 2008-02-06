Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2070 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757180AbYBFBDU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2008 20:03:20 -0500
Date: Tue, 5 Feb 2008 19:33:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 1/1] mac80211: fix mis-match in {test,set}_bit
	qdisc_pool
Message-ID: <20080206003346.GK4252@tuxdriver.com> (sfid-20080206_010323_771631_DAB9CF3A)
References: <12020756782190-git-send-email-tomas.winkler@intel.com> <20080205205453.GJ4252@tuxdriver.com> <1ba2fa240802051536y2aac90f1g1e9d3495df9b8bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240802051536y2aac90f1g1e9d3495df9b8bb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 06, 2008 at 01:36:53AM +0200, Tomas Winkler wrote:
> On Feb 5, 2008 10:54 PM, John W. Linville <linville@tuxdriver.com> wrote:
> > On Sun, Feb 03, 2008 at 11:54:38PM +0200, Tomas Winkler wrote:
> > > From: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > >
> > > This patch fixes a mis-match in {test,set}_bit for qdisc_pool created by
> > > the move to an array of bits.
> > >
> > > Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> > > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> >
> >   CC [M]  net/mac80211/wme.o
> > net/mac80211/wme.c: In function 'wme_qdiscop_enqueue':
> > net/mac80211/wme.c:161: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c:161: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c:194: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c:194: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c: In function 'wme_qdiscop_dequeue':
> > net/mac80211/wme.c:275: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c:275: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c: In function 'wme_qdiscop_init':
> > net/mac80211/wme.c:399: warning: passing argument 2 of 'set_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
> > net/mac80211/wme.c:660: warning: passing argument 2 of 'test_and_set_bit' makes pointer from integer without a cast
> > net/mac80211/wme.c:673: error: subscripted value is neither array nor pointer
> > net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
> > net/mac80211/wme.c:693: warning: passing argument 2 of 'clear_bit' makes pointer from integer without a cast
> > make[1]: *** [net/mac80211/wme.o] Error 1
> > make: *** [net/mac80211/] Error 2
> >
> > Am I missing something?
> 
> This patch should fix warning that was caused Ron's patch
> 
> 'adjustable number of bits for qdisc pool'

I don't see a warning w/o it -- only build breakage w/ it.

-- 
John W. Linville
linville@tuxdriver.com
