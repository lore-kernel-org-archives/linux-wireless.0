Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50585 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab2E0CG3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 22:06:29 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Message-ID: <20417.35821.91808.2702@gargle.gargle.HOWL> (sfid-20120527_040658_665773_66DA2D81)
Date: Sun, 27 May 2012 07:35:33 +0530
To: Adrian Chadd <adrian@freebsd.org>
CC: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
In-Reply-To: <CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> On 25 May 2012 20:17, Ben Greear <greearb@candelatech.com> wrote:
> > We've been doing some tests using Atheros stations and various APs.  The max
> > throughput
> > we've seen so far is about 237Mbps (received UDP payload on the stations).
> > (Open-Air, AP about 5 feet away, 3x3 MIMO, HT40, 5Ghz, etc).
> >
> > We are still running lots of different permutations, but I am interested if
> > anyone else has any numbers to share (official or otherwise).
> 
> FWIW, FreeBSD was getting 270MBit/sec one-way UDP and 150MBit one-way
> TCP out of AR9160/AR9280's late last year. I should re-run those tests
> again now that I've fixed a bunch of things and see if I've regressed.
> Those are 2T2R devices w/ a Routerstation Pro (AR7161) as the hostap.

270 Mbps with a 2-stream device ? That seems abnormally high. :)

> At that stage I was maxing out the AR7161 CPU quite badly and filling
> up all kinds of TX/RX paths, to the point that beacon transmission
> stopped being reliable. But I haven't really sat down and run
> performance measurements on MIPS so it's quite possible there's some
> inefficiencies in FreeBSD that I can work around (to reduce the CPU
> overhead, I was happy with the throughput.. :)
> 
> Sujith, would you mind testing out ath9k/openwrt on a DB120 and see if
> you can get the same results as our internal LSDK builds?

Odd. I get low numbers with a DB120 running OpenWRT (git HEAD).

TCP TX - ~260 Mbps.
TCP RX - ~160 Mbps.

UDP RX - ~240 Mbps.
UDP TX - iperf borks and doesn't display anything.

The load seems to be a bit high (average: 1.92, 1.06, 0.61 ) and the
console becomes laggy.

Maybe 
