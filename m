Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63182 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757486AbZLWXnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 18:43:24 -0500
Received: by ewy19 with SMTP id 19so6881700ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 15:43:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1261609092.2774.4.camel@mj>
References: <c6b1100b0912231448v759eac55kfb3dd1e6d6186c73@mail.gmail.com>
	 <1261609092.2774.4.camel@mj>
Date: Wed, 23 Dec 2009 23:43:22 +0000
Message-ID: <c6b1100b0912231543n20c35338i751eb39f21fb4178@mail.gmail.com>
Subject: Re: 2.6.33.rc1-git3 - regression in rt61pci driver
From: Chris Clayton <chris2553@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavel,

2009/12/23 Pavel Roskin <proski@gnu.org>:
> On Wed, 2009-12-23 at 22:48 +0000, Chris Clayton wrote:
>> Hi,
>>
>> I'm not subscribed, so please cc me on any reply.
>>
>> I've built and installed today's -git kernel
>> (v2.6.33-rc1-225-gc9f937e) and find that my (rt61pci) wireless card no
>> longer works. All the usual drivers are loaded when I insert the card.
>> The card works fine with 2.6.32.2 (as long as I disable power saving).
>>
>> The symptoms are that:
>>
>> 1. The file /proc/net/wireless never appears
>>
>> 2. iwconfig gives "wlan0     no wireless extensions."
>
> Have a closer look at your .config file.  I guess CONFIG_CFG80211_WEXT
> is not defined there.  It's needed to make cfg80211 capable devices
> support wireless extensions.
>

Yes, that was the problem. Thanks - I've got the card working again now.

However, I have now noticed a change of behaviour. With 2.6.32.2 and
earlier kernels the line for wlan0 appears in /proc/net/wireless
before my configuration script is run by udev. With 2.6.33 the line
doesn't appear until wpa_supplicant has been started by the script.

I only look for the line as a way of making sure the modules have
loaded. I can't remember now why I do that but I guess there must have
been a time when udev started the script before the driver had
initialised everything. It's not a big deal for me, because I can look
in /proc/net/dev instead, but I thought a heads up on the behaviour
change might be useful to others. I might no longer need the delay or
maybe the script can simply sleep for a second or two - I'll
experiment a bit.

> You can try using iw to configure your card.  That's the new utility.
>

I looked at that earlier tonight. Unfortunately, the man page is
almost useless and the help text from iw itself is far from clear to
me. I'll have to experiment to find out what works. Thanks for the tip
though.

Regards,
Chris

> [dropping cc to LKML, it's a purely wireless issue]
>
> --
> Regards,
> Pavel Roskin
>



-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
