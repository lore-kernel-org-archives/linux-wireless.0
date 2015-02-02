Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:42518 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbbBBQoj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2015 11:44:39 -0500
Received: by mail-la0-f46.google.com with SMTP id s18so42933304lam.5
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2015 08:44:38 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 2 Feb 2015 17:44:38 +0100
Message-ID: <CAJ1dT9x+vWm4uZ-r9PZrTmKjEQc260NhOKoRzH=Ab=oWkeZ83w@mail.gmail.com> (sfid-20150202_174443_420355_B042D759)
Subject: Open Source RRM & Hand-Over Optimization (WAS: Throughput regression
 with `tcp: refine TSO autosizing`)
From: =?UTF-8?Q?Bj=C3=B6rn_Smedman?= <bs@anyfi.net>
To: Avery Pennarun <apenwarr@google.com>, David Reed <dpreed@reed.com>
Cc: dstanley@arubanetworks.com, Derrick Pallas <pallas@meraki.com>,
	"cerowrt-devel@lists.bufferbloat.net"
	<cerowrt-devel@lists.bufferbloat.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2015 at 5:21 AM, Avery Pennarun <apenwarr@google.com> wrote:
> On Sun, Feb 1, 2015 at 9:43 AM,  <dpreed@reed.com> wrote:
>> Just to clarify, managing queueing in a single access point WiFi network is
>> only a small part of the problem of fixing the rapidly degrading performance
>> of WiFi based systems.
>
> Can you explain what you mean by "rapidly degrading?"  The performance
> in odd situations is certainly not inspirational, but I haven't
> noticed it getting worse over time.
>
>> Similarly, mesh routing is only a small part of the
>> problem with the scalability of cooperative meshes based on the WiFi MAC.
>
> That's certainly true.  Not to say the mesh routing algorithms are
> much good either.
>
>>  Also, as we noted
>> earlier, "handoff" from one next hop to another is a huge problem with
>> performance in practical deployments (a factor of 10x at least, just in
>> that).
>
> While there is definitely some work to be done in handoff, it seems
> like there are some find implementations of this already in existence.
> Several brands of "enterprise access point" setups seem to do well at
> this.  It would be nice if they interoperated, I guess.
>
> The fact that there's no open source version of this kind of handoff
> feature bugs me, but we are working on it here and the work is all
> planned to be open source, for example: (very early version)
> https://gfiber.googlesource.com/vendor/google/platform/+/master/waveguide/

We've got an SDN-inspired architecture with 802.11 frame tunneling (a
la CAPWAP), airtime fairness, infrastructure initiated hand-over,
Opportunistic Key Caching (OKC), IEEE 802.11r Fast BSS Transition and
a few more goodies. It's currently free as in beer
(http://anyfi.net/software,
https://github.com/carrierwrt/carrierwrt/pull/7 and
http://www.anyfinetworks.com/download) up to 100 APs, but we're
definitely going to open source in one form or another.

We've also tried to raise some interest in fixing up CAPWAP
(https://www.ietf.org/mail-archive/web/opsawg/current/msg03196.html),
which is (unfortunately) the best open standard at the moment.
Interest seems marginal though...

If anybody's interested in joining forces on either front we'd be be
happy to talk.

Cheers,

Björn
