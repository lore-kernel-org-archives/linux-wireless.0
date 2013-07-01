Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:43904 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442Ab3GAMTw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 08:19:52 -0400
Message-ID: <51D173EA.9030803@openwrt.org> (sfid-20130701_141955_721929_013C92B3)
Date: Mon, 01 Jul 2013 14:19:54 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 00/19] rt2x00: add experimental support for RT3593
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org> <20130630105930.7f53165a@dualc.maya.org>
In-Reply-To: <20130630105930.7f53165a@dualc.maya.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

> bad guy is back again :-)

:)

> 
> Gabor Juhos wrote:
>> This patch-set implements experiemental support for the
>> RT3593 chipset. The patches are tested on the Linksys
>> AE3000 USB device only, however other USB devices which
>> are using the RT3573 chips might work as well.
> 
> I did another test with raspberry pi. Same network parameters (2.4 GHz,
> 40MHz, eap-tls, ccmp/ccmp) but this time w/o any other load on the
> wlan. But there is a reinforced-concrete floor between AP and STA.
> 
> netperf with rt2800usb / backports-20130617 / kernel 3.6.11 gives:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.39      28.16   
> MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.00      30.23   
> TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.35      27.69
> 
> 
> Same with DPO_RT5572_LinuxSTA_2.6.1.3_20121022
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.01      97.95   
> MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.01     121.69   
> TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
> Recv   Send    Send                          
> Socket Socket  Message  Elapsed              
> Size   Size    Size     Time     Throughput  
> bytes  bytes   bytes    secs.    10^6bits/sec  
> 
>  87380  16384  16384    10.01      82.75
> 
> If you compare the result w/ rt2800usb/AE3000 with rt2800usb/rt3572[1]
> you can see: no difference :-(.

These results with the rt2800usb driver are quite bad. I don't yet have an idea
what causes the huge performance loss on that platform.

Although I don't have a Raspberry Pi nor any RT3572 based USB device, but I can
test the AE3000 on a few different embedded platforms. I will do some
performance tests on those once I have fixed the AP mode support for the RT3593.

-Gabor

