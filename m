Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:60976 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753965AbZG3DgI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2009 23:36:08 -0400
Received: by bwz19 with SMTP id 19so347419bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2009 20:36:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <109708.86209.qm@web15808.mail.cnb.yahoo.com>
References: <109708.86209.qm@web15808.mail.cnb.yahoo.com>
Date: Thu, 30 Jul 2009 04:36:07 +0100
Message-ID: <3ace41890907292036q7b9cb275uaeb01aff92e336e5@mail.gmail.com>
Subject: Re: The problem of driver of rtl8187 wireless card
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: gu gu <guatsheng@yahoo.com.cn>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/7/29 gu gu <guatsheng@yahoo.com.cn>:
>
> Dear Sir,
>     Rencently,I do a job to transplant a wireless wifi-card connected by the USB,which was designed baseing the chip rtl8187 for ARM board.But in the process i have some trouble in writing the driver programe.
>     My linux kernel is Version-2.6.25.10,It is true that the kernel have the driver for the chip rtl8187 .When I connected the wifi card through the USB port ,the kernel can recoganize the card "Manufacturer_Realtek_RTL8187",So it's sure that the driver of RTL8187 is no problem.But when I ping it to the AP,the missing of datapackets and the delay are both terrible.and more , there is nothing accepted by the wireless router when i typed the "ping".
> so i think there is some bug exist in the driver for RTL8187 of kernel ,isn't it? (ps: I have set several parameter,such essid ,IP address...)
>  So I download a "compat-wireless-2.6-old" packet.following the " Readme",i added the KLIB & KLIB_BUILD in the Makefile and "make" it.It is well to generate  some modules with the typing".o"! but has not compiled the file rtl8187 or generated a "rtl8187.o".
> and so i wanna to know how to solve this problem. i need some help from u,
> Thank you for your attention!

yes, the rtl8187 driver earlier than 26.28/29 were a bit buggy. You
should use compat-wireless, and 2.6 kernel modules are named *.ko. You
should have a rtl8187.ko, and you need a few others (4-5 in total) as
well. There were a reorg and rtl818x now has its own directory,
compared to earlier kernel tree.
