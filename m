Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:42050 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYKQUhs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 15:37:48 -0500
Received: by ug-out-1314.google.com with SMTP id 39so17171ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Nov 2008 12:37:46 -0800 (PST)
Message-ID: <4921D616.3040207@gmail.com> (sfid-20081117_213753_554142_EDDE2B31)
Date: Mon, 17 Nov 2008 20:37:42 +0000
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: Dave <kilroyd@googlemail.com>, orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to
 associate with 9.48 FW
References: <200810191436.13298.arvidjaar@mail.ru> <20081115145655.GB31553@tuxdriver.com> <491FEF89.3040100@gmail.com> <200811172229.41361.arvidjaar@mail.ru>
In-Reply-To: <200811172229.41361.arvidjaar@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andrey Borzenkov wrote:
> On Sunday 16 November 2008, Dave wrote:
>> There are two other things I can think of:
>>
>> 1. make sure wpa_supplicant is shut down before ifconfig ethX down, and
>> restart it on resume.
> 
> That is exactly what happens currently.
> 
>> From the data you've provided it looks like your distribution brings the
>> device down, but may leave wpa_supplicant running. 
> 
> No, wpa_supplicant is started as part of ifup and stopped as part of ifdown.
> Which are called on network start/stop.

OK. If wpa_supplicant is restarted after resume, the patch I posted
won't do anything interesting.

>> I've noticed that 
>> every time wpa_supplicant shuts down it removes most configuration
>> settings. Or has that changed?
> 
> As far as I can tell - it should. I am not sure how to check for it; I do
> not see any difference in output of either iwconfig or iwlist scan either
> before or after "network stop".

The wpa_supplicant logfile notes when it is clearing keys and other
settings.

> Returning to the original problem. The only difference visible currently is
> when association happens.
> 
> Bad case is always:
> 
> [ 7669.871273] eth1: New link status: Connected (0001)
> [ 7670.046171] eth1: Lucent/Agere firmware doesn't support manual roaming
> [ 7670.495779] eth1: Lucent/Agere firmware doesn't support manual roaming
> [ 7675.774280] eth1: Lucent/Agere firmware doesn't support manual roaming
> ...
> 
> i.e. it /looks/ like first card is connected to AP and then wpa_supplicant
> request association. BTW, I just realized that I am not sure what "connected"
> means exactly. Does it mean card is associated?

When setup for WPA, I do not believe 'Connected' means 'associated'. The
card connects to the BSSID first. Then wpa_supplicant can do the WPA
association thing with that BSSID. If you are using WEP or no
authentication, 'Connected' is as good as 'associated'.

The repeated 'doesn't support manual roaming' just tells me that
wpa_supplicant is failing to associate, and just keeps retrying.

> That is what let me believe that old parameters somehow are retained.

CONNECTED will pop up shortly after the key management mode (PSK) is
set, wpa is enabled, and SSID is set. This is the same point as when
wireless event 0x8b1a should appear in your log.

> Looking at wpa_supplicant log intersting part is
> 
> Wireless event: cmd=0x8c07 len=32
> AssocReq IE wireless event - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
> RTM_NEWLINK, IFLA_IFNAME: Interface 'eth1' added
> Wireless event: cmd=0x8b15 len=20
> Wireless event: new AP: 00:60:b3:ca:91:b0
> Association info event
> req_ies - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02
> State: ASSOCIATING -> ASSOCIATED
> wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
> WEXT: Operstate: linkmode=-1, operstate=5
> Associated to a new BSS: BSSID=44:44:44:44:44:44

> in other words, wpa_drv_get_bssid() returns 44:... BSSID. I could not find
> any place in kernel or wpa_supplicant that would set it, so I can only assume
> that firmware returns it for watever reason.

It is a firmware value, but I don't know what the it means. I know
hostap checks for it in hostap_main:prism2_sta_deauth.


Regards,

Dave.
