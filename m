Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47294 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbXIVHNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 03:13:40 -0400
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Change the hardware radio enable logic and cleanup code
References: <46f319ef.8UBDQAjFjjfCblr5%Larry.Finger@lwfinger.net>
	<200709211522.01273.mb@bu3sch.de>
From: Kalle Valo <Kalle.Valo@iki.fi>
Date: Sat, 22 Sep 2007 10:05:21 +0300
In-Reply-To: <200709211522.01273.mb@bu3sch.de> (Michael Buesch's message of "Fri\, 21 Sep 2007 15\:22\:00 +0200")
Message-ID: <87d4wbnpse.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

>> Index: wireless-dev/drivers/net/wireless/b43legacy/leds.c
>> ===================================================================
>> --- wireless-dev.orig/drivers/net/wireless/b43legacy/leds.c
>> +++ wireless-dev/drivers/net/wireless/b43legacy/leds.c
>> @@ -182,6 +182,7 @@ void b43legacy_leds_update(struct b43leg
>>  	unsigned long interval = 0;
>>  	u16 ledctl;
>>  	unsigned long flags;
>> +	bool radio_enabled = (phy->radio_on && dev->radio_hw_enable);
>
> Just that you are aware of it:
> This is a racy access to the radio_hw_enable variable, as we don't take
> the mutex here (we can't and we don't want). But it's OK, since nobody
> cares if the LED is racing for a second and displays the wrong state
> for a second.
> Same goes for the phy->radio_on access.

As a side note, it would be nice to have this as a comment in the
code. Makes it easier for other people reading the code and wondering
if this a bug or not.

-- 
Kalle Valo
