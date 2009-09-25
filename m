Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jupiter.gibraltar.at ([80.120.3.98]:54444 "EHLO
	mail1.gibraltar.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbZIYV3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:29:10 -0400
From: Rene Mayrhofer <rene.mayrhofer@gibraltar.at>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: Massive packet loss with ath9k, AR9280, hostapd in 802.11n mode
Date: Fri, 25 Sep 2009 23:29:00 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909252054.19762.rene.mayrhofer@gibraltar.at> <b6c5339f0909251352s4c30323awa588dd2f9f0d1af5@mail.gmail.com>
In-Reply-To: <b6c5339f0909251352s4c30323awa588dd2f9f0d1af5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200909252329.01897.rene.mayrhofer@gibraltar.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 25. September 2009 22:52:58 schrieb Bob Copeland:
> > 4. How do I tell CRDA to load frequency definitions for my location (AT)
> > instead of the default (US)? I might be blind, stupid, or both, but using
> > the slightly conflicting documentation available on various Wikis, I was
> > unable to change this. I have read that some chipsets are hard-wired for
> > one location and can't be changed, but couldn't find out if mine is (it
> > was bought in Europe, so shouldn't be locked to US in any case). An RTFM
> > (with an up-to-date pointer, preferrably for Debian/Ubuntu) in this
> > matter would be highly appreciated.
> 
> "iw reg set XX", but read this first:
> 
> http://wireless.kernel.org/en/users/Drivers/ath
> http://wireless.kernel.org/en/developers/Regulatory
> 
> In short, it depends on what's in your EEPROM.

Thanks for the pointers. Using compat-wireless-2.6 as of today, I get

 [ 1686.542910] cfg80211: Using static regulatory domain info                                                                          
[ 1686.542931] cfg80211: Regulatory domain: US                                                                                        
[ 1686.542947]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)                                                     
[ 1686.542976]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)                                                          
[ 1686.543004]  (5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                          
[ 1686.543031]  (5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                          
[ 1686.543058]  (5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                          
[ 1686.543085]  (5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)                                                          
[ 1686.543113]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)                                                          
[ 1686.543158] cfg80211: Calling CRDA for country: US 
[ 1698.498801] ath: EEPROM regdomain: 0x0                                                                                             
[ 1698.498820] ath: EEPROM indicates default country code should be used                                                              
[ 1698.498838] ath: doing EEPROM country->regdmn map search                                                                           
[ 1698.498862] ath: country maps to regdmn code: 0x3a                                                                                 
[ 1698.498880] ath: Country alpha2 being used: US                                                                                     
[ 1698.498896] ath: Regpair used: 0x3a                                                                                                
[ 1698.513630] phy0: Selected rate control algorithm 'ath9k_rate_control'                                                             
[ 1698.533093] cfg80211: Calling CRDA for country: US                                                                                 
[ 1698.555221] Registered led device: ath9k-phy0::radio                                                                               
[ 1698.555359] Registered led device: ath9k-phy0::assoc                                                                               
[ 1698.555490] Registered led device: ath9k-phy0::tx                                                                                  
[ 1698.555624] Registered led device: ath9k-phy0::rx                                                                                  
[ 1698.555680] phy0: Atheros AR9280 MAC/BB Rev:2 AR5133 RF Rev:d0: 
mem=0xd2780000, irq=9

Does this indicate that the EEPROM is locked to country code 0x0 (whatever 
that is, probably US)? "iw reg" doesn't seem to change anything:

[root@gibraltar-500 tmp]# iw reg get                                                     
country US:                                                                              
        (2402 - 2472 @ 40), (6, 27)                                                      
        (5170 - 5190 @ 40), (6, 23)                                                      
        (5190 - 5210 @ 40), (6, 23)                                                      
        (5210 - 5230 @ 40), (6, 23)                                                      
        (5230 - 5330 @ 40), (6, 23)                                                      
        (5735 - 5835 @ 40), (6, 30)                                                      
[root@gibraltar-500 tmp]# iw reg set 0x68
not a valid ISO/IEC 3166-1 alpha2
Special non-alpha2 usable entries:
        00      World Regulatory domain
[root@gibraltar-500 tmp]# iw reg set 00
command failed: Invalid argument (-22)
[root@gibraltar-500 tmp]# iw reg set AT
[root@gibraltar-500 tmp]# iw reg get
country US:
        (2402 - 2472 @ 40), (6, 27)
        (5170 - 5190 @ 40), (6, 23)
        (5190 - 5210 @ 40), (6, 23)
        (5210 - 5230 @ 40), (6, 23)
        (5230 - 5330 @ 40), (6, 23)
        (5735 - 5835 @ 40), (6, 30)
[root@gibraltar-500 tmp]# iw reg set EU
[root@gibraltar-500 tmp]# iw reg get
country US:
        (2402 - 2472 @ 40), (6, 27)
        (5170 - 5190 @ 40), (6, 23)
        (5190 - 5210 @ 40), (6, 23)
        (5210 - 5230 @ 40), (6, 23)
        (5230 - 5330 @ 40), (6, 23)
        (5735 - 5835 @ 40), (6, 30)

What I am still unsure about (having read the regulatory Wiki page before): 
are CRDA+regdb required to be able to change the regulatory domain or are they 
only responsible for updating the regulatory database for which a default 
already exists in the kernel?

If the EEPROM states that the device belongs to a specific domain, can this be 
overridden without patching the source?

best regards,
Rene

