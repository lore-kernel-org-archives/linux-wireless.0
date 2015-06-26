Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34661 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbbFZBwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 21:52:51 -0400
Received: by wicnd19 with SMTP id nd19so32800633wic.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 18:52:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
	<CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com>
Date: Fri, 26 Jun 2015 09:52:50 +0800
Message-ID: <CAEFj986=3t=9B5d_2JP1Yo2fSOEvb7wgRfgMWdyw4DnutrGANQ@mail.gmail.com> (sfid-20150626_035255_266470_51544D9E)
Subject: Re: [PATCH] mac80211: mesh - don't special case routing to transmitter
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jesse Jones <jjones@cococorp.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry I miss out your previous email.

> We did this over a year ago and I don't think we saw routing loops though
> iirc we saw better performance when we made the change. Most likely because
> of the other problem with the original code: it creates a path to the ta if
> none exists but does not go through discovery to do so.

Yes, it is a direct hop towards the mgmt->sa,

> So if the direct hop
> is not the best path you're going to be stuck with a crappy path until the
> next refresh.

But hey, the code has already compared the path metric, right? Next
refresh, so if you reduce the active path timeout
(dot11MeshHWMPactivePathTimeout), you solve the problem, right?

> In any case updating metrics without doing an SN feasibility check is highly
> suspect.

As cited in section 13.10.8.4, "the mesh STA may create or update its
forwarding information to the transmitter of the element if the path
metric improves." So it is correctly implemented.

> I'm not 100% sure this instance will cause routing loops but I do
> know that every time I have tried to be clever and optimize routing without
> looking at both the SN and metric I have wound up with routing loops.

I would recommend to add nl80211 command to disable this. After all,
it may change other people's network behavior.

Also, you may post you patch to o11s mailing list and your test
scenario. Maybe others can verify as well to be 100% sure.

Thanks

---
Chun-Yeow
