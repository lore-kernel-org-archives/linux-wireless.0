Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vn0-f54.google.com ([209.85.216.54]:34041 "EHLO
	mail-vn0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbbFZUNa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 16:13:30 -0400
Received: by vnbg190 with SMTP id g190so17150665vnb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 13:13:29 -0700 (PDT)
From: Jesse Jones <jjones@cococorp.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
	<CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com>
	<CAEFj986=3t=9B5d_2JP1Yo2fSOEvb7wgRfgMWdyw4DnutrGANQ@mail.gmail.com>
	<a159a6cc0459b2fa089f0f222085aeb2@mail.gmail.com> <CAEFj9877azQTokwHAgg2-rn8Y5j41+5dW3BVAJpJwhwx2u4NRA@mail.gmail.com>
In-Reply-To: <CAEFj9877azQTokwHAgg2-rn8Y5j41+5dW3BVAJpJwhwx2u4NRA@mail.gmail.com>
MIME-Version: 1.0
Date: Fri, 26 Jun 2015 13:13:32 -0700
Message-ID: <330c0318174057b4aab778c1e5190fbe@mail.gmail.com> (sfid-20150626_221334_646047_6D91F35F)
Subject: RE: [PATCH] mac80211: mesh - don't special case routing to transmitter
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > There are two test scenarios:
> > 1) When creating the path to a ta where the direct hop is a bad path.
> > Relatively easy to setup and demonstrate poor performance pre-patch.
> > 2) Incorrect routing when the metric for an existing SN is changed
> > without also updating the SN. Hard to demonstrate. We've certainly
> > seen similar bugs with our own mesh protocols but that was with
> > protocols explicitly designed with testing support. Best approach is
> > probably via something like http://alloy.mit.edu/alloy/
>
> If the direct hop is a bad path, could it be due the metric calculation.

Sure, metric calculations are not perfect. But that is an entirely separate
can of worms. For the purposes of this discussion we can assume that the
metrics are perfect. Simplest case is the one I mentioned before: a U where
we're trying to route between the ends of the U but the direct hop is bad
and the links along the U are excellent.

> Also, you may also add your vendor specific mesh protocol to open source
> community.

Maybe. We spent many man years on it and eventually got it routing well. It
was all done in a commercial setting though so I don't know that we would
open source it.

  -- Jesse
