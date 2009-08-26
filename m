Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:34309 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754183AbZHZWzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:55:44 -0400
Received: by ewy2 with SMTP id 2so676375ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 15:55:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
References: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
	 <43e72e890908261528m23b8fe78w209e305f27e68fa1@mail.gmail.com>
Date: Wed, 26 Aug 2009 23:55:44 +0100
Message-ID: <3ace41890908261555g339e65d1n6627cc3d1713287e@mail.gmail.com>
Subject: Re: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	hal@lists.freedesktop.org, htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 11:28 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Wed, Aug 26, 2009 at 3:11 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>> (added list hal to To:, since it has become relevant; previous
>> exchanges of the thread on linux-wireless)
>>
>> On Wed, Aug 26, 2009 at 5:29 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
>>> On Wed, Aug 26, 2009 at 3:34 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
>>>> On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:
>>>>
>>>>> > Or wait ... are you using compat-wireless?
>>>>>
>>>>> Yes, I am. I mentioned this and did wonder if the _backport/ part
>>>>> in /sys/class is important.
>>>>
>>>> Sorry, didn't see.
>>>>
>>>> Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
>>>> some compat*.h but obviously the kernel won't ever call that notifier,
>>>> so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
>>>> handle that -- it'll be working fine in a regular tree.
>>>>
>>>> Luis, the only way to handle that would be to manually call the PRE_UP
>>>> notifier from mac80211's subif_open() and if that returns an error
>>>> (warning: the calling convention is weird) return the error... that's
>>>> weird but would work.
>>>>
>>>> johannes
>>>>
>>>
>>> Hmm, got a bit side-tracked. But hal doesn't know the device having a
>>> killswitch is still wrong somewhere?
>>> (i.e. am wondering where we should advertise that ability, or how hal
>>> works that out)
>>>
>>> Hin-Tak
>>>
>>
>> I looked into hal and I can now say that it is certainly not
>> compat-wireless "rfkill_backport"-aware; apparently all it does is
>> monitoring entries under /sys/class that it knows about. I made a
>> quick hack:
>
> This is wrong, we just do not need to use rfkill_backport for sysfs
> stuff, consider sending me patch that removes that hunk for
> compat-wireless instead and test it.
>
>  Luis
>

Hmm, I did mention the other option - make rfkill_backport exposes its
data structure as '/sys/class/rfkill' instead of
'/sys/class/rfkill_backport'. Is there any reason why
compat-wireless's rfkill_backport  does not called itself 'rfkill' and
unload and replace the old rfkill? That would be much neater, and
userland tools like hal won't need to know anything about
compat-wireless.

Hin-Tak
