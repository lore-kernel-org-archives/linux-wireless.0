Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:41839 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3F3JDK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jun 2013 05:03:10 -0400
Date: Sun, 30 Jun 2013 10:59:30 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 00/19] rt2x00: add experimental support for RT3593
Message-ID: <20130630105930.7f53165a@dualc.maya.org> (sfid-20130630_110315_143211_40776EDB)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gabor,

bad guy is back again :-)

Gabor Juhos wrote:
> This patch-set implements experiemental support for the
> RT3593 chipset. The patches are tested on the Linksys
> AE3000 USB device only, however other USB devices which
> are using the RT3573 chips might work as well.

I did another test with raspberry pi. Same network parameters (2.4 GHz,
40MHz, eap-tls, ccmp/ccmp) but this time w/o any other load on the
wlan. But there is a reinforced-concrete floor between AP and STA.

netperf with rt2800usb / backports-20130617 / kernel 3.6.11 gives:

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.39      28.16   
MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.00      30.23   
TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.35      27.69


Same with DPO_RT5572_LinuxSTA_2.6.1.3_20121022

MIGRATED TCP STREAM TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.01      97.95   
MIGRATED TCP MAERTS TEST from 0.0.0.0 () port 0 AF_INET from server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.01     121.69   
TCP SENDFILE TEST from 0.0.0.0 () port 0 AF_INET to server port 0 AF_INET
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.01      82.75

If you compare the result w/ rt2800usb/AE3000 with rt2800usb/rt3572[1]
you can see: no difference :-(.


Kind regards,
Andreas

[1] http://comments.gmane.org/gmane.linux.drivers.rt2x00.user/1992
