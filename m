Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:36784 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753174AbcJWPxp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Oct 2016 11:53:45 -0400
Received: by mail-wm0-f45.google.com with SMTP id b80so64153393wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2016 08:53:45 -0700 (PDT)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Jonas Gorski <jonas.gorski@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
 <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
 <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
 <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Oliver Zemann <oliver.zemann@gmail.com>
Message-ID: <43544382-075a-6437-8f72-133a907d9def@gmail.com> (sfid-20161023_175349_020633_EC5C13F4)
Date: Sun, 23 Oct 2016 17:53:42 +0200
MIME-Version: 1.0
In-Reply-To: <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for that info Jonas. I passed optargs=irq_mode=1 in 
/boot/uEnv.txt on archlinux arm (kernel 4.4.23) and verified with

[root@alarm ~]# cat /proc/cmdline
console=ttyS0,115200 root=/dev/mmcblk0p1 rw rootwait irq_mode=1

But it still does not work:

[root@alarm ~]# rmmod ath10k_pci
[root@alarm ~]# modprobe ath10k_pci
[   28.791404] ath10k_pci 0000:02:00.0: Refused to change power state, 
currently in D3
[   28.829352] ath10k_pci 0000:02:00.0: failed to wake up device : -110
[   28.835861] ath10k_pci: probe of 0000:02:00.0 failed with error -110

Did i do something wrong? If somehow possible, i would prefer to not 
rebuild the kernel and somehow configure the existing one without changes.

Kind regards

Oli


Am 22.10.2016 um 13:55 schrieb Jonas Gorski:
> Hi,
>
> On 21 October 2016 at 18:25, Oliver Zemann <oliver.zemann@gmail.com> wrote:
>> The problem is gone with kernel 4.7.3 on armbian - both compex cards work
>> (wle600, wle900),
> Interesting to know this issue isn't present in 4.7 - I also
> encountered it in 4.4 with LEDE.
>
>> unfortunately that kernel does not support sfp (seems like
>> its kind of proprietary drivers from clearfog).
> They aren't really proprietary, they are proper patches that were
> submitted as RFC once, so it shouldn't be much effort to port them to
> e.g. 4.7. Anyways ...
>
>> So its a driver issue but i
>> have no clue who to contact or where to file a bug report. The only
>> available kernel which supports sfp (from solidrun, vendor of the clearfog
>> board) is 4.4.23
>>
>> I am wondering if i could simply checkout the 4.4.x sources, merge the
>> atheros drivers in it and try to rebuild the kernel?
> the issue seems to be that MSI interrupts do not work on 4.4 (at least
> with ath10k, didn't have any other drivers that support it to test).
> Your options are either to disable support for them in the kernel
> config, or pass irq_mode=1 to ath10k_pci on probe to force legacy
> interrupts; it should work then properly.
>
>
> Regards
> Jonas
