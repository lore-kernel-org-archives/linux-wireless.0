Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infineon.com ([217.10.60.23]:31149 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYG3LDL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 07:03:11 -0400
From: <Friedrich.Beckmann@infineon.com>
To: <johannes@sipsolutions.net>, <tomasw@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <j@w1.fi>
Date: Wed, 30 Jul 2008 13:03:06 +0200
Subject: RE: iwlwifi aggregation info
Message-ID: <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com> (sfid-20080730_130316_763313_EB314B29)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 (sfid-20080729_175540_513294_CB416055)
 <1217411631.10489.103.camel@johannes.berg>
In-Reply-To: <1217411631.10489.103.camel@johannes.berg>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

from my understanding the reason for hardware aggregation
queues is not a different priority level as for the AC queues.
But there are two things that make hardware aggregation queues
reasonable:

a) Packets which are aggregated must be in sequence and they
must belong to the same RA/TID. So if you mix packets which
belong to that aggregation process with packets which do no
not belong to that RA/TID, then you must either break the
aggregation process or you must somehow "jump" over the
packets to find suitable canditates for aggregation.

I think a random access to a queue makes it really
difficult to handle the hardware queues as it is done
today, because today it is assumed that packets are
dequeued in the order in that they are enqueued.

Therefore it is more likely that you have to break the
aggregation process when you find a packet that does not
fit to the current aggregation process.

Assume that you have the following packets in a queue, where
the packet is described by the tuple [RA/TID/sequence number].
The first packet would go to RA 1 with TID 1 and has
sequence number 5.

[1/1/5] - [1/1/6] - [1/1/7] - [2/1/3] - [1/1/8] - [1/1/9]
                                ^
                          This packets breaks aggregation

Now the fourth packet [2/1/3] would break the aggregation process
because it does not belong to RA=3D1/TID=3D1.

b) The length of the aggregate should be adapted to
the transmit opportunity (TXOP). The longer the aggregates,
the more efficient is the transmission. The most efficient
way is when you adapt the length of the aggregate to your
remaining transmit opportunity time (TXOP). Imagine you have
a TXOP of 1ms, then you should ideally adapt the aggregate
such that it takes approx. 1ms. But when you have consumed for
other packets, e.g. already 200=B5s, then you have only 800=B5s left
and you should tailor the aggregate that it fits in the 800=B5s.

I guess this process does depend on the current transmit situation
in a very similar way as the AC queues. The problem of the scheduling
between the hardware AC queue and the hardware aggregation queue where
all packets belong also to one AC is maybe not of that importance, comp=
ared
to the increase of transmit efficiency?

Regards

=46riedrich


> -----Original Message-----
> From: linux-wireless-owner@vger.kernel.org
> [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of
> Johannes Berg
> Sent: Wednesday, July 30, 2008 11:54 AM
> To: Tomas Winkler
> Cc: linux-wireless; Jouni Malinen
> Subject: Re: iwlwifi aggregation info
>
> On Tue, 2008-07-29 at 18:55 +0300, Tomas Winkler wrote:
>
> > So why do you need 4 HW queues for QoS, every vendor now
> implements it
> > that way today. There is only one medium, you don't put 4
> packets on
> > the air at the same time.
>
> The single medium part is true, but the scheduling decision
> is best made at the air interface, otherwise you'd need to be
> able to kill the hw fifo when a high-prio frame comes in to
> preempt other frames.
>
> > Now imaging that withing single queue you have another
> priority level
> > why it is wrong to add another queue for it?
>
> What makes you think aggregation is another priority level
> though? I don't see any evidence that it is, and everybody
> I've asked so far seems to agree with me.
>
> johannes
>

-----BEGIN PGP SIGNATURE-----
Version: SECUDE secure mail 4.2.8.1
Comment: SECUDE Office Security Suite - http://www.secude.com

iQA/AwUBSJBKTYmGfrssAHC0EQJ/qwCffSqp6zAdRw1YmvEPXxfYG0TuBpgAoMfRP+4syjw=
M
qTzjq6eDkEAQVlBk
=3DYDp3
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
