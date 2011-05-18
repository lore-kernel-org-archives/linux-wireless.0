Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32969 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab1ERPsv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 May 2011 11:48:51 -0400
Received: by wwa36 with SMTP id 36so1870175wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 18 May 2011 08:48:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Ksn=WCfwDzM496ZwbV1u2FkTqPQ@mail.gmail.com>
References: <BANLkTi=3i6LEYFivGYB0OZDKmjXxeo+yrQ@mail.gmail.com>
	<294183.47547.qm@web161601.mail.bf1.yahoo.com>
	<BANLkTimwBB35HhOBjOq=OyhrVWq9MOZ3tA@mail.gmail.com>
	<4DD3C0B9.5070400@gmail.com>
	<BANLkTinj6CyWPipu0BuZtrug6ajvqedC7Q@mail.gmail.com>
	<4DD3DA7F.7020809@lwfinger.net>
	<BANLkTik23CDQ531gb3LN9YR1Vh_NPf2ruQ@mail.gmail.com>
	<BANLkTi=Ksn=WCfwDzM496ZwbV1u2FkTqPQ@mail.gmail.com>
Date: Wed, 18 May 2011 21:18:49 +0530
Message-ID: <BANLkTi=VCum+TtmP1jH5aZ+UAi1dpLbDnA@mail.gmail.com> (sfid-20110518_174855_568842_E2809319)
Subject: Re: rt2x00: rt2800usb causing kernel panic /compat-wireless/
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	Walter Goldens <goldenstranger@yahoo.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Mark Huijgen <mark@huijgen.tk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 18, 2011 at 9:15 PM, Mohammed Shafi
<shafi.wireless@gmail.com> wrote:
> just a quick update, once again I blindly used this patches which
> seems to solve the problem,
> agg-rx.c still uses the call_rcu thing, so I thought work.c ,
> aggr-tx.c can make use of call_rcu .
> thanks to the guy who mailed this patch!
>
> need to test more

from this thread
http://comments.gmane.org/gmane.linux.kernel.wireless.general/69332

will test with compat wireless 16-05-2011
>
>
> On Wed, May 18, 2011 at 8:16 PM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
>> On Wed, May 18, 2011 at 8:11 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>>> On 05/18/2011 08:04 AM, Mohammed Shafi wrote:
>>>>
>>>> On Wed, May 18, 2011 at 6:21 PM, Gertjan van Wingerde
>>>> <gwingerde@gmail.com>  wrote:
>>>>>
>>>>> On 05/18/11 14:41, Mohammed Shafi wrote:
>>>>>>
>>>>>> On Wed, May 18, 2011 at 5:26 PM, Walter Goldens
>>>>>> <goldenstranger@yahoo.com>  wrote:
>>>>>>>>>
>>>>>>>>> A very peculiar bug.
>>>>>>>>>
>>>>>>>>> With compat-wireless from 16.05 a nasty bug started to
>>>>>>>>
>>>>>>>> manifest itself. Right around association time, the
>>>>>>>> rt2800usb causes kernel panic. The system freezes and the
>>>>>>>> Caps Lock and Num Lock leds on the keyboard begin to flash.
>>>>>>>>
>>>>>>>> also ath9k, iwlagn.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Unfortunately there are no recoverable traces after
>>>>>>>>
>>>>>>>> the system failure to aid this bug report or to indicate its
>>>>>>>> origin.
>>>>>>>>>
>>>>>>>>> I believe it may somehow be related to Ubuntu's
>>>>>>>>
>>>>>>>> network-manager. If I turn off the network-manager service,
>>>>>>>> I can go into monitor mode for example, but if
>>>>>>>> network-manager is running and I plug my USB dongle, it
>>>>>>>> starts to associate, a second or two later the system is in
>>>>>>>> complete meltdown.
>>>>>>>>
>>>>>>>> same thing, monitor mode worked perfectly fine.
>>>>>>>>
>>>>>>>>>
>>>>>>>>> Nothing concrete, but a hunch is telling me this has
>>>>>>>>
>>>>>>>> something to do with the association mechanism of the
>>>>>>>> rt2800usb. Compat-wireless from few days back exhibits no
>>>>>>>> such foul play.
>>>>>>>>
>>>>>>>> yes just right at the association complete freeze.
>>>>>>>>
>>>>>>>
>>>>>>> That's strange. I wonder what's the connection with this bug and
>>>>>>> network-manager. Because when I manually tried to associate, dmesg reported
>>>>>>> the association attempt timed out.
>>>>>>
>>>>>> no even when we use iw dev connect command we can see the panic.
>>>>>
>>>>> Yeah, I've seen this freeze as well using one of the later
>>>>> compat-wireless packages using just iw and wpa_supplicant to bring up the
>>>>> card. This is on all sorts of rt2x00 supported devices.
>>>>>
>>>>> However, I don't believe this to be an rt2x00-specific bug, as exactly
>>>>> the same rt2x00 sources inside a compat-wireless-2.6.39rc7 package do not
>>>>> produce the freeze.
>>>>>
>>>>>> some expert suspected that there is a chance of kfree_rcu in
>>>>>> compat-wireless may have caused the problem
>>>>>>
>>>>>
>>>>> That's where my suspicion is as well, but I didn't have the time to
>>>>> further investigate. Since my focus was on rt2x00 I used the
>>>>> compat-wireless-2.6.39rc7 package to test my patches. I only did a quick
>>>>> check, and the kfree_rcu compatibility fix that was done in compat-wireless
>>>>> did seem to match the kfree_rcu code is present in linux-next, but maybe
>>>>> there is an odd side-effect.
>>>>
>>>> I could not exactly remember this panic came just after kfree_rcu
>>>> backported..
>>>
>>> This problem also occurs with rtl8192se from compat-wireless. When it was
>>> reported to me, a photo of the console log was included (attached). The
>>> crash is a NULL pointer in rcu_do_batch.clone.19 (I think - the photo
>>> quality is minimal.).
>>
>> thanks!, same type of call trace which I had also obtained, hopefully there in
>>  http://pastebin.com/CZrSZrme
>>  http://pastebin.com/gwZJGDG4
>>
>>
>>
>>>
>>> Larry
>>>
>>>
>>>
>>>
>>
>>
>>
>> --
>> shafi
>>
>
>
>
> --
> shafi
>



-- 
shafi
