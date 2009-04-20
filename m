Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45316 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZDTROB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 13:14:01 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1239875168.9737.10.camel@johannes.local>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239875168.9737.10.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 20 Apr 2009 18:13:56 +0100
Message-Id: <1240247636.5260.11.camel@localhost.localdomain> (sfid-20090420_191411_172352_6A2463CE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > After a long debugging session with Reinette we finally tracked down
> > what is going on here. A full scan with this card takes 7-9 seconds and
> > that seems to be too long and trigger IEEE80211_MONITORING_INTERVAL
> > which then deauthenticates us with the AP (reason=6).
> 
> Note to everybody: _Please_ provide the exact output. This text above
> makes it sound like we deauth from the AP, when in reality the AP has
> deauth'ed us.
> 
> Maybe your AP is just buggy and can't handle you going away for more
> than a couple of seconds? It _looks_ like it sends you a deauth frame
> while you're scanning (please verify using wireshark or similar), we
> miss that deauth because we're off the channel, and then when we get
> back and start sending data again the AP complains that we're no longer
> authenticated.
> 
> Sorry, but there's not enough information here to tell what really is
> going wrong. The known bug shouldn't be able to cause this behaviour.

so I had time to log the details now. I still have the problem that the
association only works once. If it ever breaks it never works again. I
hope this is not something stupid in the iwlagn driver for the 5350
hardware.

This is from wpa_supplicant (latest version from GIT of course):

CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-SCAN-RESULTS 
WPS-AP-AVAILABLE 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
WPA: Key negotiation completed with 00:1f:3f:19:d8:b7 [PTK=CCMP GTK=CCMP]
CTRL-EVENT-CONNECTED - Connection to 00:1f:3f:19:d8:b7 completed (auth) [id=0 id_str=]
CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-SCAN-RESULTS 
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
CTRL-EVENT-DISCONNECTED - Disconnect event - remove keys
CTRL-EVENT-SCAN-RESULTS 
Trying to authenticate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Trying to associate with 00:1f:3f:19:d8:b7 (SSID='Holtmann' freq=2462 MHz)
Associated with 00:1f:3f:19:d8:b7
^CCTRL-EVENT-TERMINATING - signal 2 received

As you see it keeps scanning, authenticating, associating and then it
never completes.

And this is the debug output from the kernel side (latest
wireless-testing with all debug options enabled):

wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX AssocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
cfg80211: Calling CRDA for country: DE
wlan0: beacon loss from AP 00:1f:3f:19:d8:b7 - sending probe request
wlan0: beacon loss from AP 00:1f:3f:19:d8:b7 - sending probe request
wlan0: no probe response from AP 00:1f:3f:19:d8:b7 - disassociating
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: direct probe to AP 00:1f:3f:19:d8:b7 try 1
wlan0 direct probe responded
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: direct probe to AP 00:1f:3f:19:d8:b7 try 1
wlan0: direct probe to AP 00:1f:3f:19:d8:b7 try 2
wlan0: direct probe to AP 00:1f:3f:19:d8:b7 try 3
wlan0 direct probe responded
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticated (Reason: 2)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticate with AP 00:1f:3f:19:d8:b7
wlan0: authenticated
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: associate with AP 00:1f:3f:19:d8:b7
wlan0: RX ReassocResp from 00:1f:3f:19:d8:b7 (capab=0x431 status=0 aid=2)
wlan0: associated
phy0: Allocated STA 00:1f:3f:19:d8:b7
phy0: Inserted STA 00:1f:3f:19:d8:b7
wmaster0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0
wmaster0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94
wmaster0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
wlan0: switched to short barker preamble (BSSID=00:1f:3f:19:d8:b7)
wlan0: switched to short slot time (BSSID=00:1f:3f:19:d8:b7)
wlan0: deauthenticating by local choice (reason=3)
phy0: Removed STA 00:1f:3f:19:d8:b7
phy0: Destroyed STA 00:1f:3f:19:d8:b7

Do you need anything else? I have really no idea what happens here and I
like to get it fixed.

Regards

Marcel


