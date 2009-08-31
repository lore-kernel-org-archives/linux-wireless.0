Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:58428 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZHaJ62 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 05:58:28 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mi3ef-0007mp-A5
	for linux-wireless@vger.kernel.org; Mon, 31 Aug 2009 11:58:29 +0200
Received: from f051082234.adsl.alicedsl.de ([78.51.82.234])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 11:58:29 +0200
Received: from keinstein_junior by f051082234.adsl.alicedsl.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2009 11:58:29 +0200
To: linux-wireless@vger.kernel.org
From: Tobias Schlemmer <keinstein_junior@gmx.net>
Subject: Re: rtl8187b Problem with tx level
Date: Mon, 31 Aug 2009 11:59:36 +0200
Message-ID: <h7g6rd$dvb$1@ger.gmane.org>
References: <h7eo7q$7ks$1@ger.gmane.org> <4A9B0479.209@lwfinger.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080203090906070002030807"
In-Reply-To: <4A9B0479.209@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080203090906070002030807
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

thank you for your quick answer.

Larry Finger schrieb:
> Tobias Schlemmer wrote:
>> Interestingly iwconfig always reports TX power of 20dBm, regardless of
>> the actual tx power, but always a TX rate of 1M. Setting the latter to a
>> higher value results in packet loss.
> 
> Where are you located? Your log says you are using the EU regulatory
> domain; however, that is no longer valid. You should add a line like
> 
> options cfg80211 ieee80211_regdom=XX
> 
> to /etc/modprobe.conf.local. From your name, I would guess the XX
> should be DE.

I guess, too. For some reason it is not corrected in some tutorials.

> It is likely that the 20 dBm is set by mac80211 as the maximum allowed
> by your local regulations. That value is in fact correct for most
> locations in the EU.

As far as I know, Germany has a maximum of 100mW, which should be 20dBm, 
if I'm right. This means the driver reports full power though the device 
actually seems to send with much less power. The power gets lost 
somewhere between this display and the antenna. Since there exists a 
working driver, I can hardly expect it on the hardware side.

I've attached the output of iwconfig for the two drivers. The 
proprietary works, the compat-wireless one even failed to authenticate 
(auth timeout) today. I don't know which tx power the proprietary driver 
uses. If you can tell me how to find out, I'll try that.

Some additional information: The automatic rate setting seems to work 
somehow. Last night it grow to 11M for a short time (reporting signal 
stregth of -3dBm).

Maybe, the tx power gets only reduced, but never increased. That's what 
the AP sees.

> My rtl8187b runs at a full 54 Mbs and operates at at least 15 m from
> my AP. I don't run AP firmware that lets me see the signal strength
> from the STA.

That dosn't surprise me. The archives don't talk about similar problems.

Tobias

--------------080203090906070002030807
Content-Type: text/plain;
 name="iwconfig1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwconfig1"

wlan0     802.11b/g linked  ESSID:"Malter"  
          Mode:Managed  Channel=8  Access Point: 00:17:3F:7E:AB:08   
          Bit Rate=48 Mb/s   
          Retry:on   Fragment thr:off
          Link Quality=72/100  Signal level=-45 dBm  Noise level=-102 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

filename:       /lib/modules/2.6.24-19-generic/kernel/drivers/nb/r8187.ko
description:    Linux driver for Realtek RTL8187 WiFi cards
author:         Andrea Merello <andreamrl@tiscali.it>
version:        V 1.1
license:        GPL
srcversion:     CE57E03B376EA9ED408E23E
alias:          usb:v0846p6A00d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p6100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8189d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8187d*dc*dsc*dp*ic*isc*ip*
depends:        usbcore
vermagic:       2.6.24-19-generic SMP mod_unload 586 
parm:           ifname:charp
parm:           devname: Net interface name, wlan%d=default
parm:           channels: Channel bitmask for specific locales. NYI (int)

filename:       /lib/modules/2.6.24-19-generic/kernel/drivers/nb/r8187msh.ko
description:    Linux extension module for Realtek RTL8187 WiFi cards
author:         Stanley Chang <changsl@cs.nctu.edu.tw>
version:        V 11sD1.0
license:        Proprietary
srcversion:     4F5B438A81B73DDF03155C5
depends:        
vermagic:       2.6.24-19-generic SMP mod_unload 586 

--------------080203090906070002030807
Content-Type: text/plain;
 name="iwconfig2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwconfig2"

wlan0     IEEE 802.11bg  ESSID:"Malter"  
          Mode:Managed  Frequency:2.447 GHz  Access Point: 00:17:3F:7E:AB:08   
          Bit Rate=1 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off
          Link Quality=69/70  Signal level=-41 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

filename:       /lib/modules/2.6.28-15-generic/updates/drivers/net/wireless/rtl818x/rtl8187.ko
license:        GPL
description:    RTL8187/RTL8187B USB wireless driver
author:         Larry Finger <Larry.Finger@lwfinger.net>
author:         Hin-Tak Leung <htl10@users.sourceforge.net>
author:         Herton Ronaldo Krzesinski <herton@mandriva.com.br>
author:         Andrea Merello <andreamrl@tiscali.it>
author:         Michael Wu <flamingice@sourmilk.net>
srcversion:     ACC7FDA7EFE2500D0DC1B50
alias:          usb:v1737p0073d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1B75p8187d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v18E8p6232d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v13D1pABE6d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v1371p9401d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v114Bp0150d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p0028d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0DF6p000Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v03F0pCA02d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p4260d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p6A00d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0846p6100d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0789p010Cd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0769p11F2d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8198d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8197d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8189d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0BDAp8187d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v050Dp705Ed*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B05p171Dd*dc*dsc*dp*ic*isc*ip*
depends:        mac80211,eeprom_93cx6,cfg80211
vermagic:       2.6.28-15-generic SMP mod_unload modversions 586 

--------------080203090906070002030807--

