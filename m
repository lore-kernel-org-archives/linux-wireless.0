Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:7335 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbbFEI3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 04:29:08 -0400
Message-ID: <55715DD0.4080802@broadcom.com> (sfid-20150605_102933_858097_C48AC259)
Date: Fri, 5 Jun 2015 10:29:04 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jonas Thiem <jonasthiem@googlemail.com>
CC: Jeremiah Mahler <jmmahler@gmail.com>,
	<linux-kernel@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Subject: Re: Interaction issue of intel wifi and broadcom bluetooth - it appears
 that nobody feels responsible for doing something
References: <CAD7Z2ho6KbK3VfO1rJdEX0RN5-trK0=ufYtma_7tMpYKUSq9UQ@mail.gmail.com> <20150605044527.GA16107@hudson.localdomain> <55712FC7.5030603@googlemail.com>
In-Reply-To: <55712FC7.5030603@googlemail.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Marcel, wireless list, and bt list.

On 06/05/15 07:12, Jonas Thiem wrote:
> Hi Jeremiah,
>
> thanks for responding!
>
> I did have my mobile phone very nearby also connected to the bluetooth
> headphones while my laptop was still using 11n wifi. I didn't have any
> noticeable issues with bluetooth there.
>
> But I got the feeling that my phone's android drivers + hardware for
> bluetooth are tuned better than the laptop ones, so maybe that just
> means the phone is just better at jumping frequencies to avoid.
>
> I guess the best test would be the same laptop model in direct
> proximity, but sadly I only own that laptop once. ;)
>
> I hope wireless interference wouldn't rule out that some driver work
> would be considered to make it work better - after all, both chips are
> in the same laptop and as per the intel comment, bluetooth is supposed
> to work despite of wifi activity.
>
> Regards,
> Jonas Thiem
>
> On 06/05/2015 06:45 AM, Jeremiah Mahler wrote:
>> Jonas,
>>
>> On Fri, Jun 05, 2015 at 01:00:32AM +0200, Jonas Thiem wrote:
>>> Hi *,
>>>
>>> this is my first post to this mailing list, sorry if it's not supposed
>>> to go here. (also CC in responses would be nice since I'm not
>>> subscribed)
>>>
>>> I filed a bug about an intel centrino wifi interaction with broadcom's BCM2045B:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=97101
>>>
>> Those are some unhelpful replies :-(

Indeed. Now my reply maybe of a similar nature as my knowledge of the 
bluetooth part is next to nil.

>>> In short, the two seem to kinda fight over the wireless spectrum and
>>> both drop connections all the time - unless the 'iwlwifi' module is
>>> loaded with 11n_disabled=1.
>>>

I guess you don't have a choice about the channel your access point is 
operating on. If you can you might move wifi channel to 5GHz although 
that will likely affect your range.

To get more info on your setup here a couple of questions.

What type of device are we talking about here?
Bugzilla mentions Thinkpad X220, is that correct?
Is your AP setup for 40MHz bandwidth?

I suppose both wifi and bt have their own antennas. When sharing 
antennas it needs to be coordinated who is using the antennas. This is 
called bt-coex. As said I don't think this is the case for your device, 
but if so I think there is still major development task needed as I saw 
email from Marcel about plans to develop a bt-coex subsystem in the 
kernel. Not sure if that also covers the case where bt and wifi do not 
share antennas.

Regards,
Arend

>> I don't have a solution but I think the problem is interesting.
>>
>> Both Bluetooth and 11n share the same frequency band near 2.4 GHz so it
>> is possible that they could conflict.  If you had two laptops, and you
>> ran just Bluetooth on one and just 11n on the other, would they
>> both have problems?  This would tell as whether it was something inside
>> the kernel or if it was really wireless interference.
>>
>> [...]
>>>
>>> Regards,
>>> Jonas Thiem
>>
>

