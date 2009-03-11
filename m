Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24282 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbZCKVwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 17:52:38 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 14:52:37 -0700
Date: Wed, 11 Mar 2009 13:51:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Christian Lamparter <chunkeey@web.de>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH v5 1/4] ath9k: implement IO serialization
Message-ID: <20090311205157.GI5669@tesla> (sfid-20090311_225241_487580_BDDAEB5F)
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com> <1236792616.20266.39.camel@johannes.local> <43e72e890903111408n1af65629s4d3b6f4b1c6fbb44@mail.gmail.com> <200903112238.24116.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <200903112238.24116.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 11, 2009 at 02:38:24PM -0700, Christian Lamparter wrote:
> On Wednesday 11 March 2009 22:08:43 Luis R. Rodriguez wrote:
> > On Wed, Mar 11, 2009 at 10:30 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Wed, 2009-03-11 at 10:20 -0700, Luis R. Rodriguez wrote:
> > >
> > >> > Hmm. I really don't understand this at all. Most operations won't be
> > >> > single writes and reads, and if you need multiple like a write+read for
> > >> > indirect register accesses then I'm sure you need to serialise them
> > >> > against each other in some other way too, no?
> > >>
> > >> The issue is not serializing against separate routines calling some
> > >> reads or writes, this serialization prevents the PCI hardware FIFO
> > >> queue from getting more than two requests as otherwise the hardware
> > >> poops out. But as you can see this is only an issue with PCI devices,
> > >> not PCI express devices.
> > >
> > > Well yes, but if you ever do multi-read/write operations then you need
> > > to synchronise at a higher level anyway -- hence I don't quite
> > > understand why this is necessary at all.
> >
> > Agreed as the PCI FIFO issue should be visible on even UP boxes too. I
> > was trying to find out out exactly why in an SMP system this would
> > occur and it seems the only thing that would cause this is two
> > separate threads reading/writing. I did review this but I was unable
> > to find a specific synchronization issue. Technically the most obvious
> > case is where we handle the beacon tasklet on one CPU and then the
> > RX/TX tasklet (this is done in just one tasklet) in another but we
> > don't handle the beaconing tasklet in STA mode and this issue is seen
> > immediately upon association as a STA. I've been unable to locate that
> > source of possible synchronization issue. If you get an idea let me
> > know.
> 
> maybe it's down to the simple fact that most mainboard nowadays
> queue up pci writes?

The issue is not the PCI host controller queuing these up, the issue
is actually having the PCI host controller send too many requests.
For example when the device is still working on one PCI write and its
own device queue is already full to the capicity it supports (say 2)
and it tells the PCI bus to retry if the device is taking a little
longer than expected to do some specific operation and the queue is
still full upon the next request it will poo. An alternative I was
looking for was to increase a udelay() somewhere guessing that perhaps
that would cure this as well. This could potentiall work as well but
I haven't found that spot yet or know for sure if any does exist for
sure.

> what happends when you always read the
> register after it was updated?

Not sure what you mean. Keep in mind some registers do not keep the
data we write to it.

  Luis
