Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41720 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054AbZHKQzF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 12:55:05 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1Mauco-00006j-J7
	for linux-wireless@vger.kernel.org; Tue, 11 Aug 2009 16:55:03 +0000
Received: from i577B7714.versanet.de ([87.123.119.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 16:55:02 +0000
Received: from manuel.schoelling by i577B7714.versanet.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 16:55:02 +0000
To: linux-wireless@vger.kernel.org
From: Manuel =?utf-8?b?U2Now7ZsbGluZw==?= <manuel.schoelling@gmx.de>
Subject: B43: MGMT (TX callback) fail
Date: Tue, 11 Aug 2009 16:51:04 +0000 (UTC)
Message-ID: <loom.20090811T163732-716@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm using hostapd 0.6.9 with b43 (Kernel 2.6.29-gentoo-r5-twam, 410.2160 of
Broadcom's proprietary driver) with this minimal config:

interface=wlan1
driver=nl80211
ssid=test

(I have two b43 cards: wlan0 and wlan1).
The ssid is not broadcasted and when I want to connect with my laptop (atheros
card), I get this debugging output:

Configuration file: hostapd.conf                  
Opening raw packet socket for ifindex 143960616   
BSS count 1, BSSID mask ff:ff:ff:ff:ff:ff (0 bits)
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=27 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=27 dBm 
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=27 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=27 dBm
RATE[0] rate=10 flags=0x2                                        
RATE[1] rate=20 flags=0x6                                        
RATE[2] rate=55 flags=0x4                                        
RATE[3] rate=110 flags=0x4                                       
Passive scanning not supported                                   
Flushing old station entries                                     
Deauthenticate all stations                                      
Using interface wlan1 with hwaddr 00:14:a4:30:20:2d and ssid 'test'
wlan1: Setup of interface done.                                    
MGMT (TX callback) ACK                                             
STA 00:15:af:12:a7:cb sent probe request for broadcast SSID        
MGMT (TX callback) fail                                            
mgmt::proberesp cb                                                 
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID        
MGMT (TX callback) ACK                                             
mgmt::proberesp cb                                                 
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID        
MGMT (TX callback) fail                                            
mgmt::proberesp cb                                                 
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID        
MGMT (TX callback) fail                                            
mgmt::proberesp cb                                                 
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID        
MGMT (TX callback) ACK                                             
mgmt::proberesp cb
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID
STA 00:c0:a8:cc:23:27 sent probe request for our SSID
MGMT (TX callback) fail
mgmt::proberesp cb
MGMT (TX callback) fail
mgmt::proberesp cb
STA 00:c0:a8:cc:23:27 sent probe request for our SSID
MGMT (TX callback) ACK
mgmt::proberesp cb
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
STA 00:c0:a8:cc:23:27 sent probe request for broadcast SSID
MGMT (TX callback) fail
mgmt::proberesp cb
^CSignal 2 received - terminating
Flushing old station entries
Deauthenticate all stations


Seems like there were the same problems with rt2x00
(http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?f=5&t=5005) but the patch
there only affects the rt2x00 driver.

Please ask if you need more information.

Cheers,
Manuel


