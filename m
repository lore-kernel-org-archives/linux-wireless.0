Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:50197 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849Ab2LLXqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 18:46:01 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1216595lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 15:46:00 -0800 (PST)
Message-ID: <1355355956.2744.26.camel@asus> (sfid-20121213_004607_071828_4BA885A1)
Subject: rtl8192cu in AP mode.
From: Richard =?ISO-8859-1?Q?R=F6jfors?= <richard.rojfors@gmail.com>
To: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 00:45:56 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

I've been playing with an rtl8192 the last days, I want it to act as an
access point. It's connected to an ARM9 box.

I'm using the latest compat-wireless, with some additional patches for
beacon support.

My hostapd conf looks like this:
interface=wlan0
ssid=Test
driver=nl80211
hw_mode=b
channel=6
dtim_period=1

It almost works. Running hostapd and the networks shows up for my other
machine, which can connect to the network.

I also get dhcp-requests through and corresponding dhcp responses. But
then the oddness starts. ARP requests sent from the client is received
on the AP side, the IP stack returns an ARP response, and I see it
beeing sent by _rtl_submit_tx_urb and usb_submit_urb returns 0. But
nothing is received on the other end.
Sometimes, very rarely a response can get through, maybe 1 of 100 or so,
or even less.

If I send another DHCP request, I get the response immediately. So the
problem seems to be related to ARP. I ran some http when I got the
very-rare-arp-reply and that works too.

I thought that ARP responses might be sent really quickly compared to
dhcp and http since the replies would require interaction with
userspace. So I played with some delays before sending the arp response,
without any luck.

Any ideas anyone?

Thanks
Richard

