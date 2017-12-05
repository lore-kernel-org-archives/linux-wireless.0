Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0053.outbound.protection.outlook.com ([104.47.34.53]:16736
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752242AbdLEQYw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 5 Dec 2017 11:24:52 -0500
Date: Tue, 5 Dec 2017 19:24:37 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 02/10] qtnfmac: pass complete channel data between driver
 and firmware
Message-ID: <20171205162436.kf3dkvbeisfcs6sq@bars> (sfid-20171205_172458_022543_3E2EF426)
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
 <20171113102815.11254-3-sergey.matyukevich.os@quantenna.com>
 <87efoalfdo.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87efoalfdo.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> > Center frequency is not enough to describe the channel in HT and VHT
> > modes. For 40MHz and 80MHz channels both primary channel and center
> > frequency should be specified in order to qualify channel completely.
> > This change adds primary channel info into qlink_chandef structure.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> [...]
> 
> > +/**
> >   * struct qlink_chandef - qlink channel definition
> >   *
> > + * @chan: primary channel definition
> >   * @center_freq1: center frequency of first segment
> >   * @center_freq2: center frequency of second segment (80+80 only)
> >   * @width: channel width, one of @enum qlink_channel_width
> >   */
> >  struct qlink_chandef {
> > +     struct qlink_channel chan;
> >       __le16 center_freq1;
> >       __le16 center_freq2;
> >       u8 width;
> > -     u8 rsvd[3];
> > +     u8 rsvd;
> >  } __packed;
> 
> Doesn't this break backwards compatibility with the older firmware? The
> basic princinple is that old firmware images continue to work with newer
> driver (or there will be a firmware image with new name, eg. fw-2.bin).
> You can check how iwlwifi does that.

Yes, it breaks. That is why we increment qlink protocol version in each
change affecting backwards compatibility. So driver is going to work only
with matching firmware. This is a very simplistic approach, but it looks
reasonable for current stage of development since we keep adding features.

> As this is a new driver I guess it doesn't matter that much to break it,
> but please keep this in mind in the future.

Sure, we keep that in mind. Though we haven't settled on any
specific approach so far.

Regards,
Sergey
