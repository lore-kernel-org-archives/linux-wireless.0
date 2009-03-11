Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:33952 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZCKVib (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 17:38:31 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] [PATCH v5 1/4] ath9k: implement IO serialization
Date: Wed, 11 Mar 2009 22:38:24 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com> <1236792616.20266.39.camel@johannes.local> <43e72e890903111408n1af65629s4d3b6f4b1c6fbb44@mail.gmail.com>
In-Reply-To: <43e72e890903111408n1af65629s4d3b6f4b1c6fbb44@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903112238.24116.chunkeey@web.de> (sfid-20090311_223841_116064_EAD4BD52)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 March 2009 22:08:43 Luis R. Rodriguez wrote:
> On Wed, Mar 11, 2009 at 10:30 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2009-03-11 at 10:20 -0700, Luis R. Rodriguez wrote:
> >
> >> > Hmm. I really don't understand this at all. Most operations won't be
> >> > single writes and reads, and if you need multiple like a write+read for
> >> > indirect register accesses then I'm sure you need to serialise them
> >> > against each other in some other way too, no?
> >>
> >> The issue is not serializing against separate routines calling some
> >> reads or writes, this serialization prevents the PCI hardware FIFO
> >> queue from getting more than two requests as otherwise the hardware
> >> poops out. But as you can see this is only an issue with PCI devices,
> >> not PCI express devices.
> >
> > Well yes, but if you ever do multi-read/write operations then you need
> > to synchronise at a higher level anyway -- hence I don't quite
> > understand why this is necessary at all.
> 
> Agreed as the PCI FIFO issue should be visible on even UP boxes too. I
> was trying to find out out exactly why in an SMP system this would
> occur and it seems the only thing that would cause this is two
> separate threads reading/writing. I did review this but I was unable
> to find a specific synchronization issue. Technically the most obvious
> case is where we handle the beacon tasklet on one CPU and then the
> RX/TX tasklet (this is done in just one tasklet) in another but we
> don't handle the beaconing tasklet in STA mode and this issue is seen
> immediately upon association as a STA. I've been unable to locate that
> source of possible synchronization issue. If you get an idea let me
> know.

maybe it's down to the simple fact that most mainboard nowadays
queue up pci writes? what happends when you always read the
register after it was updated?

> Your point about the simplicity of the code by always doing the
> locking makes sense and its difficult to decide whether or not we want
> that without doing elaborate tests and analysis. Only reason to
> consider this carefully is that we will in fact be changing the
> behavior of each read/write.
> 
