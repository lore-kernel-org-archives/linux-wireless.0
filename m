Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46305 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805AbYH1SFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 14:05:00 -0400
Message-ID: <48B6E8D5.5050003@lwfinger.net> (sfid-20080828_200506_380022_057EEBE4)
Date: Thu, 28 Aug 2008 13:05:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Susan Higashi <susanhigashi@gmail.com>
CC: =?ISO-8859-1?Q?Rafa=3F_Mi=3Fecki?= <zajec5polish@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Wireless Problems - Ubuntu 8.04
References: <b81ef96c0808271712t6ba1124cs6597a0efb8b6f0ea@mail.gmail.com>	 <14b026160808280046h5c9787c9m4eee1c6cccbad949@mail.gmail.com>	 <b81ef96c0808280444g2be951efxe9c6704db7f1f4fc@mail.gmail.com>	 <48B6C1FD.6060001@lwfinger.net> <b81ef96c0808281034g4360a9f9n261a55fda221e5b0@mail.gmail.com>
In-Reply-To: <b81ef96c0808281034g4360a9f9n261a55fda221e5b0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Susan Higashi wrote:
> Thanks for your explanation Larry, here is what you asked:
> 
> 07:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. 
> RTL8180L 802.11b MAC [10ec:8180] (rev 20)
>     Subsystem: Realtek Semiconductor Co., Ltd. RTL8180L 802.11b MAC 
> [10ec:8180]
>     Flags: medium devsel, IRQ 17
>     I/O ports at 1400 [disabled] [size=256]
>     Memory at 38000000 (32-bit, non-prefetchable) [disabled] [size=512]
>     Capabilities: [50] Power Management version 2

Your device should be handled by the driver rtl8180. Try the command 
'sudo /sbin/modprobe -rv rtl8180' to see what happens. If the driver 
loads with that command and your wireless device is available in 
iwconfig, then look for an entry in /etc/modprobe.d/blacklist that 
keeps it from loading.

Larry
