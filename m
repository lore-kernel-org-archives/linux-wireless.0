Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f49.google.com ([209.85.216.49]:38359 "EHLO
	mail-vn0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbbFZUFJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 16:05:09 -0400
Received: by vnbf129 with SMTP id f129so2475425vnb.5
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 13:05:08 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
	<4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>	<CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
	<b193de6c0b11af0193414a217f0ea56b@mail.gmail.com> <CAEFj986Jt-1rymgARCvDe+2Tb1R0PqsDfSELC7WbAXfkC+9xPw@mail.gmail.com>
In-Reply-To: <CAEFj986Jt-1rymgARCvDe+2Tb1R0PqsDfSELC7WbAXfkC+9xPw@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 26 Jun 2015 13:05:06 -0700
Message-ID: <fff70f4adca53a929cda056a21f4d3ad@mail.gmail.com> (sfid-20150626_220515_026304_67575A52)
Subject: RE: [PATCH] mac80211: mesh - always do every discovery retry
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Bad path would be bad, but again re-attempt whenever a path is already
> established seems not a good idea. Why not wait till next path refresh?

Because 30s is an awfully long time to stick with a bad path. And if we do
one attempt per discovery then the next refresh has an equal chance to
discover the same bad path.

> > How is looking at the PHY going to help?. Originally you said the
> > patch would cause additional latency and I don't think that's true.
>
> Did you do some "ping" latency test before and after patching your patch?

We did high rate pings though we mostly focused on loss. There was a clear
improvement post-patch.

If you're thinking of latency caused by more hops that will likely be the
case of course. But if you think latency should be factored into pathing
then the place to do that is when computing link metrics.

> > No I mean the expiry time. Every 30s or so paths are refreshed.
> > Lowering dot11MeshHWMPactivePathTimeout won't do much other than
> give
> > you more path refreshes, each of which will have the same chance to
> select badly.
>
> I don't get it. You intention to resend PREQ until max_preq_retries
> (resend
> the same mgmt frame 4 times) is to find the best path. So it is same with
> path
> refresh?

Yes

> > Whether the path is already established or not is immaterial. In
> > either case there is the potential for selecting a bad path when the
> > first PREQ is sent out. In either case you have to balance the cost of
> > sending additional path messages out with the cost of selecting the
> > wrong
> path.
> >
>
> Ya, you are right.
>
> > Your big worry seems to be that flooding 4x as many PREQs is too
> expensive.
> > I don't think that's the case. The PREQs are broadcast so they'll go
> > one hop. And when they are received they will only be re-broadcast if
> > they arrived on a better path. This is not any worse than something
> > like site local multicast and we would only be flooding an additional
> > *three*
> packets.
>
> Yes, you are right. But now whenever each nodes initial the transmission
> on
> path discovery, each will send 4 times the same PREQ frame. I think that
> this
> patch seems to compensate the metric calculation that maybe inaccurate.

In general each node will send out a PREQ four or more times now (can be
more than four because a node may hear from progressively better peers). I
don't understand your metric comment.

> > My big worry is that we will select bad paths. And this *will* happen.
> > I've seen it many times. And if it does happen the effects are not
> > theoretical; they are by definition bad. We *have* selected a bad path
> > after all. And when we select a bad path it will be very apparent to
> > end users. Bandwidth will be lower than it should be and loss may go up
> > as
> well.
>
> Agreed with your point. How about adding nl80211 command for this?

I'm not keen on the idea. I still think it's the right thing to do and I
don't much like the idea of having to turn it on. And it will become an even
better idea if we don't refresh as often (eventually I'll send a patch for
that though I think I may have to massage what we're using now).

  -- Jesse
