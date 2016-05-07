Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2on0084.outbound.protection.outlook.com ([65.55.169.84]:18926
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751088AbcEGTif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2016 15:38:35 -0400
From: Barry Reinhold <BarryReinhold@lnihealth.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Tom Harada <TomHarada@lnihealth.com>
Subject: Limit rate of BCM34348 on Raspberry PI-3 via brcmfmac
Date: Sat, 7 May 2016 19:24:19 +0000
Message-ID: <CY1PR19MB0614FCBF91B407C6CB0B08CFA77E0@CY1PR19MB0614.namprd19.prod.outlook.com> (sfid-20160507_213839_804178_5E8448AE)
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have observed erratic behavior with http connectivity over the WiFi interface of the Raspberry PI 3. This appears to be consistent with issues that a number of other people have reported. I fear, but can not provide definitive evidence, that these failures could be an RF design/layout issue with the RP-3 itself.

The purpose of this post is to see if this possible issue can be confirmed by others, and to seek a possible work around by re configuring the BCM43438 chip via the brcmfmac driver; or the other associated wifi modules.
 
How the issue is being seen:

Note: The testing I have done is limited and has the potential to be misleading, so any input on improving the test process would be appreciated.

There are two metrics we are using to define/see failure: (1) Loss/delay in ICMP Echo requests/replys (pings),  and (2) The output of messages in journalctl from the wpa_supplicant or hostapd (sudo journalctl -u wpa_supplicant -u hostapd -f) indicating a disconnect event with associated reason - typically 0 - (wlan0: CTRL-EVENT-DISCONNECTED bssid=60:02:92:cd:c9:30 reason=0).
Ping times vary from 1 to several hundred ms, to outright loss.
There are also failures to reassociate (wlan0: CTRL-EVENT-ASSOC-REJECT status_code=16).

The test Environment is composed of:
An official  Raspberry PI-3 model B with an official Raspberry PI-3 power supply.
Raspbian release: Jesse (March 18)
Kernel 4.4.6
wpa_supplicant 2.3
brcmfmac 7.45.41.23 (as reported by ethool)
BCM43438 firmware: 01-cc44eda9c
BlueZ 5.23

We are running both wpa_supplicant and hostapd, (disabling hostapd does not impact the results of the tests).
We have an application that is monitoring for BTLE/Bluetooth connections so it is scanning on a regular basis, as well as sending out Bluetooth INQUIRE messages.

WiFi Access Points:
1. Cisco DPC3939B (supports n)
2. Cisco Linksys E1200 (supports n)
3. Netgear WNDR3400 (supports n)
4. Linksys WAP54G v3 (does not support n)

 

Test Process

 
While the application is running (thus generating Bluetooth activity)
1. Connect a PC to the RPi3's software access point and ping the RPi3 continuously.
2. Connect the RPi3 to an AP from the set above.
3. Let the system run for 10 minutes while counting wpa_supplicant disconnects and lost pings.

Observations:
In our testing we noticed that either we essentially got no errors, or we got 12+ errors. Some error rates high enough that we couldn't count them as they just scrolled off our screen. Hence we considered thing to work (less then 2 errors) or failed (greater than 10 errors).

The results table for the different APs is as follows:
DPC3939B - Failed
E1200 - Failed
WNDR3400 - Failed
WAP54G - Passed

Since only the WAP54G passed (no n support), we modified the data rate on the Netgear WND3400 and limited its data rate to 54 mbs, at this point the WNDR3400 passed.

We then tried changing channels. this did not impact the metrics we were monitoring.

Now being suspicious of RF issues on the board, we modified our application which performs the Bluetooth communications so that Bluetooth was disabled. This did not eliminate errors but dramatically reduced them. We then modified our application to generate a lot of Bluetooth inquiry messages and discovered that the generation and resulting response from INQUIRY messages correlated with journalctl disconnection messages. 

We repeated this on the AP WAP54G and the rate limited WNDR3400 and did not see problems.

Our initial conjecture is that there is some coexistence/RF issue with the RPI-3 board when using Bluetooth and WiFi that is impacting when operating with a IEEE 802.11 N AP.

Notes and steps taken:
Background reading led us to try the following fixes that have worked for others:
1. Disable power management
2. Set the Country Code to US
These fixes did not help.
 
I have two questions:
1. Are there some obvious things I can do to identify/validate the initial conjecture as to the cause of the error?
2. Is there a way to force the RPI-3 when operating as a client of another AP to rate limit or function as a "G" device?  If the RPI-3 or the BCM43438 do indeed have RF issues it would seem like some work around will be needed. I could not identify a way to limit the data rate in brcmfmac.

 

Barry Reinhold
