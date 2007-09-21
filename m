Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:56792
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627AbXIUNZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 09:25:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43legacy: Change the hardware radio enable logic and cleanup code
Date: Fri, 21 Sep 2007 15:22:00 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46f319ef.8UBDQAjFjjfCblr5%Larry.Finger@lwfinger.net>
In-Reply-To: <46f319ef.8UBDQAjFjjfCblr5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709211522.01273.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 21 September 2007 03:10:07 Larry Finger wrote:
> This change cleans up the radio-related messages in several ways.
> 
> (1) The state of the rfkill switch is assumed to be on, rather than
>     tested. Now, any user without such a switch will not see any
>     messages. For devices with such a switch, a message will be
>     logged only if the initial state is off, or if the switch is toggled.
> (2) The routine for testing the switch state is no longer inline.
> (3) The LED handling routine is simplified.
> (4) The "Radio turned off" message that has confused some users has been
>     changed to "Radio initialized".
> 
> This patch is patterned after a similar change to b43 by Michael Buesch.
> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

> Index: wireless-dev/drivers/net/wireless/b43legacy/leds.c
> ===================================================================
> --- wireless-dev.orig/drivers/net/wireless/b43legacy/leds.c
> +++ wireless-dev/drivers/net/wireless/b43legacy/leds.c
> @@ -182,6 +182,7 @@ void b43legacy_leds_update(struct b43leg
>  	unsigned long interval = 0;
>  	u16 ledctl;
>  	unsigned long flags;
> +	bool radio_enabled = (phy->radio_on && dev->radio_hw_enable);

Just that you are aware of it:
This is a racy access to the radio_hw_enable variable, as we don't take
the mutex here (we can't and we don't want). But it's OK, since nobody
cares if the LED is racing for a second and displays the wrong state
for a second.
Same goes for the phy->radio_on access.

The patch is ACKed by me.

-- 
Greetings Michael.
