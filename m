Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:36476 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752880Ab0EWFaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 May 2010 01:30:17 -0400
Message-ID: <4BF8BD68.9030006@dlasys.net>
Date: Sun, 23 May 2010 01:30:16 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: carl9170 1.0.9
References: <4BDC001F.9050202@dlasys.net> <201005021452.01101.chunkeey@googlemail.com> <4BF82CEE.8020502@dlasys.net> <201005230334.29866.chunkeey@googlemail.com>
In-Reply-To: <201005230334.29866.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2010 09:34 PM, Christian Lamparter wrote:
>> 	I beleive the timer_init() routine in carlfw/src/timer.c can not be
>> called for more than one timer. Any subsequent call will clear the
>> interrupt and mode bits for the previous timer.
>>      
> there's more than that.
> Take a look at the (timer<<  2) and so forth...
>    
     The control and interrupt registers are bitmasks.
     When you set the bit for the current timer you are clearing all the 
others.
> based on observation: Some timers(1-4) are *driven* by the cpu clock.
> Which is of course determined by the operation mode and phy band.
> As you know there are 7 (1 + 2 * 3) possible AHB/CPU clock settings:
>   * 40MHz (refclock)
>   * 20MHz (PSM, 5GHz)&  22MHz (PSM, 2.4GHz)
>   * 40MHz (11an, 5GHz, HT20)&  44Mhz (11bgn, 2.4GHz, HT20)
>   * 80MHz (11an, 5GHz, HT40)&  88MHz (11bgn, 2.4GHz, HT40)
>    
     Thanks I have been working alot more with the timers today.
     TSF follows the docs and is 1us.
     My docs say that CCR is 25ns and only 16 bit.
     But your code and that of the original ar9710-fw has it as 2 16 bit 
registers making 32bits.
     I have verified that and verified that it is pretty close to 25ns. 
in my system.

     But the remainder of the timers seem to be much much slower. My dos 
do not specify that they are tied to anything specific.

     I tripped over the AHB/CPU clock in the code. I need to look much 
more thoroughly at that, and I am going to need to work out exactly how 
it effects the other timers. I need the fastest timer I can get for my 
application.

     Thanks alot.

     i will pull 1.0.9.1 shortly








-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

