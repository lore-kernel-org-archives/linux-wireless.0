Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:38451 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab0CBPrv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 10:47:51 -0500
Received: by iwn34 with SMTP id 34so307353iwn.15
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 07:47:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8D25DC.8070502@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
	 <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
	 <4B8D25DC.8070502@openwrt.org>
Date: Tue, 2 Mar 2010 16:47:50 +0100
Message-ID: <133e8d7e1003020747w348dbee0g60a25a86393972d7@mail.gmail.com>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/3/2 Felix Fietkau <nbd@openwrt.org>:
> [snip] also the hardware
> doesn't even provide enough information to do any kind of precise
> calculation on airtime utilization by tx attempts. For instance, I don't
> get any information on how many frames in an A-MPDU were successfully
> transmitted on each retransmission attempt.

You mean the hardware interprets the block-ack and keeps retrying the
un-acked frames? I thought it stopped as soon as it got a block-ack to
let software sort out the acked and un-acked frames and handle the
"partial" A-MPDU retry.

> Software retries are being taken into account on some level, because a
> software retry is simply going to be part of the next A-MPDU, which will
> get accounted for in the rate control code.

If my guess on block-ack implementation is correctly there is still
have a major uncertainty: if the first frame in the A-MPDU is
transferred correctly but every other frame in the AMPDU fails (and
has to be retransmitted in other A-MPDUs) you run the risk of counting
that as a success (and of course wise-versa)...

> This early version will probably not make a fully optimal tradeoff
> between retransmission probability and raw throughput, but that can
> probably be tweaked over time, simply by adjusting the internal
> throughput metric calculation to something that gets close in practice
> at least most of the time.

I agree this new code is a big step forward and the aim here (with
this patch) should of course not be a fully optimal solution. But
shouldn't we try to at least set up a roadmap to remove as much as
possible of these fundamental flaws / uncertainties?

The reason I'm so interested in this subject is I've tried to tweak
the ath9k rate control to behave reasonably for me. This has taken a
lot of time and the result is rather poor. Also, these tweaks are not
general enough to even be contributed back as patches. My feeling is
that the reason it is so difficult to get a rate control algorithm to
work for all use-cases is that the underlying model is just plain
wrong. Radio environments are very varied and complex. Add to that all
the other variability, such as ANI dynamically adjusting radio chain
parameters and it's very very difficult to know what is "incorrect but
good enough".

/Björn
