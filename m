Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:63539 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaKYLKp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2014 06:10:45 -0500
Received: by mail-pa0-f43.google.com with SMTP id kx10so396842pab.2
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2014 03:10:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416913453.2045.4.camel@sipsolutions.net>
References: <1416911009-22405-1-git-send-email-johannes@sipsolutions.net>
	<CAFuUQkh-fX3rz9+FUBfF8GxbkxrZxP7-iJwmypo5EEANwODqzQ@mail.gmail.com>
	<1416913453.2045.4.camel@sipsolutions.net>
Date: Tue, 25 Nov 2014 19:10:44 +0800
Message-ID: <CAFuUQkhuUDVcfv-pxLkhNT7C2TOqOS4nh+3qDj0uFV3OpoAS5w@mail.gmail.com> (sfid-20141125_121049_444506_F480B745)
Subject: Re: [PATCH] mac80211: check if channels allow 80 MHz for VHT probe requests
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 25, 2014 at 7:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2014-11-25 at 19:00 +0800, YanBo wrote:
>> On Tue, Nov 25, 2014 at 6:23 PM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > If there are no channels allowing 80 MHz to be used, then the
>> > station isn't really VHT capable even if the driver and device
>> > support it in general. In this case, exclude the VHT capability
>> > IE from probe request frames.
>> >
>>
>> FYI, there are some new devices could support the VHT even at 20Mhz
>> band 2.4G mode.
>
> So in 2.4 GHz we typically don't have VHT anyway - and realistically you
> can't support real "VHT" there, you can only support the new
> modulations. I think this will require some custom (vendor-specific)
> advertisement though, since VHT advertisement implies 80 MHz support.
>
> IOW, I think at this point this patch isn't a problem. If we really need
> to support VHT modulations in 2.4 GHz (or even have devices that have
> VHT modulation support, but no 80 MHz support in 5 GHz) then some new
> advertisement will have to be done.
>
We already start the working to support the VHT modulations MCS8 and
MCS9 support in 2.4G for ath10k  devices,
and it used the band->vht_cap = vht_cap to notification the mac80211,
if we band it with 80MHz, it is do need another
new advertisement for this as your said.

Thanks
BR /Yanbo
