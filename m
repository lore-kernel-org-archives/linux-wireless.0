Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59163 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2LMSa1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 13:30:27 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1277720bkw.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 10:30:26 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard =?utf-8?q?R=C3=B6jfors?= <richard.rojfors@gmail.com>
Subject: Re: rtl8192cu in AP mode.
Date: Thu, 13 Dec 2012 19:30:20 +0100
Cc: linux-wireless@vger.kernel.org
References: <1355355956.2744.26.camel@asus>
In-Reply-To: <1355355956.2744.26.camel@asus>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212131930.21029.chunkeey@googlemail.com> (sfid-20121213_193045_921386_05C8D2D9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, December 13, 2012 12:45:56 AM Richard Röjfors wrote:
> I've been playing with an rtl8192 the last days, I want it to act as an
> access point. It's connected to an ARM9 box.
> 
> I'm using the latest compat-wireless, with some additional patches for
> beacon support.
> 
> My hostapd conf looks like this:
> interface=wlan0
> ssid=Test
> driver=nl80211
> hw_mode=b
> channel=6
> dtim_period=1
> 
> It almost works. Running hostapd and the networks shows up for my other
> machine, which can connect to the network.
> 
> I also get dhcp-requests through and corresponding dhcp responses. But
> then the oddness starts. ARP requests sent from the client is received
> on the AP side, the IP stack returns an ARP response, and I see it
> beeing sent by _rtl_submit_tx_urb and usb_submit_urb returns 0. But
> nothing is received on the other end.
> Sometimes, very rarely a response can get through, maybe 1 of 100 or so,
> or even less.

What's your client? Does it switch to power save mode after DHCP response
and is it an 11n client as well [same device? different device/driver -
yes I know you haven't enabled 11n, but still.]?

Regards,
	Chr
