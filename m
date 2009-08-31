Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63629 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbZHaS0W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 14:26:22 -0400
Received: by fxm17 with SMTP id 17so2942834fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 11:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9C0ADC.6050607@ufra.edu.br>
References: <4A9BFCCB.6040808@ufra.edu.br>
	 <3ace41890908311025r3ce83c12gd6aeace4833609b1@mail.gmail.com>
	 <4A9C0ADC.6050607@ufra.edu.br>
Date: Mon, 31 Aug 2009 19:26:22 +0100
Message-ID: <3ace41890908311126m5212926cl27172ae775fc92f2@mail.gmail.com>
Subject: Re: zd1211rw on ppc (iBook G4)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Leonardo H. Souza Hamada" <leonardo.hamada@ufra.edu.br>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 31, 2009 at 6:39 PM, Leonardo H. Souza
Hamada<leonardo.hamada@ufra.edu.br> wrote:
> Hin-Tak Leung wrote:
>> On Mon, Aug 31, 2009 at 5:39 PM, Leonardo H. Souza
>> Hamada<leonardo.hamada@ufra.edu.br> wrote:
>>
>>> Hi list,
>>>
>>> On linux-2.6.24-gentoo-r3, the zd1211rw driver was working as eth1.
>>>
>>> This is a big-endian machine.
>>>
>>> On 2.6.30-gentoo-r5, 'ifconfig -a' shows the relevant entries below:
>>>
>>
>>
>>> Likely is a issue similar reported previously:
>>> http://marc.info/?l=linux-wireless&m=124906700820860&w=2
>>>
>>> Quick peek at the source diffs between previous version reveals some
>>> changes.
>>>
>>
>> Are you talking about a regression - i.e. it used to work *on the same
>> architecture*, but not any more? If that's the case you can probably
>> start with 2.6.24 and various compat-wireless on to narrow down which
>> changes break.  The post you referred to is different - vendor driver
>> vs rw driver.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>> It used to work *on the same architecture*, but not any more.
>
> This is the case.
>
>>The post you referred to is different - vendor driver vs rw driver.
>
> The post i referred to, as I interpret, is a illustrative that the
> vendor driver is working on the same hardware which the rw is not working.
>
> Thanks for the reply anyway .
>

I just had a quick look - the rw driver from 2.6.24 to 2.6.30 actually
went through the ieee80211 to mac80211 change.
('git diff v2.6.24:drivers/net/wireless/zd1211rw/
v2.6.30:drivers/net/wireless/zd1211rw/' for those who has
wireless-testing).
I have a bunch of patches which bring the 2.22 vendor driver up to
2.6.29 and 3.0 the vendor driver up to 2.6.30:
http://htl10.users.sourceforge.net/patchsets/
It doesn't fix the rw driver, but might be good enough for you? I
didn't spent any more time on the 2.22 vendor driver after 2.6.29
because 3.0 was released then. The 3.0 vendor driver can be had from:

http://www.kernel.org/pub/linux/kernel/people/mcgrof/zd1211/

It would appear that the rw driver's ieee80211->mac80211 conversion
has broken big- endian platforms, at a first guess.
( I still maintain that
http://marc.info/?l=linux-wireless&m=124906700820860&w=2 is a bit
different from your situation, since the other poster never had the rw
driver working on bigendian platforms). In any case, it might be
interesting to hear from others if recent versions of the rw driver
can be confirmed to work on bigendian platforms.
