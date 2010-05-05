Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:55415 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757772Ab0EESl2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 May 2010 14:41:28 -0400
Message-ID: <4BE1BBD6.3030505@dlasys.net>
Date: Wed, 05 May 2010 14:41:26 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
Reply-To: dhlii@dlasys.net
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: carl9170 1.0.5.1
References: <4BDC001F.9050202@dlasys.net> <4BDD2E05.40203@free.fr> <4BDD5EB3.7020802@dlasys.net> <201005021452.01101.chunkeey@googlemail.com>
In-Reply-To: <201005021452.01101.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

     I am trying to build a kernel using the carl9170 driver/firmware.
     I am not particular about what kernel or how so long as I can get 
it running.

     When I build out of the wireless-testing git tree (puled today) 
2.6.34-rc6
     using my current systems .config I get a very quick error on boot 
about PCI bridge windows.
     googling the error indicates this is a know 2.6.34 problem and that 
there are fixes in other 2.6.34 trees.
     I have been unable to find the actual patches or I would just apply 
them to wireless-testing.

     Alternately, I tried to build out of the ubuntu-lucid git tree. 
2.6.32 again with my existing .config.
     I the carl9170 driver does not build. While I found patches at 
OpenWRT that are supposed to allow building carl9170 with 2.6.33 or less,
     the errors are unrelated to what is changed by those patches.

     I have also tried using linux-source-2.6.32 pulled from cannonical 
via apt for my install rather than the ubuntu-lucid git tree
     with similar results.

On 05/02/2010 08:52 AM, Christian Lamparter wrote:
> On Sunday 02 May 2010 13:14:59 David H. Lynch Jr. wrote:
>    
>> On 05/02/2010 03:47 AM, Benoit Papillault wrote:
>>      
>>> Le 01/05/2010 22:45, Christian Lamparter a écrit :
>>>        
>>>> On Saturday 01 May 2010 20:23:26 David H. Lynch Jr. wrote:
>>>>          
>>>>> I think I can tell you what I am supposed add - I need to be able
>>>>> to provide userspace apps with precise timing information for each
>>>>> packet.
>>>>> Since i am working on GPL'd code and the results are going to be
>>>>> provided to third parties whatever I do is GPL'd too.
>>>>>            
>>>> if by precise timing you mean "exact mac time in TU/usecs when frame
>>>> was received at the radio", then you might have a _problem_.
>>>> You see, the firmware already receives fully packed frames from
>>>> the MAC processor and only _forwards_ them all [as is] in
>>>> one big DMA to the USB subsystem.
>>>> (this is done in src/wlan.c handle_rx())
>>>>
>>>> So, unless the HW has a _magic_ flag to enable this capability...
>>>> you are sort of screwed :-/.
>>>>          
>>> I would love this feature as well. I have a device to test if that can
>>> help. I share the feeling of Christian however... but maybe your
>>> documentation says something about a special flag.
>>>        
>>      I am interested in round trip time as measured from some fixed point
>> in the sending process to some fixed point in the packet acknowledgement.
>>      The more accurate the better. Preferably measured by events at the
>> radio rather than on the linux side.
>>      
>    
>> I am interested in tx packets rather than rx packets.
>>      
> ahh, well... there goes' benoit interest ;).
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
>    
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
> Regards,
> 	Chr
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>    


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

