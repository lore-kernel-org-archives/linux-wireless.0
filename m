Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755616Ab2CGSZj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 13:25:39 -0500
Date: Wed, 7 Mar 2012 19:25:24 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3.3] rt2x00: fix random stalls
Message-ID: <20120307182523.GA15839@redhat.com> (sfid-20120307_192542_891019_F143655C)
References: <20120305164813.GB2979@redhat.com>
 <CAGXE3d9==tT-ukfn5RO9xTEfw=YXO=FAVJob2WMFJS-FS8j9GQ@mail.gmail.com>
 <20120306115321.GB31306@redhat.com>
 <CAL1gcdNZR6KoZeQkW1EaZp5ptH9X5M+vhpo7pnPyUvkE6p6qDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAL1gcdNZR6KoZeQkW1EaZp5ptH9X5M+vhpo7pnPyUvkE6p6qDg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 06, 2012 at 01:08:04PM +0100, Gertjan van Wingerde wrote:
> On Tue, Mar 6, 2012 at 12:53 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Tue, Mar 06, 2012 at 08:45:21AM +0100, Helmut Schaa wrote:
> >> > -       if (!rt2x00queue_threshold(entry->queue))
> >> > +       if (!rt2x00queue_threshold(entry->queue)) {
> >> > +               spin_lock_irq(&entry->queue->tx_lock);
> >> >                rt2x00queue_unpause_queue(entry->queue);
> >> > +               spin_unlock_irq(&entry->queue->tx_lock);
> >>
> >> Why do we need to disable interrupts here? spin_lock_bh should
> >> be sufficient.
> >
> > I'm not 100% sure, and I was to lazy to find out, and chose safer
> > version. I guess I need to find out now ...

Ok, locking with bh is fine.

> That is actually a good point of Helmut. In all other cases where the tx_lock
> is used we actually use spin_lock and spin_unlock. AFAIK we shouldn't mix
> the different spinlock variants, so with this the other uses may have to change
> as well.

We use this lock only in rt2x00mac_tx (2 times) with bh disabled by
generic net or mac80211 layer. And now from txdone in process context
(usb) or tasklet (pci), so existing spin_lock function version does not
need to be changed.

On the meantime, I realized that we should also serialize
rt2x00queue_threshold(). I'll post second version of a patch shortly.

Stanislaw
