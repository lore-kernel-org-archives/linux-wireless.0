Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f172.google.com ([209.85.222.172]:38677 "EHLO
	mail-pz0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0AURSa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2010 12:18:30 -0500
Received: by pzk2 with SMTP id 2so139735pzk.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2010 09:18:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <b170af451001210750t123a94e2r833e075933c06752@mail.gmail.com>
References: <op.u6s09akf9lhzdc@linux-g0th.site> <1263982729.14538.5.camel@johannes.local>
	<b170af451001210750t123a94e2r833e075933c06752@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 21 Jan 2010 09:18:09 -0800
Message-ID: <43e72e891001210918m45039636j3d5963e83ae360eb@mail.gmail.com>
Subject: Re: [RFC] How to store HT (40MHz) support
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/21 Rafał Miłecki <zajec5@gmail.com>:
> W dniu 20 stycznia 2010 11:18 użytkownik Johannes Berg
> <johannes@sipsolutions.net> napisał:
>> On Wed, 2010-01-20 at 01:06 +0100, Rafał Miłecki wrote:
>>> +             phy->use_40mhz = conf_is_ht(conf);
>>
>> This is wrong, conf_is_ht might also be 20mhz, look at the other
>> helpers.
>
> I tried to understand what actually is HT and after reading many
> articles I have more knowledge but still I'm not 100% sure.
>
> AFAIU:
> 1) HT means using more than 1 stream in channel (and can be on any:
> 20MHz or 40MHz)

No, you can have single stream HT devices.

> 2) conf_is_ht(...) checks if mac80211 want us to use more than 1
> stream in channel

No, conf_is_ht() tells you whether or not the current device
configuration is set up to be on HT configuration.

> 3) conf_is_ht40_minus(...) checks if we should use frequency below
> current as additional 20MHz, so for example for channel 7 which is
> 2,431->2,453 we should use additinal 20MHz in channel 3 which is
> 2,411->2,433

Right it just means the secondary channel is on the lower part of the
primary, ht40_plus means its above.

> 4) conf_is_ht40_plus(...) checks if we should use frequency over
> current as additional 20MHz, so for example for channel 3 which is
> 2,411->2,433 we should use additinal 20MHz in channel 7 which is
> 2,431->2,453
>
> Is that correct?

Almost, may want to read this:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n

I hope that helps.

  Luis
