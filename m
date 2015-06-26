Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34229 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbbFZThH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 15:37:07 -0400
Received: by wicnd19 with SMTP id nd19so53275713wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 12:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <b193de6c0b11af0193414a217f0ea56b@mail.gmail.com>
References: <CAEFj986a0b9r4qia-CFXsm_aiD8P5gLeJJqxS2NYcSjKcspLNw@mail.gmail.com>
	<4bd697c41f2bb66593c849246bde7b00@mail.gmail.com>
	<CAEFj9878gNnDViLYh+TW6GPUvJBbSn4Y=tDBmdp3NwBHymqxRg@mail.gmail.com>
	<b193de6c0b11af0193414a217f0ea56b@mail.gmail.com>
Date: Sat, 27 Jun 2015 03:37:06 +0800
Message-ID: <CAEFj986Jt-1rymgARCvDe+2Tb1R0PqsDfSELC7WbAXfkC+9xPw@mail.gmail.com> (sfid-20150626_213714_772141_9C477842)
Subject: Re: [PATCH] mac80211: mesh - always do every discovery retry
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Jesse Jones <jjones@cococorp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sure, you're paying a constant cost every time paths refresh to give you
> better odds of selecting a good path. But this is a small relatively
> infrequent cost (and could be made more infrequent: unless the environment
> is very dynamic it doesn't seem necessary to always periodically refresh).
> And it's not like selecting a bad path is without costs: users may not be
> able to push their data through the path and if it's less reliable TCP
> performance may turn to crap and retries may chew up the air.
>

Bad path would be bad, but again re-attempt whenever a path is already
established seems not a good idea. Why not wait till next path
refresh?

> How is looking at the PHY going to help?. Originally you said the patch
> would cause additional latency and I don't think that's true.

Did you do some "ping" latency test before and after patching your patch?

> No I mean the expiry time. Every 30s or so paths are refreshed. Lowering
> dot11MeshHWMPactivePathTimeout won't do much other than give you more path
> refreshes, each of which will have the same chance to select badly.

I don't get it. You intention to resend PREQ until max_preq_retries
(resend the same mgmt frame 4 times) is to find the best path. So it
is same with path refresh?

> Whether the path is already established or not is immaterial. In either case
> there is the potential for selecting a bad path when the first PREQ is sent
> out. In either case you have to balance the cost of sending additional path
> messages out with the cost of selecting the wrong path.
>

Ya, you are right.

> Your big worry seems to be that flooding 4x as many PREQs is too expensive.
> I don't think that's the case. The PREQs are broadcast so they'll go one
> hop. And when they are received they will only be re-broadcast if they
> arrived on a better path. This is not any worse than something like site
> local multicast and we would only be flooding an additional *three* packets.

Yes, you are right. But now whenever each nodes initial the
transmission on path discovery, each will send 4 times the same PREQ
frame. I think that this patch seems to compensate the metric
calculation that maybe inaccurate.

> My big worry is that we will select bad paths. And this *will* happen. I've
> seen it many times. And if it does happen the effects are not theoretical;
> they are by definition bad. We *have* selected a bad path after all. And
> when we select a bad path it will be very apparent to end users. Bandwidth
> will be lower than it should be and loss may go up as well.

Agreed with your point. How about adding nl80211 command for this?

----
Chun-Yeow
