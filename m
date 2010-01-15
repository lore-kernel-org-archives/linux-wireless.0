Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52184 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758452Ab0AOWkn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 17:40:43 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Ath5k on 2.6.32 suddenly fails
Date: Fri, 15 Jan 2010 23:40:39 +0100
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Bob Copeland <me@bobcopeland.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <201001101152.34316.mb@bu3sch.de> <201001112336.50125.mb@bu3sch.de> <201001152330.00470.mb@bu3sch.de>
In-Reply-To: <201001152330.00470.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001152340.40127.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 January 2010 23:29:59 Michael Buesch wrote:
> On Monday 11 January 2010 23:36:49 Michael Buesch wrote:
> > I currently have one and a half days of uptime. I think I'll first
> > continue running .32 to check whether it happens again or if this was just
> > some random hardware burp.
> > I think it should be likely to trigger again within one or two days, if this is a bug.
> 
> mb@quimby:~$ uptime
>  23:23:34 up 5 days, 11:49,  1 user,  load average: 0.00, 0.00, 0.00
> 
> So, it didn't trigger, yet.
> I think I will assume for now that we had a hardware burp and this
> is not caused by a software bug. The AP is used a lot and it currently
> is rock-stable on 2.6.32.
> 
> The card is a minipci connected through a minipci->pci converter card.
> I know that the converter does not have high quality contact pins, so I
> currently blame the converter card for flipping a bit.
> I think I'll replace it by something better soon.
> 
> So let's close this, unless I come back to you guys with new results.
> 

Argh, so exactly one minute after sending this mail the AP died. -.-

There also are a bunch of jumbo messages in dmesg, but they are probably unrelated:

[177589.693544] ath5k phy0: unsupported jumbo
[264620.683114] ath5k phy0: unsupported jumbo
[276726.009197] ath5k phy0: unsupported jumbo
[348619.483527] ath5k phy0: unsupported jumbo
[349918.090802] ath5k phy0: unsupported jumbo
[438574.817309] ath5k phy0: unsupported jumbo
[457967.099642] ath5k phy0: unsupported jumbo

However, it had different failure symptoms this time.
Last time it failed, the AP was completely dead. No beacons, etc..
This time it was still beaconing, but auth failed:

Trying to associate with 00:1d:0f:b9:df:2d (SSID='quimby-net' freq=2472 MHz)
Authentication with 00:1d:0f:b9:df:2d timed out.

A machine reboot was _not_ needed this time to revive the card.
Module unload cycle was enough to bring it back to life.

I'm really unsure what's going on and if these two failures are related
to each other. Probably not...

-- 
Greetings, Michael.
