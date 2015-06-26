Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:32883 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbbFZTPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 15:15:15 -0400
Received: by vnbf190 with SMTP id f190so16956119vnb.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 12:15:14 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
	<CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com> <CAEFj986=3t=9B5d_2JP1Yo2fSOEvb7wgRfgMWdyw4DnutrGANQ@mail.gmail.com>
In-Reply-To: <CAEFj986=3t=9B5d_2JP1Yo2fSOEvb7wgRfgMWdyw4DnutrGANQ@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 26 Jun 2015 12:15:14 -0700
Message-ID: <a159a6cc0459b2fa089f0f222085aeb2@mail.gmail.com> (sfid-20150626_211519_802995_7717CCDE)
Subject: RE: [PATCH] mac80211: mesh - don't special case routing to transmitter
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sorry I miss out your previous email.
>
> > We did this over a year ago and I don't think we saw routing loops
> > though iirc we saw better performance when we made the change. Most
> > likely because of the other problem with the original code: it creates
> > a path to the ta if none exists but does not go through discovery to do
> > so.
>
> Yes, it is a direct hop towards the mgmt->sa,
>
> > So if the direct hop
> > is not the best path you're going to be stuck with a crappy path until
> > the next refresh.
>
> But hey, the code has already compared the path metric, right? Next
> refresh,
> so if you reduce the active path timeout
> (dot11MeshHWMPactivePathTimeout), you solve the problem, right?

Most likely. But selecting a bad path for 30s (or whatever
dot11MeshHWMPactivePathTimeout is set to) is not a good idea. Of course
usually the direct hop will be the best path but that is certainly not
guaranteed.

> > In any case updating metrics without doing an SN feasibility check is
> > highly suspect.
>
> As cited in section 13.10.8.4, "the mesh STA may create or update its
> forwarding information to the transmitter of the element if the path
> metric
> improves." So it is correctly implemented.

Yes, my argument is that that was a bad idea on the part of the standard and
optional so we can remove it.

> > I'm not 100% sure this instance will cause routing loops but I do know
> > that every time I have tried to be clever and optimize routing without
> > looking at both the SN and metric I have wound up with routing loops.
>
> I would recommend to add nl80211 command to disable this. After all, it
> may
> change other people's network behavior.
>
> Also, you may post you patch to o11s mailing list and your test scenario.
> Maybe others can verify as well to be 100% sure.

There are two test scenarios:
1) When creating the path to a ta where the direct hop is a bad path.
Relatively easy to setup and demonstrate poor performance pre-patch.
2) Incorrect routing when the metric for an existing SN is changed without
also updating the SN. Hard to demonstrate. We've certainly seen similar bugs
with our own mesh protocols but that was with protocols explicitly designed
with testing support. Best approach is probably via something like
http://alloy.mit.edu/alloy/

  -- Jesse
