Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbaJIJn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:43:26 -0400
Date: Thu, 9 Oct 2014 11:40:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mark Asselstine <asselsm@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rt2x00: rt2x00queue: avoid using more headroom then
 driver requested
Message-ID: <20141009094038.GA1996@redhat.com> (sfid-20141009_114329_627921_9FBA0E18)
References: <1412135157-13520-1-git-send-email-asselsm@gmail.com>
 <20141001091240.GA2011@redhat.com>
 <CAPuovEJtuJdRakwRhdUjRwrmkfry62wJqd8p2uJQ7L0rB7DoCA@mail.gmail.com>
 <CAPuovEJssghQv=03sn07AuYVvwULq0kSTn9kch53r+VKccy8xA@mail.gmail.com>
 <be003eea-b253-4eb3-bf08-40d5f6dc629d@email.android.com>
 <CAPuovEJXkRYyWXZJD7E6_1EqemfJus7Gtr_5PztT6rDtsrRpdw@mail.gmail.com>
 <20141008130006.GB5186@redhat.com>
 <CAPuovEKn+Lz3dqSZPhgd+-F4=n6tTOYyg3MDQ=E5yntGM8zYZg@mail.gmail.com>
 <CAPuovE+vAp9W3xBi6z3TDz51rKESXMuOT9Ow7ZX3Sm7dYQ+mFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPuovE+vAp9W3xBi6z3TDz51rKESXMuOT9Ow7ZX3Sm7dYQ+mFg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2014 at 11:34:22PM -0400, Mark Asselstine wrote:
> On Wed, Oct 8, 2014 at 3:52 PM, Mark Asselstine <asselsm@gmail.com> wrote:
> > On Wed, Oct 8, 2014 at 9:00 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >>
> >> On Wed, Oct 08, 2014 at 07:46:33AM -0400, Mark Asselstine wrote:
> >> > > If rt2x00 does not remove the alignment from the frame before giving it back
> >> > > to mac80211 and the same frame comes into rt2x00 again it should be correctly
> >> > > aligned and no additional header space is required. So this should be fine.
> >> >
> >> > Then I would say this definitely hints at a design flaw in
> >> > rt2x00queue_insert_l2pad(). Take the following scenario.
> >> >
> >> > * skb's first arrival in rt2x00queue_insert_l2pad(), 3 bytes needed
> >> > for frame alignment, 2 bytes for l2pad results in 3 bytes of headroom
> >> > taken.
> >> Not quite realistic assumption - header length will have to be odd then.
> >>
> >> But if such situation would happen we will have:
> >>
> >> header_align=2, payload_align=3, l2pad=3
> >>
> >> Since payload_align will be bigger than header_align, header_align will
> >> be increased to 6.
> >>
> >> Header will be moved by 6 bytes, frame will be moved by 3 bytes,
> >> between header and frame there will be l2pad equal to 3.
> >>
> >> > * rt2x00lib_txdone() returns 2 bytes of headroom
> >> Return 3 bytes.
> >>
> >> > * skb's second arrival in rt2x00queue_insert_l2pad(), 0 bytes needed
> >> > for frame alignment, 2 bytes for l2pad results in 4 bytes of headroom
> >> > taken.
> >> Header will be moved by 3 bytes.
> >>
> >> > * rt2x00lib_txdone() returns 2 bytes of headroom
> >> Return 3 bytes.
> >>
> >> > Basically as long as any bytes are required for l2pad the headroom
> >> > will lose 4 bytes again and again, never being returned by
> >> > rt2x00lib_txdone().
> >>
> >> I think that's not true - you made a few mistakes in your scenario,
> >> but perhaps I'm wrong :-)
> >
> > No just me being an idiot. I had thought
> >  frame == header + l2pad + payload
> > not
> >  frame == payload
> >
> 
> By the way, I assumed that this due to the name and contents of
> rt2x00queue_align_frame(). Where all the data (header and payload) are
> aligned to a 4-byte boundary and the function is name 'align_frame'. I
> assume your interpretation is the correct one, can you confirm?

Frame term is used mostly to describe all data including header and
payload.

Stanislaw

