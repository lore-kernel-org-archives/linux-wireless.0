Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58284 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756852Ab0FNWtp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 18:49:45 -0400
Received: by pwi1 with SMTP id 1so3065413pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 15:49:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik2kYW-GxWK7ZIPj7crBZKP6JTsWJs2Mfy7xvoe@mail.gmail.com>
References: <AANLkTim4kDJZnEdNy-C4xhOigWiTWQZhVJAs36LOUbjQ@mail.gmail.com>
	<AANLkTimxtFMpJftSdwDK_DRap4Bw0iVPS9Tcwe_vE_f9@mail.gmail.com>
	<AANLkTik2kYW-GxWK7ZIPj7crBZKP6JTsWJs2Mfy7xvoe@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 14 Jun 2010 15:49:25 -0700
Message-ID: <AANLkTimYwoZbiC7QtFQO681m5LyYxTfIhJohtNyzuW-P@mail.gmail.com>
Subject: Re: wireless button problem with atheros on hp machines
To: Leonardo <sombriks@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 14, 2010 at 2:35 PM, Leonardo <sombriks@gmail.com> wrote:
> 2010/6/13 Luis R. Rodriguez <mcgrof@gmail.com>:
>> On Sun, Jun 13, 2010 at 1:49 PM, Leonardo <sombriks@gmail.com> wrote:
>>> hello all, i don't know if this is the correct channel to report, but
>>> from Slackware 13.0 (2.6.29.6) to 13.1 (2.6.33.4) the wireless button
>>> stopped to work properly.
>>
>> Try 2.6.30, 2.6.31, and 2.6.32 and see if you see the issue on one of
>> those. If so then you can use git bisect to find the culprit. I
>> realize this can be quite cumbersome, but without more information I'm
>> afraid this is as good as it gets. Instead of using Linus' tree you'll
>> want to use the linux-2.6-allstable.git tree since that will have the
>> extra version kernel revisions.
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
>>
>>  Luis
>>
>
> Hello currently i'm trying those other kernel versions. I'm grabbing
> it from  http://www.kernel.org/
>
> for now i have about 3 kernels running ok or almost ok:
>
> 2.6.33.4
> 2.6.29.6
> 2.6.31.13
>
> 29 and 33 are default packages from slackware, and as i related before
> by using 2.6.29.6 i get the perfect functionality of wireless
> button/led (those hp machines have the led, and if i touch the led it
> changes de color.. nvm)
>
> today i got the 31.13 running; i have to say, maybe i have missed
> something, because i lost sound and the 3d stuff. also ath5k.ko wasn't
> created... but the bluetooth worked as expected, just as 2.6.29.6; i
> am almost sure that i missed the kernel configuration, but fortunately
> i've made a package (make targz-pkg) so i can fix it.
>
> next i'll try the 2.6.32.15 and then 2.6.34, and with some hope find
> when the problem began and report there.

Once you narrow it down between kernel revisions then you can git
bisect yourself to narrow down the issue to the specific culprit
commit.

  Luis
