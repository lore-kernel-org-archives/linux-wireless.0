Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:32779 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753962AbcJXLPP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 07:15:15 -0400
Received: by mail-ua0-f173.google.com with SMTP id 6so12933976uat.0
        for <linux-wireless@vger.kernel.org>; Mon, 24 Oct 2016 04:15:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <faedb36a-d99c-5891-e9c6-40ecc4d54748@gmail.com>
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
 <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com> <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
 <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com> <bffb5d2b-03f3-f451-dd01-ef2c796bfc30@gmail.com>
 <CAOiHx==nbvwiiMZaqg5okdM6ab9ZLc+JOPdHdJJMUh9uhEt3PQ@mail.gmail.com>
 <43544382-075a-6437-8f72-133a907d9def@gmail.com> <CAOiHx=kWh3P=Ye1Bnd35pRvwWyOdqEyYFVXvTTz60_Hj4TDFFg@mail.gmail.com>
 <faedb36a-d99c-5891-e9c6-40ecc4d54748@gmail.com>
From: Jonas Gorski <jonas.gorski@gmail.com>
Date: Mon, 24 Oct 2016 13:14:53 +0200
Message-ID: <CAOiHx=mY8DtgM-DxxqQW9U0=PeMjUbuvBsEjVbLissV6tVyYcA@mail.gmail.com> (sfid-20161024_131519_262603_0AA19E23)
Subject: Re: compex wle900vx (ath10k) problem on 4.4.24 / armv7
To: Oliver Zemann <oliver.zemann@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

(please don't toppost)

On 23 October 2016 at 21:42, Oliver Zemann <oliver.zemann@gmail.com> wrote:
> Thanks, but its still not working. I dont get any error now when i do
> modprobe and installed is the wle900
>
> [root@alarm alarm]# rmmod ath10k_pci
> [root@alarm alarm]# modprobe ath10k_pci irq_mode=1

Strange, this was working for me with a Sparklan WPEA-352ACN.

>
> but:
>
> [root@alarm alarm]# dmesg | grep ath10k
> [  220.356314] ath10k_pci 0000:02:00.0: Refused to change power state,
> currently in D3

Maybe there is a separate issue related to this. I don't remember
seeing this message in my kernel log. (At least to me) it would be
interesting to know if it works using a LEDE image, or if it fails
there as well. I don't have a Compex card here.

You can find an sd-card image at
https://downloads.lede-project.org/snapshots/targets/mvebu/generic/ -
it won't contain any wifi drivers though, you will need to install
them separately - easiest by providing internet access over the wan
port (the single ethernet port for the pro, it defaults to dhcp
client), then running "opkg install kmod-ath10k" on shell.

Note that this kernel has MSI disabled, so you don't need to do
anything there extra.

> [  220.394265] ath10k_pci 0000:02:00.0: failed to wake up device : -110
> [  220.400770] ath10k_pci: probe of 0000:02:00.0 failed with error -110
>
> [root@alarm alarm]# cat /proc/cmdline
> console=ttyS0,115200 root=/dev/mmcblk0p1 rw rootwait ath10k_pci.irq_mode=1
>
> Thanks for your patience

Regards
Jonas
