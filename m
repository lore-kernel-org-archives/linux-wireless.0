Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:32794 "EHLO
        mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753067AbcJWTdZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 23 Oct 2016 15:33:25 -0400
Received: by mail-vk0-f45.google.com with SMTP id 83so155757481vkd.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Oct 2016 12:33:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43544382-075a-6437-8f72-133a907d9def@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com> <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
 <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com> <43544382-075a-6437-8f72-133a907d9def@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Sun, 23 Oct 2016 21:33:03 +0200
Message-ID: <CAOiHx=kWh3P=Ye1Bnd35pRvwWyOdqEyYFVXvTTz60_Hj4TDFFg@mail.gmail.com> (sfid-20161023_213331_031704_2E0A1181)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Oliver Zemann <oliver.zemann@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 October 2016 at 17:53, Oliver Zemann <oliver.zemann@gmail.com> wrote:
> Thanks for that info Jonas. I passed optargs=irq_mode=1 in /boot/uEnv.txt on
> archlinux arm (kernel 4.4.23) and verified with
>
> [root@alarm ~]# cat /proc/cmdline
> console=ttyS0,115200 root=/dev/mmcblk0p1 rw rootwait irq_mode=1
>
> But it still does not work:
>
> [root@alarm ~]# rmmod ath10k_pci
> [root@alarm ~]# modprobe ath10k_pci
> [   28.791404] ath10k_pci 0000:02:00.0: Refused to change power state,
> currently in D3
> [   28.829352] ath10k_pci 0000:02:00.0: failed to wake up device : -110
> [   28.835861] ath10k_pci: probe of 0000:02:00.0 failed with error -110
>
> Did i do something wrong? If somehow possible, i would prefer to not rebuild
> the kernel and somehow configure the existing one without changes.

For the kernel command line you need to prefix with the module name,
i.e. "ath10k_pci.irq_mode=1". Alternative is while modprobing with
"modprobe ath10_pci irq_mode=1". See
<https://www.kernel.org/doc/Documentation/kernel-parameters.txt> for
details.

Regards
Jonas
