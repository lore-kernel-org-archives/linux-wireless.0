Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58498 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaLWRRS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 12:17:18 -0500
Message-ID: <5499A391.2060705@rempel-privat.de> (sfid-20141223_181721_766725_78935D3F)
Date: Tue, 23 Dec 2014 18:17:05 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Jeremy Audet <ichimonji10@gmail.com>
CC: linux-wireless@vger.kernel.org, Adrian Chadd <adrian@freebsd.org>
Subject: Re: bug report for ath9k_htc driver
References: <CA+A7n+jFWWs-U2DapExRqYgK=e2kGowPzFHJPh72DRwzBmVggg@mail.gmail.com>	<54991B32.2010105@rempel-privat.de> <CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
In-Reply-To: <CA+A7n+hbr2ctPkSta9-MWT1opAT2hCB9jYHvFu7N3C_ZvxXSzw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 23.12.2014 um 16:31 schrieb Jeremy Audet:
> Hi Oleksij,
> 
> Sure thing. I cloned your ath9k-htc-firmware-blob repository and
> copied the htc_9271.fw file to /usr/lib/firmware/. I then plugged in
> the TL-WN722N USB adapter, brought up the wireless device with `sudo
> ip link set dev wlp0s18f2u4 up; echo $?` (return code 0), and sat back
> and waited. I did not interact with the machine beyond keeping open an
> SSH session (via a wired interface) and watching the log file. About
> five minutes later, a similar error occurred as described in my
> previous email.
> 
> I've collected some logging output with the command `journalctl -k
> --since=today`. You may find this log a bit more useful than the dmesg
> log linked to in my previous email. You can find the log here:
> http://www.ichimonji10.name/downloads/tl-wn722n-journalctl.txt
> 
> -Jeremy "Ichimonji10" Audet
> 

So, at some point usb layer dropped connection, and reconnected in
full-speed mode, which is slow:
=================================================================
Dec 23 10:07:49 pine kernel: usb 5-4: USB disconnect, device number 9
Dec 23 10:07:49 pine kernel: ath: phy6: Failed to wakeup in 500us
Dec 23 10:07:50 pine kernel: ath: phy6: RX failed to go idle in 10 ms
RXSM=0xb063df84
Dec 23 10:07:50 pine kernel: ath: phy6: Failed to wakeup in 500us
Dec 23 10:07:50 pine kernel: usb 5-4: ath9k_htc: USB layer deinitialized
Dec 23 10:07:50 pine kernel: usb 5-4: new high-speed USB device number
10 using ehci-pci
Dec 23 10:07:51 pine kernel: usb 1-4: new full-speed USB device number 5
using ohci-pci
Dec 23 10:07:51 pine kernel: usb 1-4: not running at top speed; connect
to a high speed hub
Dec 23 10:07:51 pine kernel: usb 1-4: ath9k_htc: Firmware htc_9271.fw
requested
Dec 23 10:07:51 pine kernel: usb 1-4: ath9k_htc: Transferred FW:
htc_9271.fw, size: 51008
==================================================================

After reconnecting to fulls-speed, ath9k-htc was unusable. I would
suggest to test other cable or other usb controller.
With other words, I have no idea about the reason for initial
disconnection. It can be bad usb connection, noise or not enough power.

-- 
Regards,
Oleksij
