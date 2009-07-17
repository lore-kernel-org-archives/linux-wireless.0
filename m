Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:16552 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934691AbZGQPTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 11:19:17 -0400
Subject: Re: any controller working in AP mode ?
From: Pavel Roskin <proski@gnu.org>
To: Ram kumar <ramkumar.research@gmail.com>
Cc: Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <445f43ac0907151344q6d80ddeckc0c586b34d8ca7c5@mail.gmail.com>
	 <6306c640907152338k4a5fb474h481d5adba97507b1@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 11:19:14 -0400
Message-Id: <1247843954.25608.62.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-16 at 12:08 +0530, Ram kumar wrote:
> hi,
> 
> > The thin firmware that allows using the 8383 with mac80211 and
> > implement an AP with hostapd is available here:
> > http://dev.laptop.org/pub/firmware/libertas/thinfirm/
> 
> Thanks for the reply.It looks like currently there are only two
> devices support AP mode with USB as an interface.
> 
> 1.MARVELL 8388.
> 2.RALINK - RT73USB.
> 
> But in the linux wireless website it says RT73USB doesn't support AP
> mode.I am assuming that site is not updated with recent
> information,please correct me if i am wrong.

It's hard to say if it's intentional or not.  rt2500usb is listed as
having AP support, and it's closely related to rt73usb.

I did a quick test with rt73usb.  hostapd starts sucessfully, and a
client using ath5k can connect and transmit data.  A client using ath9k
can connect (wpa_supplicant enters state CONNECTED), but no data goes
through.  The same client connects fine to a normal AP (D-Link DIR-615).

I don't have time to debug that issue right now, but you get the idea.
The AP mode can be enabled, but be prepared to some issues.

> It would be very helpful if anyone can guide me,how to get the
> hardware for MARVELL 8388.

5 minute search finds that Zonet ZEW2502 is what you need.  There is
only one driver for that device on the Zonet site, and it's clearly for
Marvell.

-- 
Regards,
Pavel Roskin
