Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm13-vm1.bullet.mail.ird.yahoo.com ([77.238.189.209]:31811 "HELO
	nm13-vm1.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751268Ab1AJTKK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 14:10:10 -0500
Message-ID: <801634.53195.qm@web29514.mail.ird.yahoo.com>
Date: Mon, 10 Jan 2011 19:10:08 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: RTL8187L: Can only "enable" hw radio switch after Windows boot
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Klaas De Craemer <klaasdc@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
In-Reply-To: <AANLkTi=iDFiuxKiCXCf54uAf4f1Vk-meNf=4J94Bn4a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Mon, 10/1/11, Klaas De Craemer <klaasdc@gmail.com> wrote:

> Hello all,
> 
> I can add to this that the rtl8187 driver seems to perform
> worse then
> its Windows counterpart (for this device anyway). Today,
> the Linux
> driver could not even connect anymore to the AP. Issuing
> "iwconfig
> wlan0 apname" just doesn't do anything. I could connect to
> another,
> more closer AP in Linux however.
> I'm very annoyed to announce that, despite the loss in
> flexibility, we
> will be moving this box to Windows because the wireless
> connection
> then "just works".
> I'll still check the list and I will remain available to
> test anything
> that could help the Linux driver though.

I would suggest you having a go at studying the windows driver under ndiswrapper, and using the kernel debugfs to study how the windows driver communicate with the device via USB and compared that with what the native driver is doing. That was how I got to be associated with the native driver - spotting what it was doing wrong/different from how the vendor linux driver was doing; the same should work with ndiswrapper+windows driver. (it did for a little bit, from personal experience).

There is no magic to it - if you want the driver to work for you, you can spend some time on it. You know the windows driver works "better" (for you), and there is a way to study the windows driver via ndiswrapper and compared that with the native driver, so it is do-able, just time and patience.

AFAIK, none of us have any special secret knowledge about the RTL8187L, much beyond what's publicly avaialable - i.e. the Realtek "official" driver code and a few spec sheets, and studying the windows driver via ndiswrapper; and AFAIK none of us are paid to work on the Realtek driver - Herton probably are paid to work on linux-things (given the e-mail address) but presumably not specifically on any one driver; I just happened to own a laptop with such a device built-in and Larry seems to be more or less of the same situation.

P.S. I am annoyed by the "I am very annoyed..." part of your e-mail message.



      
