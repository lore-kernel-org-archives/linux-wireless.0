Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:36514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726434AbeIFOGx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 10:06:53 -0400
Date: Thu, 6 Sep 2018 11:32:14 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: Re: mt76x0 bug report
Message-ID: <20180906093213.GB16539@redhat.com> (sfid-20180906_113221_002484_9BB980F0)
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2018 at 08:52:18PM +0000, Sid Hayn wrote:
> On Tue, Sep 4, 2018 at 5:11 PM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > >
> > > I have one mt76x2u (Alfa AWUS036ACM) and a few mt76x0.
> > >
> > > I've noticed two additional issues in my testing.
> > >
> > > First issue, is that it appears the mt76x0 devices don't work properly
> > > in monitor mode.  Sometimes they seem to monitor one channel properly,
> > > but nothing else.  The mt76x2u works great, channel control, lots of
> > > packets, etc.
> >
> > Could you elaborate a little bit please? how can you reproduce the issue?
> > just add an interface in monitor mode and run a scan?
> 
> Correct, standard stuff, use iw to create a monitor mode interface,
> use iw to remove managed mode interface, run some tool such as kismet
> or airodump-ng or even wireshark.

But what exactly are the syptomps, I don't understand what you mean by
"mt76x0 devices don't work properly in monitor mode" ?

> > I guess it depends on eeprom values. Could you please enable debug
> > messages a paste
> > syslog output?
> 
> I don't see a mediatek specific debug near the driver selection in
> menuconfig, what debug messages do you want me to enable and how?

You need to uncomment this line:

# ccflags-y := -DDEBUG

in drivers/net/wireless/mediatek/mt76/mt76x0/Makefile

Thanks
Stanislaw
