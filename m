Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:34803 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755588AbXGTRs3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2007 13:48:29 -0400
Message-ID: <46A0F564.2090607@warmcat.com>
Date: Fri, 20 Jul 2007 18:48:20 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
References: <20070611103828.961999956@warmcat.com> <46A0CB16.6010901@warmcat.com> <46A0E9B0.1050600@lwfinger.net> <200707201936.41078.mb@bu3sch.de>
In-Reply-To: <200707201936.41078.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:
> On Friday 20 July 2007 18:58:24 Larry Finger wrote:
>> Andy Green wrote:
>>> Understood, that is why I consider it a bad thing that functionality
>>> that can be done in the mac80211 driver is pushed into the binary-only
>>> firmware when there is a choice (otherwise known as "paranoia", apparently).
>> Unfortunately, that is a necessary result of this type of reverse-engineering. If Broadcom put some 
>> function in the firmware, we have to leave it there as we have no idea what would break.
>>
>>> However you stripped some quoting from Michael:
>>>
>>> ''But it is actually no problem in reality, as the use-it-or-die
>>> firmware doesn't have this problem. So if someone uses another
>>> firmware than the one we suggest, he will probably run into more
>>> problems, as well.
>>> The fix is called: Use the correct firmware.
>>> For now, at least.''
>>>
>>> I would summarize this that Michael is telling me one pariticular
>>> version of firmware - "use it or die firmware" - is especially
>>> blessed/correct.  It might be an idea to let people know they have
>>> strayed from the dependency of the required firmware version in dmesg if
>>> indeed there is an effective dependency of the driver on it.
>> It isn't that it is blessed or correct, but that it has been tested. Your version has not. Who knows 
>> what else might have changed? Once we know the version with the different behavior, a warning 
>> message can be prepared. I don't think anyone knew about this problem until you submitted your patch.
> 
> People don't read dmesg. Adding a "This firmware is unsupported"
> would have no effect.
> I experience same thing for the "bcm43xx-does-not-support-v3-issue".
> There is a clear error message saying what to do exactly. And _still_
> people mail me asking what this message means.

Sure, but naturally you don't hear from the presumably nonzero amount of
people who saw and understood the message.  Whereas if there was no
message at all, only disgusted and baffled people are possible.

> The use-or-die firmware is here:
> http://linuxwireless.org/en/users/Drivers/bcm43xx
> 
>>> Can I still get the firmware version from fwcutter if I don't have the
>>> original Windows binary the firmware came from?
>> AFAIK, fwcutter can only get the version from the foreign driver. It can be gotten from the dmesg 
>> output of your inlaws computer, or if you have the extracted firmware files here, you can bundle 
>> them up and email them to me privately.
> 
> People don't read dmesg.
> q.e.d. ;)

Actually, I can't read dmesg on my In-laws' box that has the card the
last few weeks: I read dmesg all the time if I suspect kernel-side
trouble.  It's pretty simple and cheap to do a printk and give someone
with problems the ability to dig themselves out of the trouble with a
clue and even a URL in this case.

If the driver is dependent on a particular version of an external file,
and you can read the version of that file at runtime, you really ought
to be issuing a diagnostic if the dependency is violated.

-Andy
