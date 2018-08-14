Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44013 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729230AbeHNCxU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 22:53:20 -0400
Received: by mail-lj1-f196.google.com with SMTP id r13-v6so13958470ljg.10
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 17:08:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180813224041.GA165278@ban.mtv.corp.google.com>
References: <CAH9jq_Ow7Gt-m1QZoS3-JOEdU1CkC33S2mCfYz4bHNOMDX+q9A@mail.gmail.com>
 <20180813224041.GA165278@ban.mtv.corp.google.com>
From: Tomasz Kalbarczyk <tkalbar@utexas.edu>
Date: Mon, 13 Aug 2018 20:08:22 -0400
Message-ID: <CAH9jq_P1V_LPm-47tZyQBm6wyP5WFJ3w8GFk840VzduOB_CugQ@mail.gmail.com> (sfid-20180814_020848_378363_9C85F66F)
Subject: Re: Promiscuous (not monitor) Mode support for ath10k
To: Brian Norris <computersforpeace@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the info, Brian! This is unfortunate. Coincidentally, I
came across this commit earlier today...I=E2=80=99ll see what I can do abou=
t
undoing the changes in my kernel or at least making the necessary
changes to prevent the driver from filtering non-multicast packets
addressed to other destinations.

Best,
Tomasz


On Mon, Aug 13, 2018 at 6:40 PM, Brian Norris
<computersforpeace@gmail.com> wrote:
>
> On Mon, Aug 06, 2018 at 06:08:46PM -0400, Tomasz Kalbarczyk wrote:
> > Hello,
>
> Hi!
>
> > I have a QCA6174 and I'm running tcpdump on the wireless interface to
> > listen for packets. I can receive packets addressed directly to the
> > device, but not any other packets on the network.
> >
> > Does anyone know the status of promiscuous mode support on ath10k?
> > Note that this is different from monitor mode / supported on a larger
> > subset of hardware. Dmesg merely indicates that the device has
> > "entered promiscuous mode" when tcpdump is initiated.
> >
> > Here is a link to similar discussion regarding the ath9k a few years
> > back: https://marc.info/?l=3Dlinux-wireless&m=3D135936563626791&w=3D2
>
> This might be relevant:
>
> commit df1404650ccbfeb76a84f301f22316be0d00a864
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Apr 22 14:40:58 2015 +0200
>
>     mac80211: remove support for IFF_PROMISC
>
>     This support is essentially useless as typically networks are encrypt=
ed,
>     frames will be filtered by hardware, and rate scaling will be done wi=
th
>     the intended recipient in mind. For real monitoring of the network, t=
he
>     monitor mode support should be used instead.
>
>     Removing it removes a lot of corner cases.
>
> Regards,
> Brian
