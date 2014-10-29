Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44671 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619AbaJ2UeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 16:34:08 -0400
Received: by mail-wi0-f176.google.com with SMTP id h11so2783174wiw.15
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 13:34:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544C0995.8010507@mailservices.uwaterloo.ca>
References: <544A7871.7020005@mailservices.uwaterloo.ca>
	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>
	<544AB9B8.9050407@mailservices.uwaterloo.ca>
	<CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>
	<544BC1B5.1040107@mailservices.uwaterloo.ca>
	<CAJ-Vmo=ceFvBDxL=HYSVmAMfEk0yxD_-a4MP3WjcvPAaupxPPw@mail.gmail.com>
	<544C0995.8010507@mailservices.uwaterloo.ca>
Date: Wed, 29 Oct 2014 13:34:07 -0700
Message-ID: <CAJ-VmonTjXvqPs2APB90pNgRyKwxPE2BJk+jxFGbLGw9uK2xHw@mail.gmail.com> (sfid-20141029_213412_432152_A9967A66)
Subject: Re: strange MPDU loss pattern
From: Adrian Chadd <adrian@freebsd.org>
To: Ali Abedi <a2abedi@uwaterloo.ca>
Cc: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just finally -

MCS20 -> MCS23 are very sensitive to changing channel anything. See if
you can find or make some required SNR curves for each MCS rate.

So although it doesn't surprise me to find this is happening, it's
very cute that someone's gone and done the work of figuring out how to
improve the rate control algorithm to take it into account. I'm kinda
thinking about how to do that with FreeBSD right now.

Do you get the same pattern on say, MCS0->MCS4 over a 4ms long aggregate frame?


-adrian

On 25 October 2014 13:35, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
> Thank you for sharing the story.
> Even if I consider interference as a possibility, still I can't justify the
> higher
> chance of frame loss in the second half of the aggregate frame.
>
> We use
>
> PCI-express 3 antenna dual band cards
> product: AR93xx Wireless Network Adapter
> and/or
> Atheors AR5B97 which is a 2.4 GHz dual antenna internal card in a laptop
>
> we also tried TP-LINK TL-WDN4200 N900 as the receiver.
>
> However we see the same results.
> we mostly use MCS 20-23, sgi = 0, 20 MHz channels.
>
> The loss pattern is something like this
> (each line is an imaginary aggregated frame and each bit is the fate of the
> MPDU)
>
> 11111111111100011000000000000
> 11111110001101011010000000000
> 11111000000000000000000000000
> 11111111111010100000000000000
> 11111100101010000000000000000
>
> The interesting part is that with the start of the next frame error rate
> goes down initially
> then it goes up again in the second portion of the packet.
>
> Best,
> Ali
>
>
>
>
>
> On 25/10/2014 2:30 PM, Adrian Chadd wrote:
>
> On 25 October 2014 08:28, Ali Abedi <a2abedi@uwaterloo.ca> wrote:
>
> Hi Adrian,
>
> We have a high end spectrum analyzer. So we are sure there is no background
> interference
> We run our experiments in the 5 GHZ spectrum. The channel conditions can
> still vary due to
> the movement of the people in the vicinity of the experiment setup. We
> select a rate that
> experiences at least 20% error on average. Since if the error is 100% or 0%
> it's not interesting
> for us.
>
> My point is if the channel conditions change the distribution of failed
> packets should be uniform.
> The first and second  half of the packets have the same chance to be
> received successfully.
>
> Here's a little story.
>
> My first wifi contract had me spend months trying to figure out why an
> AP was losing its mind. It'd get stuck in a "stuck beacon" loop and
> only a hard powercycle of /all/ of the access points in an area would
> clear it.
>
> It turned out that the PCB design had some non-grounded /
> non-populated tracks that just "happened" to form a 2GHz resonator.
> Once we grounded those tracks, the APs started behaving themselves.
>
> The company in question spent months with high end spectrum analysis
> kit in the lab (where it never happened) and underground (where it did
> happen.) It's only after they stuck the spectrum analyser probe
> _inside the access point_ right up close to the NIC did they see it.
>
> Here's the spectrum analyser traces. You can see the peak.
>
> http://www.creative.net.au/ath/
>
> So, weirder crap has happened.
>
> Which NICs and which MCS rates are you using?
>
>
>
> -adrian
>
>
