Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:44561 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbYG1S5O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 14:57:14 -0400
Received: by mu-out-0910.google.com with SMTP id w8so5385827mue.1
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 11:57:12 -0700 (PDT)
Message-ID: <5f68ea7b0807281157v7cad2424rd8d46c1ca7d7d753@mail.gmail.com> (sfid-20080728_205717_724627_B9D9078C)
Date: Mon, 28 Jul 2008 20:57:12 +0200
From: "Angel Mieres" <mieres.angel@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: IWL5000
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <5f68ea7b0807280446w4009375dw4c77357cae964e1a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5f68ea7b0807280351u4f6b6a59v8304a7a3b53436be@mail.gmail.com>
	 <1ba2fa240807280421s48b26b58n8db03f75bfa4c206@mail.gmail.com>
	 <1ba2fa240807280421x58b72273x7b148e796e4f2c87@mail.gmail.com>
	 <5f68ea7b0807280446w4009375dw4c77357cae964e1a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Tomas,

With the master branch, i recompile the kernel and it works. so now i
know that my problem is not in the NIC.
Is possible to get working this nic without having to recompile a
kernel? only with compat-wireless?



2008/7/28 Angel Mieres <mieres.angel@gmail.com>:
> Hi Tomas,
>
> Thanks for your reply. I will test master branch.
> The id's of the NIC are:
> `lspci -nv`
> 03:00.0 0280: 8086:4237
>        Subsystem: 8086:1211
>        Flags: bus master, fast devsel, latency 0, IRQ 11
>        Memory at f4300000 (64-bit, non-prefetchable) [size=8K]
>        Capabilities: [c8] Power Management version 3
>        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0 Enable-
>        Capabilities: [e0] Express Endpoint IRQ 0
>
> 2008/7/28 Tomas Winkler <tomasw@gmail.com>:
>> On Mon, Jul 28, 2008 at 2:21 PM, Tomas Winkler <tomasw@gmail.com> wrote:
>>> On Mon, Jul 28, 2008 at 1:51 PM, Angel Mieres <mieres.angel@gmail.com> wrote:
>>>> Hi all,
>>>>
>>>> Im trying to get working intel wifi link 5100 on ubuntu 8.0.4, but i
>>>> have some problems; the procedure that i follow was:
>>>>    1.- I try to get working with ndiswrapper, i get the lastest
>>>> drivers availables for windowz, load the inf file,
>>>>     check that device was recognize by ndiswrapper(installed & device
>>>> present), but when i load the ndiswrapper module, it appears:
>>>>     "unknown symbol: ntoskrnl.exe:'KeBugCheck'; couldn't prepare
>>>> driver 'netw5x32'"
>>>>      So, i decide to take a look of compat-wireless project that
>>>> support this driver(right?).
>>>>    2.- I get the firmware of iwl5000, copy the firmware on
>>>> /lib/firmware, i get the latest compat-wireless-2.6 tar file, after
>>>> this,
>>>>       I compile the drivers(make && make install), i try load the
>>>> driver; at dmesg it appears that ipw4965 loads perfectly but the led
>>>> of the wifi, it doesn't work and
>>>>       no one devices appear to be installed.
>>>>
>>>> So, someone have this NIC working? Please help me a bit. All
>>>> suggestions are welcome.
>>>> Thanks guys
>>>
>>> Use iwlwif-2.6.git master branch. Merging into wireless-testing.git is
>>> rather stalled right now.
>>> If your devices is not recognized please send me the devices ids of your card.
>>> Thanks
>>> Tomas
>>
>> Fix: iwlwifi-2.6.git
>>
>
