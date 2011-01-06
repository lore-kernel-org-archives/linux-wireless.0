Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59809 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab1AFEL3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jan 2011 23:11:29 -0500
Received: by iwn9 with SMTP id 9so15908279iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 20:11:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimdEcj4k09ZyHQTXnbaeNj4CCrAm=mRTw+R5j6L@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
	<AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
	<AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
	<AANLkTimdEcj4k09ZyHQTXnbaeNj4CCrAm=mRTw+R5j6L@mail.gmail.com>
Date: Wed, 5 Jan 2011 20:11:27 -0800
Message-ID: <AANLkTimaWy33vYaM=bCPd0VooyR9QVw99YB1fSOj42Fo@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 5, 2011 at 2:32 AM, Wolfgang Kufner
<wolfgang.kufner@gmail.com> wrote:
> Hi Aleksandar,
>
> On Wed, Jan 5, 2011 at 7:57 AM, Aleksandar Milivojevic
> <alex@milivojevic.org> wrote:
>> On Tue, Jan 4, 2011 at 2:31 PM, Wolfgang Kufner
>> <wolfgang.kufner@gmail.com> wrote:
>>> Maybe a fix for this issue is already in compat-wireless.
>>
>> Might be.  I'll try compiling linux-next and see if it helps (could be
>> few days, I need to setup this box for the task first).
>>
>
> There is no need to compile linux-next. Just compile the latest
> bleeding edge compat-wireless tarball from
> http://wireless.kernel.org/en/users/Download. It is only 4MB in size
> and reflects the latest on the linux-next.git tree and takes only a
> few minutes to compile.

Ah, thanks.  That makes it much easier and faster :-)

Doing "make" worked, however "make install" failed with:

make -C /lib/modules/2.6.35-24-generic/build
M=/home/alex/compat-wireless-2010-12-26 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.35-24-generic'
  CC [M]  /home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi/base.o
/home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi/base.c:
In function ‘_rtl_init_deferred_work’:
/home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi/base.c:229:
error: implicit declaration of function ‘alloc_workqueue’
/home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi/base.c:229:
warning: assignment makes pointer from integer without a cast
make[4]: *** [/home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi/base.o]
Error 1
make[3]: *** [/home/alex/compat-wireless-2010-12-26/drivers/net/wireless/rtlwifi]
Error 2
make[2]: *** [/home/alex/compat-wireless-2010-12-26/drivers/net/wireless]
Error 2
make[1]: *** [_module_/home/alex/compat-wireless-2010-12-26] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.35-24-generic'
make: *** [modules] Error 2

I'll try selecting only subset of drivers, and see if I'll have better luck.
