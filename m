Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:48813 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754737AbZITR3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Sep 2009 13:29:09 -0400
Received: by iwn8 with SMTP id 8so1344886iwn.4
        for <linux-wireless@vger.kernel.org>; Sun, 20 Sep 2009 10:29:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AB65CFE.7090101@canonical.com>
References: <20090919205545.GA18080@bombadil.infradead.org>
	<4AB5A5A7.3020107@canonical.com> <43e72e890909200743h74934657nc056c9e6dcb14e90@mail.gmail.com>
	<4AB65CFE.7090101@canonical.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sun, 20 Sep 2009 10:28:52 -0700
Message-ID: <43e72e890909201028i119b75c0ic94d07e79e4b7a43@mail.gmail.com>
Subject: Re: [RFC] compat-2.6: mangle symbols for driver-select
To: tim.gardner@canonical.com
Cc: linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 20, 2009 at 9:49 AM, Tim Gardner <tim.gardner@canonical.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> On Sat, Sep 19, 2009 at 8:46 PM, Tim Gardner <tim.gardner@canonical.com>
>> wrote:
>>>
>>> Luis R. Rodriguez wrote:
>>>>
>>>> Today at the summit we spoke about mangling symbols for driver-slect.
>>>> Here's a quick nasty take on this but without doing this for
>>>> driver-select
>>>> specifically just for testing. It seems to compile, but someone more
>>>> motivated
>>>> may want to test and make this apply somehow only for driver-select or
>>>> perhaps
>>>> when a -D define is used.
>>>>
>>>> Reason for this is to help distributions / OEMs / ODMs who want to
>>>> replace
>>>> just *one* driver with compat-wireless.
>>>>
>>> I think it would be better to generate the list of mangled symbols
>>> dynamically.
>>
>> Agreed, that is the part I left out, as a TODO to someone interested.
>>
>
> I'm working on a patch (it works with 2.6.31), but I need to test with older
> kernels.

:D

>>> In older Ubuntu releases (before depmod behavior was
>>> corrected), we have to run a 'munge' script to preface all of the
>>> exported
>>> symbols so that a compat-wireless driver references the compat-wireless
>>> protocol stack symbols. See the attached munge script for compat-wireless
>>> on
>>> 2.6.24.
>>
>> Please correct me if I'm wrong but I believe the script seems to do
>> what I did just that it actually edited the files with the changes, I
>> prefer the way I did this as it requires less work to maintain and
>> understand IMHO.
>>
>
> I'm fine with that, in fact its a bit faster since my munge script is a bit
> slow. It'll also make dealing with kernel version dependent symbol munge
> exceptions a bit simpler.

Great.

> One thing that is worth mentioning is that the module names need to be
> changed for older user space environments, otherwise depmod mucks things up
> in interesting ways.

Can you elaborate on this? Perhaps its best we talk this over at the
summit in person.

>>> We can either do something like this for compat-wireless, or we
>>> could use a subset of this logic to generate the list of symbols
>>> contained
>>> within the '#ifdef CONFIG_COMPAT_WIRELESS_MANGLE' clause.
>>
>> So I was under the impression you would use this only if you are using
>> ./scripts/driver-select to select one driver out of the whole tree,
>> but it seems you actually use this for all the drivers on
>> compat-wireless for the Ubuntu linux-backports-modules package. I take
>> it you put lbm stuff then into some /lib/modules/$(uname)/compat/ and
>> use a sort of /etc/depmod.d/01-compat.conf to prefer compat over
>> updates/ or kernel/ ?
>
> For LBM I've taken a scorched earth approach, i.e., _all_ drivers in
> compat-wireless get built. The vast bulk of users that I deal with are only
> interested in one driver, but I don't know a priori _which_ driver. The use
> case where they would want to use a mainline driver at the same time as a
> different compat-wireless driver is fairly rare (which my approach makes
> impossible).

OK I have a few other questions so I'll poke you at the summit.

  Luis
