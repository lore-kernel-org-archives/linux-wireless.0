Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56700 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758896AbXK0Q2p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:28:45 -0500
Message-ID: <474C45B1.3050909@lwfinger.net> (sfid-20071127_162912_124950_8A28E0CF)
Date: Tue, 27 Nov 2007 10:28:33 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC/T] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de>
In-Reply-To: <200711271713.02698.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Tuesday 27 November 2007 17:03:57 Larry Finger wrote:
> This is not how led triggers work.
> You are shortcutting the whole thing here. So you could as well
> remove the whole rfkill and LEDs code.

It just plain doesn't work now. What I'm trying to do is get something to the users that will
restore the behavior they want while we work out the details of the rfkill and LEDs code.

> Please properly register the LED in the leds code and
> add a default LED trigger for the rfkill trigger.
> This has several advantages to the user, among the possiblility to
> reassign a LED to a different trigger.

How do I do that?

>> @@ -70,11 +75,13 @@ static int b43_rfkill_soft_toggle(void *
>>  	struct b43_wldev *dev = data;
>>  	struct b43_wl *wl = dev->wl;
>>  	int err = 0;
>> +	int lock = mutex_is_locked(&wl->mutex);
>>  
>>  	if (!wl->rfkill.registered)
>>  		return 0;
>>  
>> -	mutex_lock(&wl->mutex);
>> +	if (!lock)
>> +		mutex_lock(&wl->mutex);
> 
> Nah, it shouldn't be locked by "current" in the first place, here.
> (I guess that's what you are trying to check here).
> That's what the !registered check above is for.
> This !lock check is racy.

If you recall my message from yesterday, I got a locking error. That is what I'm trying to prevent.
I know it is racy, but I don't know the correct way to do it.

Larry

