Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:51050 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab1JVGDD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Oct 2011 02:03:03 -0400
Received: by yxl42 with SMTP id 42so1896028yxl.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Oct 2011 23:03:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2764633066252075767@unknownmsgid>
References: <2764633066252075767@unknownmsgid>
Date: Sat, 22 Oct 2011 14:03:01 +0800
Message-ID: <CAJ-VmokUpC82BBJq9_vcyn9vPA_-0txvCR9_xo=JfkA5jLaaPA@mail.gmail.com> (sfid-20111022_080336_229797_31B2B78E)
Subject: Re: Any wireless cards with this debug capability?
From: Adrian Chadd <adrian@freebsd.org>
To: George Nychis <gnychis@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Eric Rozner <erozner@cs.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 October 2011 05:09, George Nychis <gnychis@gmail.com> wrote:
> We are finding that under certain scenarios, various WiFi cards
> (Atheros, Intel, ...) fail to decode incoming packets for certain
> periods of time on the order of 5->20ms. We are trying to enable a
> low-latency wireless link in which losses during this window break our
> requirement. A retransmission would essentially be too late.
>
> During this period, we are trying to determine the reason for loss.
> Whether it is fading, improper tuning of AGC, failure to account for
> frequency offset, etc. Ideally, what we would like to know is whether
> the card *tried* to acquire the carrier and if so, where it failed. I
> have noticed several Atheros kernel debug counters which show things
> such as a PHY error, but it's not clear at what stage it failed.

If you're not doing stupidly-high RX throughput, you could enable PHY
errors on the Atheros NICs instead of Just relying on the counters.
That way you can get reason values for the failed RX frames.

It may not be the -exact- reason (having the AGC get upset at you for
20ms? That seems a bit unlikely, considering how quick it needs to
adjust at the beginning of every RX'ed signal that may be a data
frame..) but it could be something like ANI interfering with RX.
There's been at least one reproducable report of that occuring w/
ath9k + AR5416 however I've not seen it happen on my FreeBSD/Linux
setups. For atheros, it could also be the periodic calibration code
kicking in.

I'd start by enabling PHY errors and watching the values of counters
whenever the error condition occurs. Under FreeBSD the 'athstats' tool
(and all the data exported by the HAL and driver) has allowed me to
leverage some basic correlational techniques to find/fix issues. You
may be able to do the same with a bit of hackery and the debugfs
export of these counters with ath5k/ath9k.

I think you can also enable receiving frames which fail the CRC check.
I forget if that is enabled by default.


Adrian
