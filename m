Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:38602 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729397AbeIRItf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 04:49:35 -0400
Received: by mail-io1-f68.google.com with SMTP id y3-v6so368271ioc.5
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 20:19:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
 <20180906093213.GB16539@redhat.com> <CAM0KTbBRGqNAu1H0myVoWg6Qu1aMXMneSJ7bXQUKbJGZUFkC_A@mail.gmail.com>
 <CAJ0CqmXHHE2J5O4irPogrypL_H95EDm2y+1_6rpWG1v3ZHxzXA@mail.gmail.com>
 <CAM0KTbAF_ztZzFk_iECyPbiWY69xrcdT_93ypnuTzocjX_fRuQ@mail.gmail.com>
 <20180907082413.GC2725@localhost.localdomain> <CAM0KTbAputKNN3seOfN-1zhz5XmT6yg_pbKBnapOsR6Vigv1XQ@mail.gmail.com>
 <CAM0KTbAu-LJ2ThAHbmbrggMw_ttpQ8fXr0+HTjGBZF6PBPiD8Q@mail.gmail.com>
 <CAJ0CqmUDT44W7sb4qpmt6mPDZ5LwUDPgKCrhor_8POWpx_RaQA@mail.gmail.com> <CAM0KTbDb4X7JZgYZa6-NmjD72_UHOqQ43Czv=HwWS3D0WcWrgQ@mail.gmail.com>
In-Reply-To: <CAM0KTbDb4X7JZgYZa6-NmjD72_UHOqQ43Czv=HwWS3D0WcWrgQ@mail.gmail.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Mon, 17 Sep 2018 23:18:57 -0400
Message-ID: <CAM0KTbA0QE-5oTz-aeU9zmnCS-LrYZmHwmEv0afjR0yFWvTevA@mail.gmail.com> (sfid-20180918_051927_626137_93E8EEDE)
Subject: Re: mt76x0 bug report
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org, dcaratti@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 14, 2018 at 11:51 AM Sid Hayn <sidhayn@gmail.com> wrote:
>
> On Fri, Sep 14, 2018 at 11:47 AM Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:
> >
> > >
> > > *bump*
> > >
> > > Been a few days, just a reminder that your monitor mode patch fixed
> > > all channels below 144 but something appears incorrect in regdomain
> > > handling as I cannot get channels 144 or higher working (my main AP
> > > being on channel 149.  Again, this works on mt76x2u but not on mt76x0.
> > > The patch I tested doesn't appear to have landed in wireless-testing
> > > yet, so if you haven't, please do push that up.
> >
> > I have already sent the patch to linux-wireless ml
> > https://patchwork.kernel.org/patch/10592597/
>
> Excellent, thank you.  Is someone working on the channel/regdomain
> issue as well?
> >
> > >
> > > Secondarily, ethtool still doesn't report firmware version and that
> > > would be a very helpful thing to have before 4.19 hits.
> > >
> >
> > +Davide Caratti
>
> Thanks, saw his message and will watch for it to test.
> >
> > > Additionally, with much less severity, t1u still thinks it is dual
> > > band and I'm happy to run any command, test any patch, etc.  I
> > > honestly don't care about this at all short term, but it does slow the
> > > hardware down tuning to a bunch of channels which it cannot access so
> > > long term it should probably be fixed in some way.
> > >
> >
> > I am busy with other mt76 activities at the moment, I will look into
> > it as soon as I have time
>
> Listed third and we seem to agree this is a "as time allows" task.

Sorry to bump the one thing that we both agreed was low priority but....

So was testing all of my dongles that use the driver you are working
on, and running them through my connect scripts.  I moved the AP to
maybe <5ft from the clients and something wierd happened.  The t1u
tried to connect to one of the 2.4GHz only networks.  It failed, but
it actually got enough scan data back to attempt authentication with a
valid 2.4GHz only bssid.  Which means in short, that the eeprom isn't
lying and your parsing of it is correct.  Something obviously makes
this a 5GHz only device, as the connection failed and most of the time
nothing at all is seen on 2.4GHz, but clearly it's some filter or
antenna or some other mechanism which makes it 5GHz only.  So probably
hardware lying to you is now even lower on your list since this safely
rules out the driver parsing the eeprom incorrectly.

Thanks,
Zero
>
> Thanks for the prompt response.
>
> -Zero
> >
> > Regards,
> > Lorenzo
> >
> > > Thanks again for all your hard work, watching the mailing list it is
> > > obvious how much effort is going into this right now.
> > >
> > > -Zero
> > > On Fri, Sep 7, 2018 at 3:55 PM Sid Hayn <sidhayn@gmail.com> wrote:
> > > >
> > > > On Fri, Sep 7, 2018 at 4:24 AM Lorenzo Bianconi
> > > > <lorenzo.bianconi@redhat.com> wrote:
> > > > >
> > > > > > Actions like that have caused great problems in the past, as the
> > > > > > kernel won't allow channel control of a monitor interface at all when
> > > > > > there is a managed interface on the same phy (afaik).
> > > > > >
> > > > > > But just for fun and codepath testing here are two test scenarios:
> > > > > >
> > > > > > Test 1: "iwconfig t2u mode monitor"
> > > > > > Sees nothing on any channel, no packets reported
> > > > > >
> > > > > > Test 2(requested test): "iw phy phy11 interface add t2uhmon type monitor"
> > > > > > Sees nothing on any channel, no packets reported.
> > > > > > Despite having a monitor and managed interface on the same phy,
> > > > > > iwconfig is reporting that the channel is changing as requested.  So
> > > > > > perhaps my above "afaik" comment is partially outdated.
> > > > > >
> > > > > > For both tests the interface was not used to connect to any ap prior
> > > > > > to or during testing.
> > > > > >
> > > > >
> > > > > Could you please try following patch?
> > > >
> > > > Excellent!  This seems to work for all channels up to 140, however,
> > > > not 144 or above.  "iw list" shows these are supported but I cannot
> > > > set them in monitor mode:
> > > >
> > > > * 5720 MHz [144] (22.0 dBm) (no IR, radar detection)
> > > > * 5745 MHz [149] (22.0 dBm) (no IR)
> > > > * 5765 MHz [153] (22.0 dBm) (no IR)
> > > > * 5785 MHz [157] (22.0 dBm) (no IR)
> > > > * 5805 MHz [161] (22.0 dBm) (no IR)
> > > > * 5825 MHz [165] (22.0 dBm) (no IR)
> > > >
> > > > remote2 ~ # iw dev t2uhmon set channel 140
> > > > remote2 ~ # iw dev t2uhmon set channel 144
> > > > command failed: Invalid argument (-22)
> > > >
> > > > Thanks,
> > > > Zero
> > > >
> > > > > Regards,
> > > > >
> > > > > Lorenzo
> > > > >
> > > > > --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > > > > +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> > > > > @@ -756,11 +756,10 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
> > > > >
> > > > >         /* Vendor driver don't do it */
> > > > >         /* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
> > > > > +       mt76x0_vco_cal(dev, channel);
> > > > >
> > > > >         if (scan)
> > > > > -               mt76x0_vco_cal(dev, channel);
> > > > > -
> > > > > -       mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
> > > > > +               mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
> > > > >         mt76x0_phy_set_chan_pwr(dev, channel);
> > > > >
> > > > >         dev->mt76.chandef = *chandef;
