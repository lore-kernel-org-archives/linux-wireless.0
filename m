Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0050.outbound.protection.outlook.com ([104.47.38.50]:25792
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932533AbeAOJ5B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 04:57:01 -0500
Date: Mon, 15 Jan 2018 12:56:47 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 02/10] qtnfmac: pass complete channel data between driver
 and firmware
Message-ID: <20180115095646.wvx4ekoqkvvapiyn@bars> (sfid-20180115_105706_469981_DA1175FF)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-3-sergey.matyukevich.os@quantenna.com>
 <87efoalfdo.fsf@purkki.adurom.net>
 <20171205162436.kf3dkvbeisfcs6sq@bars>
 <876087s4lz.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <876087s4lz.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> >> > +/**
> >> >   * struct qlink_chandef - qlink channel definition
> >> >   *
> >> > + * @chan: primary channel definition
> >> >   * @center_freq1: center frequency of first segment
> >> >   * @center_freq2: center frequency of second segment (80+80 only)
> >> >   * @width: channel width, one of @enum qlink_channel_width
> >> >   */
> >> >  struct qlink_chandef {
> >> > +     struct qlink_channel chan;
> >> >       __le16 center_freq1;
> >> >       __le16 center_freq2;
> >> >       u8 width;
> >> > -     u8 rsvd[3];
> >> > +     u8 rsvd;
> >> >  } __packed;
> >>
> >> Doesn't this break backwards compatibility with the older firmware? The
> >> basic princinple is that old firmware images continue to work with newer
> >> driver (or there will be a firmware image with new name, eg. fw-2.bin).
> >> You can check how iwlwifi does that.
> >
> > Yes, it breaks. That is why we increment qlink protocol version in each
> > change affecting backwards compatibility. So driver is going to work only
> > with matching firmware. This is a very simplistic approach, but it looks
> > reasonable for current stage of development since we keep adding features.
> 
> Everyone are always adding new features, that's no excuse to break
> backwards compatibility with user space. In the future you really need
> to come up a way to handle the firmware interface breaks gracefully,
> just like iwlwifi does.
> 
> Related to this, any progress on getting the firmware image to
> linux-firmware?

Here is a brief status. In our case, one of the SoC cores runs Linux, so we
have to accompany firmware image with SDK containing all the GPL components.
SDK is not appropriate for linux-firmware repository. That is why the plan
is to make SDK accessible via Quantenna github or website, and then
to get the firmware image to linux-firmware repository. Actually, firmware
image can be submitted any time. But our understanding is that SDK should be
released prior to the next attempt to submit firmware image. So currently
the work is ongoing on making SDK fully GPL compliant, e.g. sorting out
licensing of 3rd party modules.

Regards,
Sergey
