Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:51250 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3F2PG2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 11:06:28 -0400
Date: Sat, 29 Jun 2013 17:04:09 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 00/19] rt2x00: add experimental support
 for RT3593
Message-ID: <20130629170409.5df177d5@dualc.maya.org> (sfid-20130629_171317_744789_09700D02)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gabor,

Gabor Juhos wrote:
> This patch-set implements experiemental support for the
> RT3593 chipset. The patches are tested on the Linksys
> AE3000 USB device only, however other USB devices which
> are using the RT3573 chips might work as well.


I tested your patchset (and all the others) with the same device you
used for developing in a real life scenario. My AP
http://wikidevi.com/wiki/TP-LINK_TL-WDN4800 is configured for 2.4 GHz,
40MHz, 802.11n, EAP-TLS.

The AE3000 is used with a notebook / core i5 processor.

The test was done *during a parallel running full hd video* in the
same net with another AE3000 running on raspberry pi with ralinks own
driver *always w/o any stuttering* (that's why I'm buying such devices)!
There is a reinforced-concrete floor between AP and the STAs.

>From /var/log/messages:

kernel: [33425.890174] cfg80211: Calling CRDA to update world regulatory domain
kernel: [33425.894221] cfg80211: World regulatory domain updated:
kernel: [33425.894230] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [33425.894232] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [33425.894234] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [33425.894236] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
kernel: [33425.894238] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [33425.894240] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
kernel: [33425.973578] usb 2-1.5: reset high-speed USB device number 3 using ehci-pci
kernel: [33426.070273] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 3593, rev 0402 detected
kernel: [33426.102833] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 000d detected
kernel: [33426.103387] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
kernel: [33426.104122] usbcore: registered new interface driver rt2800usb
kernel: [33429.115258] ieee80211 phy0: rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'
kernel: [33429.115305] ieee80211 phy0: rt2x00lib_request_firmware: Info - Firmware detected - version: 0.33
kernel: [33429.359196] IPv6: ADDRCONF(NETDEV_UP): wlan2: link is not ready
kernel: [33432.884764] wlan2: authenticate with 11:22:33:44:55:66
kernel: [33432.937069] wlan2: send auth to 11:22:33:44:55:66 (try 1/3)
kernel: [33432.939615] wlan2: authenticated
kernel: [33432.940177] wlan2: associate with 11:22:33:44:55:66 (try 1/3)
kernel: [33432.943876] wlan2: RX AssocResp from 11:22:33:44:55:66 (capab=0x431 status=0 aid=1)
kernel: [33432.953244] wlan2: associated
kernel: [33432.953278] IPv6: ADDRCONF(NETDEV_CHANGE): wlan2: link becomes ready
kernel: [33432.953322] cfg80211: Calling CRDA for country: DE
kernel: [33432.957301] cfg80211: Regulatory domain changed to country: DE
kernel: [33432.957306] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
kernel: [33432.957310] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [33432.957313] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [33432.957316] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
kernel: [33432.957319] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)


netperf gives with rt2800usb on the notebook:

MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to server () port 0 AF_INET : demo
enable_enobufs failed: setsockopt
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.01      78.41   
MIGRATED TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET from server () port 0 AF_INET : demo
enable_enobufs failed: setsockopt
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.00     115.92   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to server () port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.02      86.46



The exactly same (=unchanged conditions) done with
DPO_RT5572_LinuxSTA_2.6.1.3_20121022 on the notebook gives:


MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to server () port 0 AF_INET : demo
enable_enobufs failed: setsockopt
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.02     130.36   
MIGRATED TCP MAERTS TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET from server () port 0 AF_INET : demo
enable_enobufs failed: setsockopt
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.00     131.23   
TCP SENDFILE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to server () port 0 AF_INET : demo
Recv   Send    Send                          
Socket Socket  Message  Elapsed              
Size   Size    Size     Time     Throughput  
bytes  bytes   bytes    secs.    10^6bits/sec  

 87380  16384  16384    10.03     131.33



Thanks,
kind regards,
Andreas
