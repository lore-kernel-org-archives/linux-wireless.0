Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:57813 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbZA1QH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:07:28 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: "johannes\@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] mac80211: remove multicast check from check_tim()
References: <20090122114240.31443.18218.stgit@tikku>
	<20090122114539.31443.45201.stgit@tikku>
	<8e92b4100901280659t444486b2v27efffe7224d17b@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 28 Jan 2009 18:06:22 +0200
In-Reply-To: <8e92b4100901280659t444486b2v27efffe7224d17b@mail.gmail.com> (ext Vivek Natarajan's message of "Wed\, 28 Jan 2009 15\:59\:20 +0100")
Message-ID: <87pri7h0u9.fsf@nokia.com> (sfid-20090128_170732_709593_D47743BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> On Thu, Jan 22, 2009 at 5:15 PM, Kalle Valo <kalle.valo@nokia.com>
> wrote:
>> Currently mac80211 checks for the multicast tim bit from beacons,
>> disables power save and sends a null frame if the bit is set. This
>> was added to support ath9k. But this is a bit controversial because
>> the AP will send multicast frames immediately after the beacon and
>> the time constraints are really high. Relying mac80211 to be fast
>> enough here might not be reliable in all situations.
>
> I agree that mac80211 is not fast enough to disable power save when
> multicast bit is set. But a quick testing with multicast traffic with
> power save enabled shows me that the traffic is passing without much
> failures(97% passes through and this is not a small number considering
> my high traffic/noisy channel conditions). 

I'm still not convinced. Even if it works for your setup, somebody
else might have problems.

> So, the reason is not strong enough or the mac80211 is not too slow
> to respond to a mc traffic in practical conditions and hence the
> check need not be removed.

Well, we have to do something because stlc45xx/p54spi doesn't need
this. Either we need to do add a yet another hw flag or move the
functionality to ath9k. And I don't see the benefit of adding a new hw
flag just for one driver. If there are more hardware designs requiring
this, then adding support to mac80211 might make sense.

There's also a third option: do this in hardware. Are you really sure
that your hardware doesn't support waking up for broadcast/multicast
frames? It would only need to check two bits, multicast tim bit from
beacons and moredata bits from received broadcast/multicast frames.

>> And there's no need to send a null frame, AP will send the frames
>> immediately after the dtim beacon no matter what.
>
> You are right. In that case, if mc bit is set, we can change the code
> to just disable ps and not to send a null frame.

Like I said earlier, I don't like this approach. 

> But this pops up another issue! How to enable ps after waking up for
> mc traffic?

Just go back to sleep after receiving a broadcast/multicast frame with
moredata bit not set.

> For this we have got to have the dynamic_ps_timer called from the rx
> path also. This enables ps after the specified timeout. I don't see
> any good reason for not to have this timer in Rx path also.

Please take into account that dynamic_ps_timeout can be zero, you
cannot rely on dynamic_ps_timer.

Having dynamic timeout in rx path also is possible, but that's a
separate issue from multicast/broadcast problem. I haven't considered
it myself, though.

-- 
Kalle Valo
