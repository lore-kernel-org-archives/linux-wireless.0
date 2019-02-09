Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA70EC282CB
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 17:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2B4D2192D
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 17:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbfBIR2l (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 12:28:41 -0500
Received: from fudo.makrotopia.org ([185.142.180.71]:39800 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbfBIR2l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 12:28:41 -0500
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.91)
        (envelope-from <daniel@makrotopia.org>)
        id 1gsWQb-0001LL-QE; Sat, 09 Feb 2019 18:28:35 +0100
Date:   Sat, 9 Feb 2019 18:28:25 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
Message-ID: <20190209172825.GB19297@makrotopia.org>
References: <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com>
 <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com>
 <20190209110259.GA14900@redhat.com>
 <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
 <20190209115628.GA16082@redhat.com>
 <CAKR_QVJtQdRcbRMV+WDKw=N2CxLhUSo6hE8mUME2orD6JEMAmQ@mail.gmail.com>
 <20190209153850.GA19297@makrotopia.org>
 <CAKR_QVJXaYyy64BBj0qz7-Rua70nKGTypV7uiysCqyR=jG_Adw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKR_QVJXaYyy64BBj0qz7-Rua70nKGTypV7uiysCqyR=jG_Adw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Tom,

On Sat, Feb 09, 2019 at 05:29:33PM +0100, Tom Psyborg wrote:
> On 09/02/2019, Daniel Golle <daniel@makrotopia.org> wrote:
> > Hi Tom,
> >
> > On Sat, Feb 09, 2019 at 01:28:32PM +0100, Tom Psyborg wrote:
> >> On 09/02/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> > On Sat, Feb 09, 2019 at 12:11:03PM +0100, Tom Psyborg wrote:
> >> >> Can you reproduce interface freeze with this patch if you enable debug
> >> >> options to print all dbg messages?
> >> >
> >> > Haven't tried that, but I expect enabling debug messages will
> >> > cause troubles at hardware where printk make CPU hog.
> >> >
> >> > Stanislaw
> >> >
> >>
> >> Take a look at my comment from 23.01.2019. on this link:
> >> https://bugs.openwrt.org/index.php?do=details&task_id=2018
> >> There might be a chance dbg printks do not cause problems.
> >
> > This is very likely just overheat because of missing TSSI. It happends
> > on boards where MT7620A is used without heatsink (and easy to
> > reproduce, I've tried. We just need TSSI and for bad board design it
> > will mean limiting to one TX-queue soon after serious traffic starts).
> > We should tell those users to glue heatsink on the chip for $0.05 they
> > can fix this in hardware -- and implement TSSI to mitigate at least the
> > very worst effects (such as hardware stuck until reset).
> > So dkg printks can make this worse, of course, because logging overhead
> > also burns CPU cycles and increases system load.
> >
> > I remember in Rt5350 (and other predecessors of Rt6352 aka. MT7620)
> > also had problems like that and it was possible to improve it by all
> > sorts of things like removing power from unused ports of the Ethernet
> > switch -- so for those boards (like Xiaomi MiWiFi mini) even this maybe
> > the trick, because they also only use 3 out of 5 ports, and maybe we
> > need to try harder to disable the power of unused ports (and also those
> > without cable plugged in only periodicly power them up and check for
> > link)....
> >
> > Cheers
> >
> > Daniel
> >
> 
> Disagree. MT7620 in Xiaomi MiWiFi mini has thermal pad sticked to
> enough large metal shielding that is sticked with another thermal pad
> to even bigger metal part of case. So thermal dissipation in that case
> is very good.

Good to hear that, and yes it may still be, see below.

> Also with pandorabox firmware 200Mbps of stable throughput is possible

>20MiB/s download rate is very impressive for 2.4GHz WiFi, I never saw
anything even near that (using BitTorrent I get up to 8MiB/s when next
to the router in low-noise environment with proprietry ubiquiti gear).

> without any throttling which I believe would not be the case if the
> cooling system wasn't reliable.

pandorabox uses MediaTek proprietary driver and that limits to single
TX chain operation once temperature limit is hit (read the code, you
know where), same as in Xiaomi proprietary firmware.

> 
> Back on subject, this patch is tested and proven to work, so ACK from me.

Thanks for testing. I will push Stanislavs complete series into OpenWrt
tomorrow.


Cheers


Daniel
