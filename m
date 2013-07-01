Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:57611 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab3GAPYB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 11:24:01 -0400
Message-ID: <51D19E50.6010007@01019freenet.de> (sfid-20130701_172405_376099_342F0B7F)
Date: Mon, 01 Jul 2013 17:20:48 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Gabor Juhos <juhosg@openwrt.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 00/19] rt2x00: add experimental support for RT3593
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org> <20130630105930.7f53165a@dualc.maya.org> <51D173EA.9030803@openwrt.org>
In-Reply-To: <51D173EA.9030803@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gabor,

Gabor Juhos wrote:
> Hi Andreas,
> 
>> bad guy is back again :-)
> 
> :)
> 
>>
>> Gabor Juhos wrote:
>>> This patch-set implements experiemental support for the
>>> RT3593 chipset. The patches are tested on the Linksys
>>> AE3000 USB device only, however other USB devices which
>>> are using the RT3573 chips might work as well.
>>
>> I did another test with raspberry pi. Same network parameters (2.4 GHz,
>> 40MHz, eap-tls, ccmp/ccmp) but this time w/o any other load on the
>> wlan. But there is a reinforced-concrete floor between AP and STA.
>>
>> netperf with rt2800usb / backports-20130617 / kernel 3.6.11 gives:
>>
>> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.39      28.16   
>> MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.00      30.23   
>> TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.35      27.69
>>
>>
>> Same with DPO_RT5572_LinuxSTA_2.6.1.3_20121022
>>
>> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.01      97.95   
>> MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.01     121.69   
>> TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
>> Recv   Send    Send                          
>> Socket Socket  Message  Elapsed              
>> Size   Size    Size     Time     Throughput  
>> bytes  bytes   bytes    secs.    10^6bits/sec  
>>
>>  87380  16384  16384    10.01      82.75
>>
>> If you compare the result w/ rt2800usb/AE3000 with rt2800usb/rt3572[1]
>> you can see: no difference :-(.
> 
> These results with the rt2800usb driver are quite bad. I don't yet have an idea
> what causes the huge performance loss on that platform.

One reason, from my point of view the main reason:
The rt2800usb driver causes to much interrupts (bad USB-handling). The
vendor driver uses a few interrupts with big data portions, rt2800usb
does it vice versa: small packets, but a lot more (1500 (14 Mbit/s) :
24.000 (9Mbit/s)).

See: http://article.gmane.org/gmane.linux.drivers.rt2x00.user/615

On systems with enough cpu resources, this problem doesn't hit that much
(but even there). But on all other systems, you're getting more or less
problems: all the more problems as worse the CPU resources get.

That's why rt5572sta performs mostly fine even with raspberry pi from my
point of view (besides the optimized rate control of the vendor driver).



Regards,
Andreas
