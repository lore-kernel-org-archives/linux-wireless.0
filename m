Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io1-f67.google.com ([209.85.166.67]:38109 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbeIHAiM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Sep 2018 20:38:12 -0400
Received: by mail-io1-f67.google.com with SMTP id y3-v6so2450909ioc.5
        for <linux-wireless@vger.kernel.org>; Fri, 07 Sep 2018 12:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0KTbBJuhuEyuZB_z_BcDSeXa-CJ+NwupssS2jLx0pJ0KXQGQ@mail.gmail.com>
 <CAJ0CqmWAqdB8Og7fabLDeZnzFO5Aw5Qd0cYGaLrs7Ls-zM_yQw@mail.gmail.com>
 <CAM0KTbAbjDYNOzivxMdLmYrV9QHgwkLp7zXpdCvn1Kf1uEcQTQ@mail.gmail.com>
 <20180906093213.GB16539@redhat.com> <CAM0KTbBRGqNAu1H0myVoWg6Qu1aMXMneSJ7bXQUKbJGZUFkC_A@mail.gmail.com>
 <CAJ0CqmXHHE2J5O4irPogrypL_H95EDm2y+1_6rpWG1v3ZHxzXA@mail.gmail.com>
 <CAM0KTbAF_ztZzFk_iECyPbiWY69xrcdT_93ypnuTzocjX_fRuQ@mail.gmail.com> <20180907082413.GC2725@localhost.localdomain>
In-Reply-To: <20180907082413.GC2725@localhost.localdomain>
From: Sid Hayn <sidhayn@gmail.com>
Date: Fri, 7 Sep 2018 19:55:33 +0000
Message-ID: <CAM0KTbAputKNN3seOfN-1zhz5XmT6yg_pbKBnapOsR6Vigv1XQ@mail.gmail.com> (sfid-20180907_215546_345039_39C7BC03)
Subject: Re: mt76x0 bug report
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 7, 2018 at 4:24 AM Lorenzo Bianconi
<lorenzo.bianconi@redhat.com> wrote:
>
> > Actions like that have caused great problems in the past, as the
> > kernel won't allow channel control of a monitor interface at all when
> > there is a managed interface on the same phy (afaik).
> >
> > But just for fun and codepath testing here are two test scenarios:
> >
> > Test 1: "iwconfig t2u mode monitor"
> > Sees nothing on any channel, no packets reported
> >
> > Test 2(requested test): "iw phy phy11 interface add t2uhmon type monitor"
> > Sees nothing on any channel, no packets reported.
> > Despite having a monitor and managed interface on the same phy,
> > iwconfig is reporting that the channel is changing as requested.  So
> > perhaps my above "afaik" comment is partially outdated.
> >
> > For both tests the interface was not used to connect to any ap prior
> > to or during testing.
> >
>
> Could you please try following patch?

Excellent!  This seems to work for all channels up to 140, however,
not 144 or above.  "iw list" shows these are supported but I cannot
set them in monitor mode:

* 5720 MHz [144] (22.0 dBm) (no IR, radar detection)
* 5745 MHz [149] (22.0 dBm) (no IR)
* 5765 MHz [153] (22.0 dBm) (no IR)
* 5785 MHz [157] (22.0 dBm) (no IR)
* 5805 MHz [161] (22.0 dBm) (no IR)
* 5825 MHz [165] (22.0 dBm) (no IR)

remote2 ~ # iw dev t2uhmon set channel 140
remote2 ~ # iw dev t2uhmon set channel 144
command failed: Invalid argument (-22)

Thanks,
Zero

> Regards,
>
> Lorenzo
>
> --- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
> @@ -756,11 +756,10 @@ __mt76x0_phy_set_channel(struct mt76x0_dev *dev,
>
>         /* Vendor driver don't do it */
>         /* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
> +       mt76x0_vco_cal(dev, channel);
>
>         if (scan)
> -               mt76x0_vco_cal(dev, channel);
> -
> -       mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
> +               mt76x0_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1);
>         mt76x0_phy_set_chan_pwr(dev, channel);
>
>         dev->mt76.chandef = *chandef;
