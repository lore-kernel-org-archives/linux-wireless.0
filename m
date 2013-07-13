Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61224 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab3GMVSa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jul 2013 17:18:30 -0400
Received: by mail-ee0-f53.google.com with SMTP id c41so6960255eek.12
        for <linux-wireless@vger.kernel.org>; Sat, 13 Jul 2013 14:18:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51DC11F5.9080604@lwfinger.net>
References: <CC807E45-D614-4540-AD3F-160B56795851@gmail.com>
	<51DC11F5.9080604@lwfinger.net>
Date: Sun, 14 Jul 2013 00:18:28 +0300
Message-ID: <CAKaQZQ=yA=3cL_arLDu3gtDHJsCxmCmqrihY_QoTTDRKKaNnzA@mail.gmail.com> (sfid-20130713_231846_904891_DC8191D4)
Subject: Re: New device for ar5523
From: Dmitry Zganyaiko <dmitry.zganyaiko@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi! Thank you, that's helped and after entering these commands device
began to work, but:

But after some network activity through this device (`apt-get update`
- about ~2-3 MB downloaded and that was about ~60 secs after
successful modprobe) interface was deleted with following logs in
dmesg:

[362.612028] usb 1-3: TX queue stuck (tot 2 pend 2)
[362.612036] usb 1-3: Will restart dongle
[362.612272] usb 1-3: USB disconnect, device number 3
[362.612769] wlan0: deauthenticating from 90:f6:52:c6:3c:eb by local
choice (reason=3)
... <some logs from cfg80211 module>
[363.108058] usb 1-3: new high-speed USB device number 6 using ehci-pci
[363.241150] usb 1-3: New USB device found, idVendor=07d1, idProduct=3a0d
[363.241157] usb 1-3: New USB device string: Mfr=1, Product=2, Serial Number = 3
... <just another device info>
[365.240030] usb 1-3: timeout waiting for command reply
[365.240038] usb 1-3: could not initialize adapter
[365.240263] usb 1-3: RX USB error -2.
[365.240271] usb 1-3: error -1 when submitting rx usb
[365.240334] ar5523: probe of 1-3:1.0 failed with error -110

Switching off and ejecting adapter doesn't help: the same error repeated:
> ar5523: probe of 1-3:1.0 failed with error -110

But I found that rebooting to Windows makes the adapter working. After
that I rebooted back to Linux and adapter began to work about ~60
secs, but after that the same situation as described above repeated.

Also I noted following: without rebooting to Windows - just after
rebooting Linux - adapter does not work: _only_ after rebooting to
Windows and only now back to Linux. Windows is doing something with
adapter I do not know what, but after that adapter works for about 1
minute and disconnected with logs above.

What can I do now to solve that problem?
Dmitry.

On Tue, Jul 9, 2013 at 4:36 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/09/2013 03:59 AM, Dmitry Zganyaiko wrote:
>>
>> Hi! I'm using usb wireless adaptor named
>> 07d1:3a0d D-Link System DWA-120 802.11g Wireless 108G (taken from lsusb)
>>
>> System is Debian wheezy with 3.8 kernel taken from ubuntu reps. But after
>> launch this adaptor doesn't work: no any new network interfaces is shown in
>> ifconfig.
>>
>> As far as I understood, such vendor:product (07d1:3a0d) isn't specified in
>> drivers/net/wireless/ath/ar5523/ar5523.c, and therefore the driver doesn't
>> recognise my device. Firmware 'ar5523.bin' is located in
>> /usr/local/lib/firmware.
>>
>> What can I do to make this adaptor work? Only add that v:p pair to
>> ar5523.c and recompile it? Just if that can be done without compiling - it
>> will be great.
>
>
> You can test to see if it works with that kernel with the following commands
> (as root):
>
> modprobe -v ar5523
> echo 07d1 3a0d > /sys/bus/usb/drivers/ar5523/new_id
>
> If the device would work by adding that USB ID to the device table, then the
> above commands should accomplish the same result. Note - these commands will
> need to be re-entered after every reload of ar5523.
>
> Larry
>
