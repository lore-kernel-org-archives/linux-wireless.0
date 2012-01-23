Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42951 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab2AWS1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 13:27:02 -0500
Received: by ggnb1 with SMTP id b1so1497283ggn.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 10:27:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1DA06C.5080605@hauke-m.de>
References: <1327153475-28081-1-git-send-email-hauke@hauke-m.de>
 <CAB=NE6UBBRg53EjW3t8YEUoGLvQS00dnx6Z=-rmBa7pb-D_TCg@mail.gmail.com>
 <201201231755.q0NHtQUR002682@mail.maya.org> <CAB=NE6VL5P2zpryoVHni6NjF1EpNML5Oe-A3n3YUXygcU1_K4w@mail.gmail.com>
 <4F1DA06C.5080605@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Jan 2012 10:26:41 -0800
Message-ID: <CAB=NE6W3Vu6LDWK+O6jECRH2So76ZMGD14JtR1d=J-QyasZQfA@mail.gmail.com> (sfid-20120123_192707_827232_B26C0A27)
Subject: Re: [PATCH] compat: add __cancel_delayed_work()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 10:01 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 01/23/2012 06:57 PM, Luis R. Rodriguez wrote:
>> On Mon, Jan 23, 2012 at 9:55 AM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>>> Luis R. Rodriguez schrieb:
>>>> On Sat, Jan 21, 2012 at 5:44 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>>> __cancel_delayed_work is needed by include/net/bluetooth/l2cap.h and
>>>>> not available in old kernel versions. This was just copied from the
>>>>> kernel.
>>>>>
>>>>> This should also go into compat-wireless-stable-3.3.
>>>>>
>>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>>
>>>> Thanks! Applied all onto compat-wireless.git and compat.git, in
>>>> addition to the linux-3.3.y branch for compat.git as you indicated for
>>>> this patch. Will roll out a new tarball right away.
>>>
>>> BTW: I've to apply always the following patch to some older
>>> compat-wireless packages (3.2 e.g) to get it compiled with kernel 3.1:
>>>
>>> --- drivers/misc/eeprom/Makefile.orig   2012-01-10 02:10:51.000000000 +0100
>>> +++ drivers/misc/eeprom/Makefile        2012-01-10 05:14:40.082494612 +0100
>>> @@ -1,3 +1,3 @@
>>>  obj-$(CONFIG_EEPROM_93CX6)     += eeprom_93cx6.o
>>> -obj-$(CONFIG_EEPROM_93XX46)    += eeprom_93xx46.o
>>> +# obj-$(CONFIG_EEPROM_93XX46)  += eeprom_93xx46.o
>>>  obj-$(CONFIG_EEPROM_DIGSY_MTC_CFG) += digsy_mtc_eeprom.o
>>>
>>> Is this eventually needed in 3.3, too?
>>
>> Why do you need this? Can you show your compile errors?
>>
>>   Luis
>
> This is fixed in HEAD in this commit:
>
> commit 0db9fae8c40674f65cf50c78e6587b9c9d9e2735
> Author: Hauke Mehrtens <hauke@hauke-m.de>
> Date:   Sat Dec 3 15:46:21 2011 +0100
>
>    compat-wireless: remove some modules from Makefile
>
> It should be backported to linux-3.1.y and linux-3.2.y. We just ship
> eeprom_93cx6.c and nothing else in this directory.

Thanks, I've applied this onto those branches and upon a new release
those will get the fixes.

  Luis
