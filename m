Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:40443 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbbFFEp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2015 00:45:26 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Subject: Re: Interaction issue of intel wifi and broadcom bluetooth - it appears that nobody feels responsible for doing something
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <55715DD0.4080802@broadcom.com>
Date: Sat, 6 Jun 2015 06:45:23 +0200
Cc: Jonas Thiem <jonasthiem@googlemail.com>,
	Jeremiah Mahler <jmmahler@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linux-bluetooth <linux-bluetooth@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>
Message-Id: <080F4D26-FD33-43C0-A82F-ACFC07DFE932@holtmann.org> (sfid-20150606_064548_238695_65C8F71B)
References: <CAD7Z2ho6KbK3VfO1rJdEX0RN5-trK0=ufYtma_7tMpYKUSq9UQ@mail.gmail.com> <20150605044527.GA16107@hudson.localdomain> <55712FC7.5030603@googlemail.com> <55715DD0.4080802@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

>> thanks for responding!
>> 
>> I did have my mobile phone very nearby also connected to the bluetooth
>> headphones while my laptop was still using 11n wifi. I didn't have any
>> noticeable issues with bluetooth there.
>> 
>> But I got the feeling that my phone's android drivers + hardware for
>> bluetooth are tuned better than the laptop ones, so maybe that just
>> means the phone is just better at jumping frequencies to avoid.
>> 
>> I guess the best test would be the same laptop model in direct
>> proximity, but sadly I only own that laptop once. ;)
>> 
>> I hope wireless interference wouldn't rule out that some driver work
>> would be considered to make it work better - after all, both chips are
>> in the same laptop and as per the intel comment, bluetooth is supposed
>> to work despite of wifi activity.
>> 
>> Regards,
>> Jonas Thiem
>> 
>> On 06/05/2015 06:45 AM, Jeremiah Mahler wrote:
>>> Jonas,
>>> 
>>> On Fri, Jun 05, 2015 at 01:00:32AM +0200, Jonas Thiem wrote:
>>>> Hi *,
>>>> 
>>>> this is my first post to this mailing list, sorry if it's not supposed
>>>> to go here. (also CC in responses would be nice since I'm not
>>>> subscribed)
>>>> 
>>>> I filed a bug about an intel centrino wifi interaction with broadcom's BCM2045B:
>>>> https://bugzilla.kernel.org/show_bug.cgi?id=97101
>>>> 
>>> Those are some unhelpful replies :-(
> 
> Indeed. Now my reply maybe of a similar nature as my knowledge of the bluetooth part is next to nil.
> 
>>>> In short, the two seem to kinda fight over the wireless spectrum and
>>>> both drop connections all the time - unless the 'iwlwifi' module is
>>>> loaded with 11n_disabled=1.
>>>> 
> 
> I guess you don't have a choice about the channel your access point is operating on. If you can you might move wifi channel to 5GHz although that will likely affect your range.
> 
> To get more info on your setup here a couple of questions.
> 
> What type of device are we talking about here?
> Bugzilla mentions Thinkpad X220, is that correct?
> Is your AP setup for 40MHz bandwidth?
> 
> I suppose both wifi and bt have their own antennas. When sharing antennas it needs to be coordinated who is using the antennas. This is called bt-coex. As said I don't think this is the case for your device, but if so I think there is still major development task needed as I saw email from Marcel about plans to develop a bt-coex subsystem in the kernel. Not sure if that also covers the case where bt and wifi do not share antennas.

from the report, we have to make the assumption that in this design it is two independent antennas. Meaning Bluetooth is going to win the spectrum war. It should play nice due to AFH support in almost every 4.0 device in the market, but there are limits. If your spectrum is busy, then it becomes really hard for AFH to function properly.

So in the case of two independent antennas, the rfres subsystem I am proposing would help indeed. We could tell the Bluetooth controller to block out the frequency that the WiFi chip is currently operating on.

Main problem is that these design are so rare these days that nobody actually cared enough to add this subsystem. If Bluetooth and WiFi are sharing the same antenna, the coex issue is solved by a direct connection between both chips.

Regards

Marcel

