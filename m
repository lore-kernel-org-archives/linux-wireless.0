Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:40049 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752345Ab0EASX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 May 2010 14:23:26 -0400
Message-ID: <4BDC719E.3060505@dlasys.net>
Date: Sat, 01 May 2010 14:23:26 -0400
From: "David H. Lynch Jr." <dhlii@dlasys.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar9170-fw II
References: <4BDC001F.9050202@dlasys.net> <201005011919.32016.chunkeey@googlemail.com>
In-Reply-To: <201005011919.32016.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/2010 01:19 PM, Christian Lamparter wrote:
>
> Well, for starters the ar9170 uses a ZyDas MAC (aka ZD1221)
> and a AR900x PHY/Radio. Therefore the phy code and registers
> are very similar to those #definitions you can find in ath9k.
> And for the MAC code&  registers you can look into zd1211rw,
> or look into drivers/staging/otus (original vendor driver,
> shares some code with their windows drivers)
>
> AFAICT, there are no technical documents about the AR9170
> solution available w/o signing a NDA with Atheros
> (probably because the devices are still produced and sold in high quantities?).
>    
     Thanks;
         I did just discover a reasonably good 150p spec. in what I 
received from my client.
         If I can I will share it. I am under an NDA, but the client 
also told me that they received no cooperation from atheros.
>> What is available for the ar9170 itself ?
>> How does the firmware and the linux driver communicate?
>>    Is there an overview of the firmware - what is where ?
>>      
> not really, apart from the headers of the original firmware
> and vendor drivers.
>
> But if you really need to implement some of your 'features'
> (what are they, if I may ask?)
     I think I can tell you what I am supposed add - I need to be able 
to provide userspace apps with precise timing information for each packet.
     Since i am working on GPL'd code and the results are going to be 
provided to third parties whatever I do is GPL'd too.
     Why gets into the NDA.

     Right now i have an NDA with a new client and though I am 
exercising care. But they seem fairly mellow. I am probably just being 
overly cautious.


> into the firmware you could
> save some time by migrating to carl9170 code base:
> ( http://www.kernel.org/pub/linux/kernel/people/chr/carl9170/1.0.5
>    + linville's wireless-testing.git )
>    
     The carl9170 code is the expected future of the ar9170 in Linux ?
     If so that is where I want to be working.
> The advantages over the original firmware code (from a developers POV) are:
>   * customizable/configurable fw
> 	+ driver can auto detect all selected fw features
>
>   * userspace testbench ( carlu ) for the usb subsystem
>     (allows you to run usb stress-test, dump the device's eeprom content
>      to stdout and of course: you can implement your own routines
>      and test&  develop without crashing the kernel)
>
>   * all hardware&  firmware interface definitions are all located
>     in a single directory /include/shared/*.h
>
> 	version.h	- carl9170 API/ABI version
> 	eeprom.h	- eeprom layout
> 	phy.h		- AR900x PHY/Radio definitions
> 	fwcmd.h		- implemented firmware commands
> 	fwdesc.h	- layout of the firmware descriptor (e.g. available/activated features)
> 	hw.h		- ZD1221 MAC + (Faraday USB) definitions
> 		wlan.h	- (part of hw.h&  phy.h) contains all the information about
> 				  tx&  rx frame formats.
>
>   * (tiny) printf + hexdump (obviously, you want those ;-) )
>
>   * follows linux' kernel coding style :-D
>    
     Thanks alot.
         I will look seriously at that.
         While I want to keep the scope of what I am doing small, and as 
narrowly confined as a I can,
     it would be nice if atleast some of my work was useful beyond the 
unique needs of my client.

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

