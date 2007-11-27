Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:41783
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbXK0UWc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 15:22:32 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T V2] b43: Fix Radio On/Off LED action
Date: Tue, 27 Nov 2007 21:20:44 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de> <474C77E7.9030202@lwfinger.net>
In-Reply-To: <474C77E7.9030202@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711272120.44575.mb@bu3sch.de> (sfid-20071127_211142_119218_39CC2105)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 27 November 2007 21:02:47 Larry Finger wrote:
> Michael,
> 
> I'm getting a little closer. The problem I discovered now is that b43_leds_init() was being called
> before b43_rfkill_init(), which prevented registration of the "radio" LED. Now, the LED is flashed
> on for about 1 second, then it goes off. Changing the switch does nothing.

Ok, good catch.
Is the switch properly polled and is the status change properly reported upstream?
If yes, you might want to check (add printk to rfkill code) if the LED
is properly triggered.

> This version uses mutex_trylock() to see if the mutex is already locked. It should do until rfkill
> is fixed.

No it doesn't. This still introduces a race.

I'm wondering who causes this deadlock. "registered" should be false if
we are called back from rfkill_initialize, so it should return early before
the lock.

-- 
Greetings Michael.
