Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:60685 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab0ATBka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 20:40:30 -0500
Received: by yxe17 with SMTP id 17so5698861yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 17:40:30 -0800 (PST)
Subject: b43 driver hang with bcm4318
From: Eric Volker <evolker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 19:40:22 -0600
Message-ID: <1263951622.3259.26.camel@fwdell4550>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have set up an access point with Ubuntu 9.10 and a Broadcom BCM4318
PCI card (manufacturer is Buffalo). After an undetermined period of
time, the card stops beaconing and even previously connected clients are
unable to ping the AP. After the driver hangs, trying to restart hostapd
fails with a "Failed to create mon.wlan0". The following commands:

#rmmod b43
#modprobe b43
#/etc/init.d/hostapd restart

will restart hostapd, and the AP will begin beaconing again. Clients can
associate with it, but are unable to ping the AP. Further examination
reveals that wlan0 on the AP has not been assigned an IP address. (My AP
does not have a DHCP daemon running as of yet; I've been manually
configuring the IP address of my clients.) Using ifconfig to assign the
IP address appears to work, but clients are still unable to ping the AP.
dmesg reveals no message from the b43 or other drivers about the hang;
however, upon restarting hostapd the driver appears to create a new
"phy".

[71500.473241] b43-phy1: Broadcom 4318 WLAN found (core revision 9)
[71500.540847] phy1: Selected rate control algorithm 'minstrel'
[71500.542002] Broadcom 43xx driver loaded [ Features: PL, Firmware-ID:
FW13 ]
[71543.312030] b43 ssb0:0: firmware: requesting b43/ucode5.fw
[71543.410639] b43 ssb0:0: firmware: requesting b43/pcm5.fw
[71543.430040] b43 ssb0:0: firmware: requesting b43/b0g0initvals5.fw
[71543.440062] b43 ssb0:0: firmware: requesting b43/b0g0bsinitvals5.fw
[71543.564029] b43-phy1: Loading firmware version 410.2160 (2007-05-26
15:32:10)
[71543.604432] Registered led device: b43-phy1::tx
[71543.604459] Registered led device: b43-phy1::rx
[71543.604485] Registered led device: b43-phy1::radio
[71554.360009] wlan0: no IPv6 routers present

Further back in the log, it can be seen where b43-phy0 was created, but
there is no record of the driver crashing or any other errors.
daemon.log does have several entries like this:

Jan 17 15:48:24 hostname avahi-daemon[759]: Invalid query packet.
Jan 17 15:49:33 hostname avahi-daemon[759]: last message repeated 2
times

Rebooting fixes the problem completely, but only temporarily. Anyone
seen this before, or have a suggested fix?

Thanks,

Eric Volker


