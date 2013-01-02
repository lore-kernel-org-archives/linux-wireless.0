Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4158 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab3ABHVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 02:21:32 -0500
Message-ID: <50E3DFD3.6010803@broadcom.com> (sfid-20130102_082136_940372_5EECBE11)
Date: Wed, 2 Jan 2013 08:20:51 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Vojtech Havel" <xhavel1@fi.muni.cz>
cc: linux-wireless@vger.kernel.org
Subject: Re: bugreport brcmsmac weak signal
References: <1707792.Sg5XObDUQq@ledge>
In-Reply-To: <1707792.Sg5XObDUQq@ledge>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/02/13 01:09, Vojtech Havel wrote:
> Hi,
> 
> I have problems with my Broadcom BCM4313 wifi card while using brcmsmac module.
> 
> The wifi signal is terribly weak. When the distance between my laptop and AP is 
> more than ~5 m the network is not visible at all. When the laptop is closer, 
> it connects, but it is very slow due to weak signal. I have to sit next to AP 
> when I want link quality more than 60/70.
> 
> If I use Broadcom hybrid driver - wl - it works normally (but has different 
> problems...).
> 
> I tried to use three different wifi networks with this combination and all of 
> them had the same problem.
> 
> -----
> My setting:
> $ uname -r
> 3.8.0-rc1
> 
> I applied the patch from:
> http://marc.info/?l=linux-wireless&m=135635090121154&w=2
> 
> The same with 3.5.7 gentoo kernel.
> -----
> wavemon info: (with brcmsmac, ~5 m between my laptop and the ap)
> 
> ┌─Interface────────────────────────────────────────────────
> │wlan0 (IEEE 802.11bgn, WPA/WPA2),  ESSID: "ihome"         
> ├─Levels───────────────────────────────────────────────────
> │                                                          
> │link quality: 23/70                                       
> │======================                                    
> │                                                          
> │signal level: -87 dBm (2,00 pW)                           
> │========                                                  
> │                                                          
> │                                                          
> ├─Statistics───────────────────────────────────────────────
> │RX: 3 8178(2,41 MiB), invalid: 0 nwid, 0 crypt, 0 frag, 3 misc
> │TX: 4 1789(779,619KiB), mac retries: 31, missed beacons: 0
> ├─Info─────────────────────────────────────────────────────
> │mode: Managed,  access point: (not relevant :-))           
> │freq: 2,437 GHz, channel: 6,  bitrate: 5,5 Mbit/s         
> │power mgt: off,  tx-power: 19 dBm (79,43 mW)             
> │retry: long limit 7,  rts/cts: off,  frag: off            
> │encryption: n/a (requires CAP_NET_ADMIN permissions)      
> ├─Network──────────────────────────────────────────────────
> │wlan0 (UP RUNNING BROADCAST MULTICAST)                    
> │mac: (not relevant :-)), qlen: 1000                        
> │ip: 192.168.1.103/24,  bcast: 255.255.255.255             
> └──────────────────────────────────────────────────────────
Hi Vojtech,
I see you are running v3.8-rc1, that's great since you can provide us
with the content of /sys/kernel/debug/brcmsmac/bcma0:0/hardware so we
know exactly which hardware you have.
Also dmesg contents would be helpful i think

Kind regards
Piotr

