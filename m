Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f177.google.com ([209.85.214.177]:33858 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbaANVu5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 16:50:57 -0500
Received: by mail-ob0-f177.google.com with SMTP id va2so251362obc.8
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jan 2014 13:50:56 -0800 (PST)
Message-ID: <52D5B13C.3040006@lwfinger.net> (sfid-20140114_225101_098345_08A4C09D)
Date: Tue, 14 Jan 2014 15:50:52 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: andrea.merello@gmail.com,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
CC: John Linville <linville@tuxdriver.com>,
	Greg Kroah-Hartman <greg@kroah.com>,
	linux-wireless@vger.kernel.org
Subject: Re: RTL8187SE staging Linux driver
References: <CAN8YU5NTKUtS8+YzmcOSM3=YUX-FSwLTD86F_hXsNdVkw5NEGA@mail.gmail.com>	<522F584E.6000806@lwfinger.net>	<CAN8YU5PCFj-gtQwuuR3fM52YAVTi_5NYPbDVj-KMSzMpXjvFWQ@mail.gmail.com> <CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
In-Reply-To: <CAN8YU5PGkx9s9deWpFTO_ZtDr-+wDD5cX2JRv1zd1m1Q0BpkCw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2014 11:40 AM, Andrea Merello wrote:
> Hello Bernhard,
>
> Are you still curious to test something ? :)
> I attach a patch that should apply to wireless-testing..
>
> I still have several items pending on my TODO list, including things
> to tidy/fix, and things that are currently missing, however  I'm
> getting encouraging results on my setup..
>
> If this works for you, and if other people in CC here agree, I may
> starting split this mega-patch in something more suitable for kernel
> maintainers to merge (currently it even changes few misleading names
> in the common register struct, affecting also rtl8187 driver)..
>
> Let me know if it works :)

Andrea,

Building your version gets the following warning:

   CC [M]  drivers/net/wireless/rtl818x/rtl8187/rfkill.o
drivers/net/wireless/rtl818x/rtl8187/dev.c: In function ‘rtl8187_set_anaparam’:
drivers/net/wireless/rtl818x/rtl8187/dev.c:596:3: warning: passing argument 2 of 
‘rtl818x_iowrite8’ from incompatible pointer type [enabled by default]
In file included from drivers/net/wireless/rtl818x/rtl8187/dev.c:32:0:
drivers/net/wireless/rtl818x/rtl8187/rtl8187.h:237:20: note: expected ‘u8 *’ but 
argument is of type ‘__le16 *’

The easy fix is to change that to an ...iowrite16() call. So far, my testing to 
see if writing that extra byte messes up the RTL8187B has not shown any 
problems; however, I have not yet tested on a big-endian machine.

Have you given any thought to renaming the driver? It seems to me that rtl8180 
was probably not right when it drove both RTL8180 and RTL8185, and it is even 
less appropriate today.

The driver connects to the following APs:

802.11n running WPA2
802.11g running WPA1
802.11g running WEP

Looks good.

Larry




