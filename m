Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:42331 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752570AbaJ0MFQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 08:05:16 -0400
Message-ID: <544E34F7.6030404@openwrt.org> (sfid-20141027_130528_992012_6EF3F035)
Date: Mon, 27 Oct 2014 13:05:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Seongho Byeon <shbyeon@mwnl.snu.ac.kr>
CC: ath9k-devel <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] strange MPDU loss pattern
References: <544A7871.7020005@mailservices.uwaterloo.ca>	<CAJ-Vmon_jefxRgZvJmOsr4ydNHbvTCyMHHejRMWqXg_SG6NJUw@mail.gmail.com>	<544AB9B8.9050407@mailservices.uwaterloo.ca>	<CAJ-VmomYx1Dn5Oey1v4+8Yw7n0QkBiGKynFf_qNBD1JZb_Ra_A@mail.gmail.com>	<544BC1B5.1040107@mailservices.uwaterloo.ca>	<CAJ-Vmo=ceFvBDxL=HYSVmAMfEk0yxD_-a4MP3WjcvPAaupxPPw@mail.gmail.com>	<544C0995.8010507@mailservices.uwaterloo.ca> <CAETUFS8iDDcrPwu_NCV4Ks9Mq6KUjqdujVyyZ5Y6om=14J+B9g@mail.gmail.com>
In-Reply-To: <CAETUFS8iDDcrPwu_NCV4Ks9Mq6KUjqdujVyyZ5Y6om=14J+B9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seongho,

that paper looks quite interesting.
Are you planning to publish code/patches for your implementation as well?
It would be nice to have dynamic A-MPDU limiting integrated in minstrel_ht.

Thanks,

- Felix

On 26/10/2014 12:14 AM, Seongho Byeon wrote:
>
> Hi, I am Ph.d. student in Seoul National University , Korea.
> Recently, we have dealt with the problem you observe, and we published
> a paper into CoNEXT 2014 which is a major conference in our field.
>
> Title of the paper 'MoFa: Mobility-aware Frame Aggregation in WiFi
> networks'.
> You can download it a site below.
> http://www.mwnl.snu.ac.kr/~schoi/publication/Conferences/14-CONEXT-BYEON.pdf
> <http://www.mwnl.snu.ac.kr/%7Eschoi/publication/Conferences/14-CONEXT-BYEON.pdf>
> If you have a question please contact me anytime.
>
> Best regards,
> Seongho Byeon.
>
> Thank you for sharing the story.
> Even if I consider interference as a possibility, still I can't
> justify the higher
> chance of frame loss in the second half of the aggregate frame.
>
> We use
>
> PCI-express 3 antenna dual band cards
> product: AR93xx Wireless Network Adapter
> and/or
> Atheors AR5B97 which is a 2.4 GHz dual antenna internal card in a laptop
>
> we also tried TP-LINK TL-WDN4200 N900as the receiver.
>
> However we see the same results.
> we mostly use MCS 20-23, sgi = 0, 20 MHz channels.
>
> The loss pattern is something like this
> (each line is an imaginary aggregated frame and each bit is the fate
> of the MPDU)
>
> 11111111111100011000000000000
> 11111110001101011010000000000
> 11111000000000000000000000000
> 11111111111010100000000000000
> 11111100101010000000000000000
>
> The interesting part is that with the start of the next frame error
> rate goes down initially
> then it goes up again in the second portion of the packet.
>
> Best,
> Ali
>
>
> On 25/10/2014 2:30 PM, Adrian Chadd wrote:
>
>     On 25 October 2014 08:28, Ali Abedi<a2abedi@uwaterloo.ca>
>     <mailto:a2abedi@uwaterloo.ca>wrote:
>
>         Hi Adrian, We have a high end spectrum analyzer. So we are
>         sure there is no background interference We run our
>         experiments in the 5 GHZ spectrum. The channel conditions can
>         still vary due to the movement of the people in the vicinity
>         of the experiment setup. We select a rate that experiences at
>         least 20% error on average. Since if the error is 100% or 0%
>         it's not interesting for us. My point is if the channel
>         conditions change the distribution of failed packets should be
>         uniform. The first and second half of the packets have the
>         same chance to be received successfully.
>
>     Here's a little story. My first wifi contract had me spend months
>     trying to figure out why an AP was losing its mind. It'd get stuck
>     in a "stuck beacon" loop and only a hard powercycle of /all/ of
>     the access points in an area would clear it. It turned out that
>     the PCB design had some non-grounded / non-populated tracks that
>     just "happened" to form a 2GHz resonator. Once we grounded those
>     tracks, the APs started behaving themselves. The company in
>     question spent months with high end spectrum analysis kit in the
>     lab (where it never happened) and underground (where it did
>     happen.) It's only after they stuck the spectrum analyser probe
>     _inside the access point_ right up close to the NIC did they see
>     it. Here's the spectrum analyser traces. You can see the
>     peak.http://www.creative.net.au/ath/So, weirder crap has happened.
>     Which NICs and which MCS rates are you using? -adrian
>
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org <mailto:ath9k-devel@lists.ath9k.org>
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
>
