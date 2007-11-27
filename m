Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.login.com ([192.195.240.2]:2138 "EHLO login.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755239AbXK0S3Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 13:29:16 -0500
Message-ID: <474C61F9.2020602@wetwork.net> (sfid-20071127_182920_052453_06BA727A)
Date: Tue, 27 Nov 2007 11:29:13 -0700
From: Ehud Gavron <gavron@wetwork.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [RFC/T] b43: Fix Radio On/Off LED action
References: <474c3fed.AWsUCELaFNf32i8C%Larry.Finger@lwfinger.net> <200711271713.02698.mb@bu3sch.de> <474C45B1.3050909@lwfinger.net> <200711271805.09304.mb@bu3sch.de>
In-Reply-To: <200711271805.09304.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Michael Buesch wrote:
> On Tuesday 27 November 2007 17:28:33 Larry Finger wrote:
>   
>> Michael Buesch wrote:
>>     
>>> On Tuesday 27 November 2007 17:03:57 Larry Finger wrote:
>>> This is not how led triggers work.
>>> You are shortcutting the whole thing here. So you could as well
>>> remove the whole rfkill and LEDs code.
>>>       
>> It just plain doesn't work now. What I'm trying to do is get something to the users that will
>> restore the behavior they want while we work out the details of the rfkill and LEDs code.
>>     
>
> Well, ok. But we don't apply this to mainline. As
> a temporary patch for users it's OK.
>   
Yes, it is! :)  Works great!
$ uname -a
Linux egdell.wetwork.net 2.6.24-rc3-LF27NOV2007 #2 SMP Tue Nov 27 
09:19:11 MST 2007 x86_64 x86_64 x86_64 GNU/Linux

E


>   
>>> Please properly register the LED in the leds code and
>>> add a default LED trigger for the rfkill trigger.
>>> This has several advantages to the user, among the possiblility to
>>> reassign a LED to a different trigger.
>>>       
>> How do I do that?
>>     
>
> Well, what you basically have to do it restore the old
> mapping in b43_map_led().
> Look at the "case B43_LED_RADIO_ALL" (and below) statement.
> It maps these LEDs to the rfkill trigger.
> So you have to find out which behaviour value your LED has and
> map that to the rfkill trigger in this function.
>
> So when the rfkill LED trigger triggers, it will enable/disable this LED.
> That's all done behind the scenes.
>
>   
>>>> @@ -70,11 +75,13 @@ static int b43_rfkill_soft_toggle(void *
>>>>  	struct b43_wldev *dev = data;
>>>>  	struct b43_wl *wl = dev->wl;
>>>>  	int err = 0;
>>>> +	int lock = mutex_is_locked(&wl->mutex);
>>>>  
>>>>  	if (!wl->rfkill.registered)
>>>>  		return 0;
>>>>  
>>>> -	mutex_lock(&wl->mutex);
>>>> +	if (!lock)
>>>> +		mutex_lock(&wl->mutex);
>>>>         
>>> Nah, it shouldn't be locked by "current" in the first place, here.
>>> (I guess that's what you are trying to check here).
>>> That's what the !registered check above is for.
>>> This !lock check is racy.
>>>       
>> If you recall my message from yesterday, I got a locking error. That is what I'm trying to prevent.
>> I know it is racy, but I don't know the correct way to do it.
>>     
>
> I think RFkill has a bad design regarding this.
> It does synchronously call back into the driver from a call made by
> the driver. That is broken by design. Maybe it's best to fix this
> in rfkill and let it asynchronously call back on rfkill_init.
> Synchronous callbacks from calls made by drivers are broken by design
> and will lead to recursive lockings. We can not fix this in the driver,
> nor work around it in a sane way. We can hack around it, though, which
> is what the !registered flag tries to do. Though, it seems it doesn't
> work. :)
>
>   
