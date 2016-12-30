Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35234 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753287AbcL3AFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Dec 2016 19:05:30 -0500
Received: by mail-qk0-f171.google.com with SMTP id u25so274565969qki.2
        for <linux-wireless@vger.kernel.org>; Thu, 29 Dec 2016 16:05:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAHMXK7gqy9_PsZLKxTW7821XmGO1VOaD0Ex+gEsdzsXgwGenWg@mail.gmail.com>
References: <CAHMXK7gqy9_PsZLKxTW7821XmGO1VOaD0Ex+gEsdzsXgwGenWg@mail.gmail.com>
From: Agustin Martin <agustin6martin@gmail.com>
Date: Fri, 30 Dec 2016 01:05:28 +0100
Message-ID: <CAHMXK7ibzxuhB0MFcGHLAqWexLwXVYG8MgJxofNeeCsUDKTGtQ@mail.gmail.com> (sfid-20161230_010538_850797_5569A647)
Subject: Re: rtl8xxxu: Testing with 0BDA:8178 (TP-link TL-WN821N with 8192cu)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2016-12-29 17:22 GMT+01:00 Agustin Martin <agustin6martin@gmail.com>:
> Hi, Jes
>
> Sorry if you already received this feedback, I could not find references.
>
> I am trying a TP-LINK TL-WN821N wifi usb dongle with Realtek 8192cu
> (lsusb returns: 0bda:8178 Realtek Semiconductor Corp. RTL8192CU
> 802.11n WLAN Adapter) and found the same problems described in
>
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1365844
>
> When using kernel rtl8192cu driver, I can connect to wifi, but soon
> the connection is dropped.
>
> Since some time ago (2014) you asked for feedback in that bug and I
> did not find further references I decided to try your rtl8xxxu driver.
>
> All tests were carried out in a Debian GNU/Linux jessie box (current
> stable release) with kernel 4.7.8 from Debian jessie backports (source
> package linux_4.7.8-1~bpo8+1.dsc).
>
> Changed kernel config to
>
> ## file: drivers/net/wireless/realtek/rtl8xxxu/Kconfig
> ##
> CONFIG_RTL8XXXU=m
> CONFIG_RTL8XXXU_UNTESTED=y
>
> built a kernel (slooow here), installed it and added this line to a
> file under /etc/modprobe.d
>
> alias usb:v0BDAp8178d*dc*dsc*dp*icFFiscFFipFFin* rtl8xxxu
>
> If the dongle is initially connected, system loads the rtl8xxxu module
> instead of rtl8192cu when booting but seems not to initialize the
> dongle, so I have no connection. However, if I disconnect the dongle
> and reconnect it again with the system on, everything seems to work
> well with no connection dropping. Only minimally tested, but apart
> from the boot problem apparently much better than with the built-in
> rtl8192cu kernel module.

Hi again Jes, good news,

I do not know what I did wrong before, but I am retesting above kernel
and dongle and things seem to be working from the very beginning, no
problems found after plain boot (just need to enable the network
twice, but that also happemed with the old b/g dongle, may be
something with network manager).

This is not my usual box, it is slow  and I do not have it accesible
in a daily basis, but feel free to ask for further testing. Will try
to make my best.

Best regards,

-- 
Agustin
