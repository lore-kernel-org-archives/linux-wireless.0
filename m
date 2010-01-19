Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:62447 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754770Ab0ASRjV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 12:39:21 -0500
Received: by pzk28 with SMTP id 28so134246pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 09:39:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263762351.28067.21.camel@johannes.local>
References: <4B536B05.6070301@openwrt.org> <1263758236.28067.11.camel@johannes.local>
	<1263758423.28067.12.camel@johannes.local> <4B536F21.1090509@openwrt.org>
	<1263759278.28067.13.camel@johannes.local> <4B5371C3.6060504@openwrt.org>
	<1263761294.28067.14.camel@johannes.local> <4B537A94.9070807@openwrt.org>
	<1263762351.28067.21.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 09:39:01 -0800
Message-ID: <43e72e891001190939t38c07b31r7c64908bb485f03@mail.gmail.com>
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the operating
	frequency and export it through nl80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 17, 2010 at 1:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2010-01-17 at 22:01 +0100, Felix Fietkau wrote:
>
>> > But like I said, you already have that information in the relevant
>> > cases. hostapd you can just look in the config file for it...
>
>> Nope, hostapd can deviate from the config, e.g. in the HT40 case.
>> It'll
>> switch primary and secondary channel, if necessary, or switch from
>> HT40
>> to HT20 entirely if there are overlapping BSSs. And what about STA
>> mode?
>> The channel won't be in the config in that case.
>
> In STA and IBSS modes you already have the information from the BSS
> info.
>
> The channel type might be more interesting, but even then
>
>> > The problem with this is that not all drivers will be able to
>> support
>> > it, and that you will be exporting stale information say in the case
>> > where we're not connected at all.
>> If we document the exported channel for the netdev as 'last configured
>> channel', it should be fine, IMHO.
>
> I really don't think we should do that. And it will not be possible to
> ever have iwm/rndis/orinoco etc. export such information.
>
> In any case I have a feeling you're trying to use the kernel as a
> database for something you already know, just don't have quite as
> readily available as you'd like.

So a good use case is when we do automatic channel selection for AP
mode of operation. We currently don't support that on hostapd but
eventually we could and IMHO should. How we go about it remains to be
seen but querying the actual channel used by an 802.11 device is
useful in those cases. You can get that information by looking at
hostapd logs but that seems overkill.

  Luis
