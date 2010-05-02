Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:58995 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755617Ab0EBLPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 May 2010 07:15:16 -0400
Message-ID: <4BDD5EB3.7020802@dlasys.net>
Date: Sun, 02 May 2010 07:14:59 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Benoit Papillault <benoit.papillault@free.fr>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw II
References: <4BDC001F.9050202@dlasys.net> <201005011919.32016.chunkeey@googlemail.com> <4BDC719E.3060505@dlasys.net> <201005012245.36589.chunkeey@googlemail.com> <4BDD2E05.40203@free.fr>
In-Reply-To: <4BDD2E05.40203@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2010 03:47 AM, Benoit Papillault wrote:
> Le 01/05/2010 22:45, Christian Lamparter a écrit :
>> On Saturday 01 May 2010 20:23:26 David H. Lynch Jr. wrote:
>>> I think I can tell you what I am supposed add - I need to be able
>>> to provide userspace apps with precise timing information for each 
>>> packet.
>>> Since i am working on GPL'd code and the results are going to be
>>> provided to third parties whatever I do is GPL'd too.
>>
>> if by precise timing you mean "exact mac time in TU/usecs when frame
>> was received at the radio", then you might have a _problem_.
>> You see, the firmware already receives fully packed frames from
>> the MAC processor and only _forwards_ them all [as is] in
>> one big DMA to the USB subsystem.
>> (this is done in src/wlan.c handle_rx())
>>
>> So, unless the HW has a _magic_ flag to enable this capability...
>> you are sort of screwed :-/.
>
> I would love this feature as well. I have a device to test if that can 
> help. I share the feeling of Christian however... but maybe your 
> documentation says something about a special flag.
    I am interested in round trip time as measured from some fixed point 
in the sending process to some fixed point in the packet acknowledgement.
    The more accurate the better. Preferably measured by events at the 
radio rather than on the linux side. I am interested in tx packets 
rather than rx packets.
     If necessary I can measure the times myself as delta's from one 
event to another withing the SH2.

     I have not digested the docs I have thoroughly yet but a cursory 
review suggests a less than trivial project.
     I have not yet found a good high resolution clock inside the ar9170 
there are alot of clocks but they all seem to be 16bit. Probably that 
will make things harder.

     I was expecting to have to make changes to the ar9170 firmware. I 
was expecting to have to devise some means of passing that information 
to the Linux driver and to the userspace application.  I would be happy 
to do that in some fashion that conformed to an existing or future 
standard, but I was not anticipating a broad desire for what I am 
doing.  Variable latencies are highly undesirable in this application, 
but the userspace application will be aggregating large amounts of 
information, if latencies in what is measured are constrained and the 
unit of time measurement is small enough everything will work.
     If it comes to that we switch to different hardware, but my project 
is bringing a concept that was demonstrated with an expensive SDR to an 
ar9170.

      I am still coming up to speed on some aspects of Wireless - I am 
not a complete noob, I have done ethernet drivers, and other very low 
level work. I have also worked with non-802.11 wireless, and network 
communications.  But three days ago I had only cursory understanding of 
how 802.11 works.

     I already greatly appreciate your assistance.



>
> Regards,
> Benoit
> -- 
> To unsubscribe from this list: send the line "unsubscribe 
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Dave Lynch 					  	    DLA Systems
Software Development:  				         Embedded Linux
717.587.7774 	       dhlii@dlasys.net 	  http://www.dlasys.net
Over 25 years' experience in platforms, languages, and technologies too numerous to list.

"Any intelligent fool can make things bigger and more complex... It takes a touch of genius - and a lot of courage to move in the opposite direction."
Albert Einstein

