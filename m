Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.161]:61222 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaHWTGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 15:06:52 -0400
Received: from [192.168.178.25] (p5DDE7ABD.dip0.t-ipconnect.de [93.222.122.189])
	by smtp.strato.de (RZmta 35.8 DYNA|AUTH)
	with ESMTPSA id 502eebq7NJ0jZ3t
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-wireless@vger.kernel.org>;
	Sat, 23 Aug 2014 21:00:45 +0200 (CEST)
Message-ID: <53F8E4DC.60406@matthias-kastner.de> (sfid-20140823_210655_685657_354A08F6)
Date: Sat, 23 Aug 2014 21:00:44 +0200
From: Matthias Kastner <mail@matthias-kastner.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Atheros AR9001U
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello.
I'm having issues with my wireless usb stick. The model is supposed to 
be supportet, but breaks communication evry 10-20 min.
lsusb says about the stick:
  Bus 001 Device 007: ID 057c:8401 AVM GmbH Fritz!WLAN N [Atheros AR9001U]
The stick supports 11abgn networks. in 2.4 and 5 GHz range.
I'm using kernel 3.13.0-34-generic.

At the time I was using the built in version of carl.

Aug 23 20:02:43 uk-pc kernel: [ 4889.891261] usbcore: registered new 
interface driver carl9170
Aug 23 20:02:43 uk-pc kernel: [ 4889.895369] usb 1-4: driver   API: 
1.9.7 2012-12-15 [1-1]
Aug 23 20:02:43 uk-pc kernel: [ 4889.895376] usb 1-4: firmware API: 
1.9.6 2012-07-07

I updated manually to carl9170-1.fw-1.9.9 (I simply renamed the old fw 
and copyed the new one to /lib/firmware/carl9170-1.fw

The Syslog says about the crash:
Aug 23 20:23:37 uk-pc kernel: [ 6144.616517] usb 1-4: restart device (4)
Aug 23 20:23:39 uk-pc kernel: [ 6145.820619] usb 1-4: firmware upload 
failed (-110).
Aug 23 20:23:39 uk-pc kernel: [ 6145.821320] usb 1-4: Failed to restart 
device (-110).
Aug 23 20:23:39 uk-pc kernel: [ 6145.828552] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828561] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828568] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828575] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828582] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828588] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828594] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828601] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)
Aug 23 20:23:39 uk-pc kernel: [ 6145.828607] ieee80211 phy1: writing reg 
0x1c36f0 (val 0x2400) failed (-5)

Is there someone out there who can help me?
Regards,
Matthias
