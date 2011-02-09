Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38902 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813Ab1BIVzs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 16:55:48 -0500
Received: by qyk12 with SMTP id 12so551489qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 13:55:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297285438.11767.28.camel@dev.znau.edu.ua>
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	<1297262089.18053.24.camel@dev.znau.edu.ua>
	<AANLkTinC+ijSG=qzzk9OWLGRLsxM0dm12YkERxKbwg6t@mail.gmail.com>
	<1297285438.11767.28.camel@dev.znau.edu.ua>
Date: Wed, 9 Feb 2011 22:55:48 +0100
Message-ID: <AANLkTi=4TTXEQf-ECRBQTBqv-K5u+9yMke88vpwgrmnG@mail.gmail.com>
Subject: Re: SSB AI support code ([RFC4/11] SSB core control and state device ops)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 9 lutego 2011 22:03 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
>
> В Срд, 09/02/2011 в 21:35 +0100, Rafał Miłecki пишет:
>> 2011/2/9 George Kashperko <george@znau.edu.ua>:
>> > From: George Kashperko <george@znau.edu.ua>
>> >
>> > Introduce handlers for SB core control and state flags' management. SB-style
>> > buses provide access to these flags at two high octets of TMSLOW and TMSHIGH
>> > registers whereas AI-ones implement these flags in two low octets of IOCTRL
>> > and IOSTAT registers.
>> > Signed-off-by: George Kashperko <george@znau.edu.ua>
>> > ---
>> >  drivers/ssb/main.c      |   36 ++++++++++++++++++++++++++++++++++++
>> >  include/linux/ssb/ssb.h |   14 +++++++++++++-
>> >  2 files changed, 49 insertions(+), 1 deletion(-)
>> > --- linux-next-20110203.orig/drivers/ssb/main.c 2011-02-07 16:58:50.000000000 +0200
>> > +++ linux-next-20110203/drivers/ssb/main.c      2011-02-07 17:07:11.000000000 +0200
>> > @@ -1350,6 +1350,40 @@ static u32 ssb_admatch_size_sb(struct ss
>> >        return size;
>> >  }
>> >
>> > +static void ssb_core_ctl_flags_sb(struct ssb_device *dev, u32 mask,
>> > +                                 u32 val, u32 *res)
>> > +{
>> > +       u32 tmp;
>> > +
>> > +       if (mask || val) {
>> > +               tmp = (ssb_read32(dev, SSB_TMSLOW) & ~mask) | val;
>> > +               ssb_write32(dev, SSB_TMSLOW, tmp);
>> > +       }
>>
>> Are you going to use that function for just reading SSB_TMSLOW? Why
>> won't you use separated function then? Do you need separated function
>> for sth so simple as "ssb_read32(dev, SSB_TMSLOW);" at all?
> Will answer your question with another question ;)
> What would you personally prefer (press "1" or "2" :p)?
> 1)
> if (sb_bus)
>        ssb_write32(dev, (ssb_read32(dev, SSB_TMSLOW) & ~(mask << 16)) | (flags << 16));
> else
>        ssb_write32(dev, (ssb_read32(dev, SSB_AI_IOCTL) & ~mask) | flags));
> 2)
> ssb_core_ctl_flags(dev, mask, flags, NULL);

I aksed about reading, you gave me examples of writing. I want to
avoid such a non-readable disasters:
u32 tmp;
ssb_core_ctl_flags(dev, 0, 0, &tmp);

-- 
Rafał
