Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:42163 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbZENV1A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 17:27:00 -0400
Received: by rv-out-0506.google.com with SMTP id f9so866275rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 14:27:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242334636.4227.134.camel@localhost.localdomain>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	<1242327298.4227.25.camel@localhost.localdomain> <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	<1242334636.4227.134.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 May 2009 14:26:41 -0700
Message-ID: <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
Subject: Re: Scan while TX/RX'ing a lot of data
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 1:57 PM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2009-05-14 at 12:07 -0700, Luis R. Rodriguez wrote:
>> On Thu, May 14, 2009 at 11:54 AM, Dan Williams <dcbw@redhat.com> wrote:

>> > Secondarily, scanning is a tradeoff between better roaming latency and
>> > continuous high throughput.  If you don't scan, you have no idea what's
>> > around, and when you move and the current AP becomes marginal, you
>> > *have* to take the hit no matter what, so you can scan and find a new AP
>> > to associate with.
>>
>> True however I'm inclined to believe that generally when you are
>> sending or receiving a lot of data you are stationary so roaming might
>> not be that urgent. For 802.11p (vehicle stuff) I suppose this may be
>> a bit different but I have yet to see this take off.
>
> I'll believe 11p when I see it somewhere :)  But anyway, yeah, there are
> tricks we can play here, and I'm happy to entertain methods of making
> the scanning hit less annoying.  I'm simply opposed to a checkbox in the
> UI for "never scan while connected" because that's a pure cop-out: we
> should be making things intelligent, not taking the half-assed approach
> like people (nobody here of course) have been whining about for a long
> time.  Scanning isn't something the user should have to care about or
> turn on or off; it's something that NetworkManager (in concert with
> usage information from the stack) should be able to handle
> automatically.

Agreed.

> Maybe if there was a way to figure out how full mac80211's QoS buckets
> were, that would help?  Or get a frame counts from each of the 4 QoS
> buckets individually?  That would allow NM to make more intelligent
> decisions about stuff.  Maybe a more detailed nl80211 stats interface
> would do the trick here.

Would help for debugging too anyway, since QOS uses the new device
queues maybe that might already be available?

>> > I would have though that the periodic scanning would be more of an
>> > annoyance when doing VOIP or SSH other latency sensitive tasks, but when
>> > just downloading a file, a few second drop in transfer rate gets lost in
>> > the bucket in the grand scheme of things.
>>
>> Good point, how about we use pm_qos for disabling scan when we are
>> sending a lot of data (whatever we define this to mean)? Then
>> applications can just write to this pm_qos stuff and you won't see
>> this.
>>
>> I forget when pm_qos was introduced though.
>
> Yeah, something like that, although it's sometimes hard to go from app
> -> interface;

Yeah at least pm_qos is not device specific IIRC.

> if you have a wired interface connected at the same time,
> but the thing you're sucking down data from is on the wifi interface,
> we'd need some way to figure that out.

Point taken.

> Hence the idea about exposing
> the packet counts of the WMM queues or something like that.

I think this is a good idea, although it wouldn't solve anything for
people stuck on old userspace (my oldest target is distributions
releases circa 2.6.27). Not sure what is best for that case. The
kernel could be informed of the lack of userspace regulating this and
then take some reasonable action. What the reasonable action and the
terms for that remain unclear to me.

  Luis
