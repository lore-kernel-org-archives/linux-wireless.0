Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:56195 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab3GIL1a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jul 2013 07:27:30 -0400
Message-ID: <51DBF389.5060209@inov.pt> (sfid-20130709_132734_115645_90E496F9)
Date: Tue, 09 Jul 2013 12:27:05 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>   <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>   <51DB4195.8090103@inov.pt>   <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>  <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt> <1373362817.21065.191.camel@cumari.coelho.fi>
In-Reply-To: <1373362817.21065.191.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've upgraded the firmware and also backported all patches in Luca's 
tree which do not break API compatibility in kernel 3.9 and still have 
no success. Here goes the log:

[root ~]$ wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf
Successfully initialized wpa_supplicant
[   38.295000] wlcore: firmware booted (Rev 6.3.10.0.136)
[   38.655000] cfg80211: Calling CRDA for country: PT
[   38.655000] cfg80211: Regulatory domain changed to country: PT
[   38.665000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   38.665000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   38.675000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   38.675000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   38.685000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), 
(N/A, 2700 mBm)
[   38.685000] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), 
(N/A, 4000 mBm)
wlan0: SME: Trying to authenticate with 88:43:e1:57:79:c0 (SSID='[ 
38.945000] wlan0: authenticate with 88:43:e1:57:79:c0
A. Guidance' freq=2452 MHz)
[   38.985000] wlan0: send auth to 88:43:e1:57:79:c0 (try 1/3)
[   38.990000] wlan0: authenticated
wlan0: Trying to associate with 88:43:e1:57:79:c0 (SSID='A. Guidance' 
freq=2452 MHz)
[   39.065000] wlan0: associate with 88:43:e1:57:79:c0 (try 1/3)
[   39.070000] wlan0: RX AssocResp from 88:43:e1:57:79:c0 (capab=0x431 
status=0 aid=1)
[   39.095000] wlan0: associated
[   39.095000] cfg80211: Calling CRDA for country: PT
[   39.105000] cfg80211: Regulatory domain changed to country: PT
[   39.105000] cfg80211:   (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[   39.110000] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   39.125000] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   39.125000] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), 
(N/A, 2000 mBm)
[   39.140000] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), 
(N/A, 2700 mBm)
[   39.140000] cfg80211:   (57240000 KHz - 65880000 KHz @ 2160000 KHz), 
(N/A, 4000 mBm)
wlan0: Associated with 88:43:e1:57:79:c0
[   40.925000] wlcore: Beacon loss detected. roles:0xff
[   42.610000] wlcore: Beacon loss detected. roles:0xff
[   44.275000] wlcore: Beacon loss detected. roles:0xff
[   45.740000] wlcore: Connection loss work (role_id: 0).
[   45.740000] wlan0: Connection to AP 88:43:e1:57:79:c0 lost

And I still have the issue of not being able to scan all APs in the 
vicinity. I can only (briefly) associate with my AP because I restrict 
the scanning frequencies in wpa_supplicant.conf file;

country=PT
ap_scan=1
ctrl_interface=/var/run/wpa_supplicant
network={
     ssid="A. Guidance"
     scan_freq=2452
     key_mgmt=WPA-PSK
     proto=WPA2
     pairwise=CCMP TKIP
     group=TKIP
     psk="<some_password_in_ascii>"
}

Any more ideas on how to debug this? Is there any specific debug_level 
mask that can apply to the driver to help it?

José Gonçalves
