Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.184]:21802 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759235AbYBFIxk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 03:53:40 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1886923rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2008 00:53:37 -0800 (PST)
Message-ID: <c85cb4470802060053j53f571f8v3a8ed55212ff934d@mail.gmail.com> (sfid-20080206_085352_661005_018D33DE)
Date: Wed, 6 Feb 2008 10:53:37 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/1] mac80211: fix mis-match in {test,set}_bit qdisc_pool
Cc: "Tomas Winkler" <tomasw@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080206003346.GK4252@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <12020756782190-git-send-email-tomas.winkler@intel.com>
	 <20080205205453.GJ4252@tuxdriver.com>
	 <1ba2fa240802051536y2aac90f1g1e9d3495df9b8bb@mail.gmail.com>
	 <20080206003346.GK4252@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > > This patch fixes a mis-match in {test,set}_bit for qdisc_pool created by
> > > > the move to an array of bits.

> > >   CC [M]  net/mac80211/wme.o
> > > net/mac80211/wme.c: In function 'wme_qdiscop_enqueue':
> > > net/mac80211/wme.c:161: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c:161: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c:194: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c:194: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c: In function 'wme_qdiscop_dequeue':
> > > net/mac80211/wme.c:275: warning: passing argument 2 of 'constant_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c:275: warning: passing argument 2 of 'variable_test_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c: In function 'wme_qdiscop_init':
> > > net/mac80211/wme.c:399: warning: passing argument 2 of 'set_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_add':
> > > net/mac80211/wme.c:660: warning: passing argument 2 of 'test_and_set_bit' makes pointer from integer without a cast
> > > net/mac80211/wme.c:673: error: subscripted value is neither array nor pointer
> > > net/mac80211/wme.c: In function 'ieee80211_ht_agg_queue_remove':
> > > net/mac80211/wme.c:693: warning: passing argument 2 of 'clear_bit' makes pointer from integer without a cast
> > > make[1]: *** [net/mac80211/wme.o] Error 1
> > > make: *** [net/mac80211/] Error 2
> > >
>
> I don't see a warning w/o it -- only build breakage w/ it.
>

John, the same errors i get when trying to apply this patch without
applying first
"adjustable number of bits for qdisc pool" patch. in fact i think it
is better that both would be united to one patch, as this patch is a
fix to warnings caused by "adjustable number of bits for qdisc pool",
but i leave it to your decision
thanks
ron
