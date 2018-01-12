Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932740AbeALLXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Jan 2018 06:23:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 02/10] qtnfmac: pass complete channel data between driver and firmware
References: <20171113102815.11254-1-sergey.matyukevich.os@quantenna.com>
        <20171113102815.11254-3-sergey.matyukevich.os@quantenna.com>
        <87efoalfdo.fsf@purkki.adurom.net>
        <20171205162436.kf3dkvbeisfcs6sq@bars>
Date: Fri, 12 Jan 2018 13:23:20 +0200
In-Reply-To: <20171205162436.kf3dkvbeisfcs6sq@bars> (Sergey Matyukevich's
        message of "Tue, 5 Dec 2017 19:24:37 +0300")
Message-ID: <876087s4lz.fsf@kamboji.qca.qualcomm.com> (sfid-20180112_122329_547588_D358A86C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

>> > +/**
>> >   * struct qlink_chandef - qlink channel definition
>> >   *
>> > + * @chan: primary channel definition
>> >   * @center_freq1: center frequency of first segment
>> >   * @center_freq2: center frequency of second segment (80+80 only)
>> >   * @width: channel width, one of @enum qlink_channel_width
>> >   */
>> >  struct qlink_chandef {
>> > +     struct qlink_channel chan;
>> >       __le16 center_freq1;
>> >       __le16 center_freq2;
>> >       u8 width;
>> > -     u8 rsvd[3];
>> > +     u8 rsvd;
>> >  } __packed;
>> 
>> Doesn't this break backwards compatibility with the older firmware? The
>> basic princinple is that old firmware images continue to work with newer
>> driver (or there will be a firmware image with new name, eg. fw-2.bin).
>> You can check how iwlwifi does that.
>
> Yes, it breaks. That is why we increment qlink protocol version in each
> change affecting backwards compatibility. So driver is going to work only
> with matching firmware. This is a very simplistic approach, but it looks
> reasonable for current stage of development since we keep adding features.

Everyone are always adding new features, that's no excuse to break
backwards compatibility with user space. In the future you really need
to come up a way to handle the firmware interface breaks gracefully,
just like iwlwifi does.

Related to this, any progress on getting the firmware image to
linux-firmware?

-- 
Kalle Valo
