Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45517 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755107Ab0EBNsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 09:48:10 -0400
Message-ID: <4BDD828A.7010802@dlasys.net>
Date: Sun, 02 May 2010 09:47:54 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw II
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr> <4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
In-Reply-To: <201005021452.01101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2010 08:52 AM, Christian Lamparter wrote:
>
>    
>>       If necessary I can measure the times myself as delta's from one
>> event to another withing the SH2.
>>
>>       I have not digested the docs I have thoroughly yet but a cursory
>> review suggests a less than trivial project.
>>       I have not yet found a good high resolution clock inside the ar9170
>> there are alot of clocks but they all seem to be 16bit. Probably that
>> will make things harder.
>>      
> TSF timer could be used for this. (see 802.11-2007, Section 11 et seq.)
> It's a 2^64 bit timer with a 1us resolution and a accuracy _better_
> or equal to +/- 0.01%.
>
> The register address are at:
>   - 0x1c3514 (low, AR9170_MAC_REG_TSF_L, read only)
>   - 0x1c3518 (high, AR9170_MAC_REG_TSF_H, read only)
>
> But it comes at a small price: this timer is sometimes
> update&  synchronized (802.11 11.1.3.4 and 11.1.4) in
> station or ad-hoc mode. The exact details are hidden
> inside MAC chip, but it should be possible to disable
> both by selecting the monitor mode.
>    

     I will have to look into that it might work.
     I beleive this project is in ad-hoc mode,
     but if the timer is not being altered between the transmission of a 
packet and the receipt of its ACK I am fine,
     the worst case would be that it is and delta T becomes artificially 
smaller.  One characteristic of my problem is that
     almost all the error is positive delta T overly large.
>    
>>       I was expecting to have to make changes to the ar9170 firmware. I
>> was expecting to have to devise some means of passing that information
>> to the Linux driver and to the userspace application.
>>      
> Well, then you have two more good reasons why to use carl9170:
>
>   * the ar9170usb driver and ar9170 firmware don't track tx frames.
>     carl9170 on the other hand does (every frame has a 8 bit "cookie").
>     This feature was necessary to generate an accurate tx transmission
>     feedback report for every individual frame for the driver.
>    
    That would be necescary in my application and I have started to work 
with the carl9170 driver.
     I built the toolchain compiler the firmware and I am building a 
linux kernel right now.
>   * carl9170 has the ability to store additional per-frame data.
>     In fact, if you don't need to have a different retry rates
>     you could realloc the 3 * 32 bit "rr" (as in retry rate)
>     array in the carl9170_tx_superdesc and _carl9170_tx_superdesc
>     struct (see wlan.h) for your purposes (storage for your time values).
>
>     And if you fetched all the data, everything will be sent
>     with an ordinary tx status feedback report to the application
>     (add the timer fields into carl9170_tx_status and _carl9170_tx_status
>      struct - see fwcmd.h)
>    
     I need a delta T between some fixed point during the send and some 
fixed point during the ACK.
     And the MAC address of the device I was sending to. The latter 
already is obviously already known, I just have to tie to it.
>
> (* talked about this earlier, but you never know...
>
>     carlu _tool_ already provides a low-level HW driver for userspace.
>     This has the obvious advantage that you won't need to mess with
>     the kernel driver and network stacks.
>
>     The only work you'll have to do is: get the kernel code for
>     the MAC&  PHY initialization and put it into carlu.
>     But the framework is already there so it's mostly copy + paste )
>    
     I beleive you are using DEBUGFS and that was already part of my spec.
     Regardless, I am comfortable on the Linux driver side.
     The closer I get to the Linux side the more comfortable I am.

     Further though the actual timing of each send's delta T needs to be 
as accurate and fine grained as possible,
     everything else in this project is non-critical.  Within reason it 
is unimportant how long it takes to propigate data from the AR9170 
through to userspace,
     Clean and simple will take precedence over any other technical demands.
>> I would be happy to do that in some fashion that conformed to an existing
>> or future standard, but I was not anticipating a broad desire for what I am
>> doing.  Variable latencies are highly undesirable in this application,
>> but the userspace application will be aggregating large amounts of
>> information, if latencies in what is measured are constrained and the
>> unit of time measurement is small enough everything will work.
>> If it comes to that we switch to different hardware, but my project
>> is bringing a concept that was demonstrated with an expensive SDR to an
>> ar9170.
>>      
> It's always nice to have some "added value" for cheap and generic devices.
> e.g.: Atheros AR92xx chips can be used as among other stuff as a
>        full range spectrum analyzer.
>    
     And my ability to get consulting work is strongly effected by the 
extent I can contribute to Linux.
     References, and lists of skills and qualifications on my web site 
are dwarfed by
     Dave Lynch, DLA Systems <dhlii@dlasys.net> appearing inside the 
kernel tree.

     I love this work. I love working for myself, I want to continue to 
do so.
     I would contribute as I can regardless, but self interest helps.


> Regards,
> 	Chr
>    


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

