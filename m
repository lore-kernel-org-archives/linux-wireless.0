Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44866 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752372Ab0IWTdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:33:09 -0400
Message-ID: <4C9BAB6C.2010701@hauke-m.de>
Date: Thu, 23 Sep 2010 21:33:00 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, mcgrof@infradead.org
Subject: Re: [PATCH 3/4] compat: move pmcia backport code into compat-2.6.36.h
References: <1284918131-32065-1-git-send-email-hauke@hauke-m.de> <1284918131-32065-3-git-send-email-hauke@hauke-m.de> <4C9A34FB.5020809@gmail.com> <AANLkTinJG=mgYE-eUmptCVkXDDpSB9YDHA0AwbYi7xfw@mail.gmail.com> <4C9A5471.2090009@gmail.com>
In-Reply-To: <4C9A5471.2090009@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22.09.2010 21:09, Kshitij Kulshreshtha wrote:
> 
> 
> As on 2010-09-22 18:59, Luis R. Rodriguez did write:
>> On Wed, Sep 22, 2010 at 9:55 AM, Kshitij Kulshreshtha
>> <kkhere.geo@gmail.com> wrote:
>>> Hello,
>>>
>>> As on 2010-09-19 19:42, Hauke Mehrtens did write:
>>>> We have all out backport headers in include/linux/compat-2.6.XX.h also the pcmcia
>>>> part there.
>>>
>>> I'm not sure if this won't make all the compat-wireless modules depend
>>> on pcmcia.ko for kernels < 2.6.36 where
>>> pcmcia_access_configuation_register() is exported. Even if someone is
>>> only building selected drivers like iwlwifi or ath.
>>
>> Have you tried loading ath9k or iwlagn on compat-wireless? Did you
>> note compat doesn't get loaded? Anyway, patches welcomed to enhance
>> this if your concern is if your kernel won't build with this. We also
>> plan on dropping PCMCIA completely anyway.
> 
> Actually compat does get loaded since mac80211 needs it for noop_llseek
> on 2.6.34, however my current build is not showing the pcmcia dependency
> that I was afraid of, so please ignore this.
> 
> Thanks.
Hi Kshitij,
Hi Luis,

in this case pcmcia_read_config_byte() and pcmcia_write_config_byte()
are inlined so the code will be placed in the drivers using this code
and not compat.ko. The header files for pcmcia are available independent
from how the kernel was configured.

But there are some other functions in compat-2.6.xx.c (e.g.
pccard_loop_tuple() in compat-2.6.33.c) depending on pcmcia code. This
will not cause an compile error because these backport functions are
only build if pcmcia is configured in the kernel but if the kernel
supports pcmcia compat.ko will depend on pcmcia. This does not harm on
normal desktop systems like ubuntu because the devices do have enoth
memory to load the probably unneeded pcmcia module. But if you are on an
embedded device with e.g. 4 MB flash and 16 MB Ram you do not want to
depend on pcmcia if you do not have to.

The same thing also regards usb and probably some other modules. In
OpenWrt we removed the usb backports from compat-wireless, because we
had no support for any driver needing these functions and we do not want
compat.ko to depend on usb, because some devices supported by OpenWrt do
not even have an usb port, but an build in wireless card.

It would make sense to split compat.ko up in compat-generic.ko,
compat-net.ko, compat-pcmcia.ko, compat-usb.ko, and so on, but this will
make maintaining them it really harder.

Hauke
