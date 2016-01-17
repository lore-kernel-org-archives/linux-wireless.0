Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f52.google.com ([209.85.215.52]:33400 "EHLO
	mail-lf0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbcAQWHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2016 17:07:41 -0500
Received: by mail-lf0-f52.google.com with SMTP id m198so161894847lfm.0
        for <linux-wireless@vger.kernel.org>; Sun, 17 Jan 2016 14:07:40 -0800 (PST)
Subject: Re: Fwd: 8192 WiFi Realtek 8192E disconnects after a while and fails
 to reconnect
To: gilbertdion@gmail.com, Larry.Finger@lwfinger.net,
	wlanfae@realtek.com, chaoming_li@realsil.com.cn
References: <CAKQFV0H+K46CO62w=9yNRvVaOpwmDj3UKXD0QOmF1XPs54GwnQ@mail.gmail.com>
 <CAKQFV0EV9WvmzJaUaFEGODc-kxpt=rXJVYe5Md4oM5H00cBaeQ@mail.gmail.com>
 <568EE125.1030103@gmail.com>
Cc: linux-wireless@vger.kernel.org
From: Mateusz Kulikowski <mateusz.kulikowski@gmail.com>
Message-ID: <569C10A9.8020200@gmail.com> (sfid-20160117_230750_356214_33CF4054)
Date: Sun, 17 Jan 2016 23:07:37 +0100
MIME-Version: 1.0
In-Reply-To: <568EE125.1030103@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

Hi Gilbert,

Small update from my side - It took me a while to setup x86_64 machine, 
but today was finally able to do test.


My result are the same as Larry:
I got my board running for ~4 hours and there was no disconnect.
For part of the time I was doing (some) activity, for around hour machine 
was idle.

I also did suspend-resume cycle.

System: Ubuntu 15.04 (from usb stick), kernel 3.19.0-15-generic, x86_64
Machine: MSI AM1I, Sempron 2650, 
PCIe to mini-pcie "wifi" bridge (with antenna connector and proper RFKILL 
wiring).


Are you able to do more troubleshooting?

Perhaps try different AP/Channel/mode, (dis)connect power cable from laptop etc.

I'll try to make another reproduction attempt, as without being able 
to reproduce it I will probably not be able to fix it.

Best Regards,
Mateusz


On 07.01.2016 23:05, Mateusz Kulikowski wrote:
[...]
> I've didn't catched it as my test setup uses old 32-bit netbook, 
> but will try to reproduce it during weekend on mini-pcie to pcie converter.
> 
> Mateusz
> 
> On 07.01.2016 21:34, Gilbert Dion wrote:
>> A few minutes after booting, the Wi-Fi disconnects and it fails to
>> reconnect until I restart the machine.
> 
>> [2] Full description of the problem/report
>> I start the machine, a Samsung R580 laptop and the Wi-Fi connects.
>> Then, after 5 or 10 minutes, while the Wi-Fi still appears to be
>> connected, I can no longer load web pages. Then, a few minutes later,
>> the Wi-Fi is disconnected. I tried some iconfig commands to try to
>> reconnect it, but it does not work.
>> It is crucial to notice that this happens only in 64 bit kernels. I
>> tested 3.13 to the latest upstream. The machine running a 32 bit
>> kernel stays connected forever.
> 
>> [3] keywords
> 
> 
>> [4] Linux version 4.4.0-040400rc8-generic (kernel@gloin) (gcc version
>> 5.2.1 20151010 (Ubuntu 5.2.1-22ubuntu2) ) #201601051225 SMP Tue Jan 5
>> 17:27:39 UTC 2016
> 
>> [5] Output of Ooops... message
>> Not applicable
> 
>> [6] ] A small shell script or example program which triggers the problem
>> Not applicable
> 
>> [7.] Environment
>> Description: Ubuntu 15.10
>> Release: 15.10
> 
>> [7.1] Software
>> If some fields are empty or look unusual you may have an old version.
>> Compare to the current minimal requirements in Documentation/Changes.
> 
>> Linux Samsung-Laptop 4.4.0-040400rc8-generic #201601051225 SMP Tue Jan
>> 5 17:27:39 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
[...]
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJWnBCjAAoJELvtohmVtQzBPm8H/0FRm9a8aJ5nmJNCDsS7CYRh
TSAbeHi/Pc59PPaqK4CIFZMhB1Mr0UxG/AxN0MiwM2YGzQLTK5Vd5wIF0p5GGTGh
/Yr5pFWv5qNx/3aIXj53/53YMBDeYogUrjsEc1hQ0FJlndq5z1m6bNgrs+f93/oL
wedkV7fFNhL2aot8nm48xelqsgw48Xhwj9fBrS6EIboscpA+srrh8mUzsxywqTfi
glFIrzkEdMVKqUutvRv4YuPQ2RiKSHrws+bl2UjhIfTINNfwl9TjHB8PDmzmuq3l
vHZbcPzNR5xgsZb9AtStn+OGQAUOorIcO4PZe4jaWL3olfQ7VjbBZWgkTkC/Nho=
=udfF
-----END PGP SIGNATURE-----
