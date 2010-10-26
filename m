Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64734 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab0JZFle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Oct 2010 01:41:34 -0400
Received: by bwz11 with SMTP id 11so3089284bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 22:41:33 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Lee <lee-in-berlin@web.de>
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond authentication (2.6.36, rt73usb)
Date: Tue, 26 Oct 2010 07:40:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <4CC0D0F6.4080507@web.de> <4CC33E83.4020505@web.de>
In-Reply-To: <4CC33E83.4020505@web.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201010260740.47692.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Samstag 23 Oktober 2010 schrieb Lee:
> On 22/10/10 01:47, Lee wrote:
> > The test case is as follows: I have eth0 and wlan0 (the interface to an
> > rt37usb device) in a bridge lan0. I have a properly configured hostapd. When I
> > try to connect with a client to my hostapd AP, I can successfully
> > authenticate, but all further packets don't reach the interface of the AP.
> >
> > However, I can see broadcast packets *from* the AP on my client, but not the
> > other way round (DHCP requests from client to AP). To make sure the bug was
> > not specific to broadcast packets, I manually set an IP on my client and tried
> > to ping the AP, but those packets didn't come through, either.

[...] 

> I checked vanilla 2.6.36, the bug is still there. Is this a known bug? Does 
> anyone care to give me some hints? Are any details needed?

Please try to create a monitor interface on the rt73usb AP after setting it up:

# iw dev wlan0 interface add mon0 type monitor

and run a tcpdump on that (with XX:...:XX replaced by the MAC address of
your client):

# tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"

Do you see any frames from your specific client?

Helmut
