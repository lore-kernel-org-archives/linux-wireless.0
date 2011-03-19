Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:41255 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757666Ab1CSWcD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Mar 2011 18:32:03 -0400
Date: Sat, 19 Mar 2011 23:31:59 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Richard Kettlewell <rjk@greenend.org.uk>
Cc: linux-wireless@vger.kernel.org, 618930@bugs.debian.org,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: Bug#618930: High network latency with ralink usb wireless
 device
Message-ID: <20110319223159.GA19576@sig21.net>
References: <4D84E433.70001@greenend.org.uk>
 <1300555815.26693.83.camel@localhost>
 <4D84EC90.4090803@greenend.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D84EC90.4090803@greenend.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 19, 2011 at 05:49:04PM +0000, Richard Kettlewell wrote:
> (see also bugs.debian.org/618930
...
> I have a TP-Link TL-WN321G USB wireless adapter, which is a badged
> Ralink RT2070.  Under Debian's 2.6.32 this worked smoothly with
> rt2870sta.  On upgrading to Debian's 2.6.38, however, only rt2800usb
> was available and with that I found that ping latency is around
> 600ms.
...
>           Power Management:on

I sent a patch to disable power save by default, but then work started
to fix it instead, but then stalled.  Seems like 2.6.38 shipped with
broken power save enabled by default.  Plese read the discussion
following my RFC patch:
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/thread.html#3017

You can test if power saving causes your issue by disabling
it with "iwconfig wlan0 power off".

Johannes
