Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38254 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbeIFUQI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 16:16:08 -0400
Received: by mail-it0-f45.google.com with SMTP id p129-v6so14848151ite.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 08:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com> <20180906093213.GB16539@redhat.com>
In-Reply-To: <20180906093213.GB16539@redhat.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Thu, 6 Sep 2018 15:39:52 +0000
Message-ID: <CAM0KTbBRGqNAu1H0myVoWg6Qu1aMXMneSJ7bXQUKbJGZUFkC_A@mail.gmail.com> (sfid-20180906_174006_190248_FDE064E5)
Subject: Re: mt76x0 bug report
To: sgruszka@redhat.com
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 6, 2018 at 5:32 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Wed, Sep 05, 2018 at 08:52:18PM +0000, Sid Hayn wrote:
> > On Tue, Sep 4, 2018 at 5:11 PM Lorenzo Bianconi
> > <lorenzo.bianconi@redhat.com> wrote:
> > >
> > > >
> > > > I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
> > > >
> > > > I've noticed two additional issues in my testing.
> > > >
> > > > First issue, is that it appears the mt76x0 devices don't work properly
> > > > in monitor mode.  Sometimes they seem to monitor one channel properly,
> > > > but nothing else.  The mt76x2u works great, channel control, lots of
> > > > packets, etc.
> > >
> > > Could you elaborate a little bit please? how can you reproduce the issue?
> > > just add an interface in monitor mode and run a scan?
> >
> > Correct, standard stuff, use iw to create a monitor mode interface,
> > use iw to remove managed mode interface, run some tool such as kismet
> > or airodump-ng or even wireshark.
>
> But what exactly are the syptomps, I don't understand what you mean by
> "mt76x0 devices don't work properly in monitor mode" ?

Basically, when I put a device using mt76x0 into monitor mode (adding
a monitor interface with iw and removing the managed interface) it
will not report packets on any channel, or sometimes it will report
packets on one channel but not any others.  I can switch channels as
much, for example hopping channel 1-11, but it will only see packets
on channel 7 and report no other packets on any other channels.  In my
actual test case it was channel 44 that successfully reported packets,
but even that mostly doesn't work.  I suspect the reason it reported
packets on channel 44 in one of my tests is because the channel was
set to 44 while in managed mode (connected to an AP).  If I put the
device in monitor mode before connecting to any AP, it reports packets
on no channels.  As such, I'm suspecting this has something to do with
channel control in monitor mode.
>
> > > I guess it depends on eeprom values. Could you please enable debug
> > > messages a paste
> > > syslog output?
> >
> > I don't see a mediatek specific debug near the driver selection in
> > menuconfig, what debug messages do you want me to enable and how?
>
> You need to uncomment this line:
>
> # ccflags-y := -DDEBUG
>
> in drivers/net/wireless/mediatek/mt76/mt76x0/Makefile

found it.  this box takes a few min to rebuild a kernel, so I'll get
back with this response later today hopefully.

Thanks,
Zero
>
> Thanks
> Stanislaw
>
