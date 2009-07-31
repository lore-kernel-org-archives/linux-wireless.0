Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from viefep19-int.chello.at ([62.179.121.39]:10177 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252AbZGaVVR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 17:21:17 -0400
Message-ID: <9CCF95DA1012483EB251747AF1030A37@Emiel>
From: "Emiel Bruijntjes" <emiel@bruijntjes.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: <linux-wireless@vger.kernel.org>
References: <ABEC48F218774102B9939CE6F5F5F856@Emiel> <43e72e890907200934o319e20d2y825592207b75b0f4@mail.gmail.com>
In-Reply-To: <43e72e890907200934o319e20d2y825592207b75b0f4@mail.gmail.com>
Subject: Re: Enabling and disabling Atheros AR9258 wireless card
Date: Fri, 31 Jul 2009 23:21:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


----- Original Message ----- 
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Emiel Bruijntjes" <emiel@bruijntjes.net>
Cc: <linux-wireless@vger.kernel.org>
Sent: Monday, July 20, 2009 6:34 PM
Subject: Re: Enabling and disabling Atheros AR9258 wireless card


> On Sun, Jul 19, 2009 at 6:41 AM, Emiel Bruijntjes<emiel@bruijntjes.net> 
> wrote:
>>
>> Hi,
>>
>> I hope this is the right channel to report a bug/feature-request.
>>
>> My laptop (Toshiba NB200) uses a Atheros AR9285 wireless card. Wireless 
>> is
>> currently disabled, and the wireless LED is off. This is the default 
>> factory
>> setting. There is no way to enable the wireless module from Linux. On
>> Windows, the Fn/F8 key combination enables and disables the wireless 
>> module,
>> and turns on or off the LED. On Linux however, this isn't working.
>>
>> The advice that I read on discussion forums on the web was to boot 
>> Windows,
>> turn on wireless, and then boot Linux again (see http://tjmcgrew.com/). 
>> It
>> is - as far as I know - not possible to use the Atheros AR9285 wireless 
>> card
>> on a Linux computer, without running Windows first to enable it. This is 
>> not
>> very good.
>
> That would mean no one could use ath9k with AR9285 but that is
> obviously not the case.
>
> You are generalizing your issue to everyone and making wide assumptions.
>

You are of course correct that the AR9285 is supported, and that a lot of 
users are already using it. I am sorry if I suggested that it wasn't working 
for anyone at all.

My point however, is that it is currently not possible to switch the AR9285 
card on or off from Linux. This is especially unhandy as the wireless card 
is disabled by default on the Toshiba NB200 netbook. This problem did not 
only happen on my computer: I've found several discussions on the internet 
about this subject. The currently suggested workaround is: install Windows, 
enable the wireless card, then install Linux.


>> To sum up:
>> - From Linux it is not possible to enable/disable the Atheros AR9285
>> wireless card, and to turn on and off the wireless LED.
>> - This should be fixed as the wireless card is disabled by default, and 
>> it
>> is thus impossible to use it on a system without installing and running
>> Windows first.
>
> You probably just need the proper rfkill module to enable your device.
> Whether your rfkill triggers are supported is another question. For
> that you may want to try out the latest kernel and use a tree where
> rfkill was recently re-implemented.
>
> Please try building wireless-testing:
>
> http://wireless.kernel.org/en/developers/Documentation/git-guide
>
> or compat-wireless:
>
> http://wireless.kernel.org/en/users/Download/
>
>  Luis


I had already installed compat-wireless - without it the wireless card was 
not even detected - but I have had no luck with building wireless-testing. I 
manage to compile it, but after installing it, the wlan0 interface is 
completely gone. I suppose this is my fault, as I do not have much 
experience with building and installing things like this, and I do not 
really understand what I'm doing while I try all kinds of modprobe and 'make 
load' commands. But on the other hand, I haven't seen a message in the 
ChangeLog that suggests that this problem is fixed, so I did not expect that 
it would solve my problem anyway.

I thinks your observation is right that it is probably a module that is 
responsible for enabling and disabling that is missing or broken. I hope you 
do recognize that this is a bug or missing feature that needs to be fixed, 
and that it ends up somewhere on a TODO list.

Thanks.

Emiel


