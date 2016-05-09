Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36279 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbcEIV2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 17:28:08 -0400
Received: by mail-wm0-f53.google.com with SMTP id n129so154513507wmn.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 14:28:07 -0700 (PDT)
Subject: Re: Limit rate of BCM34348 on Raspberry PI-3 via brcmfmac
To: Barry Reinhold <BarryReinhold@lnihealth.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <CY1PR19MB0614FCBF91B407C6CB0B08CFA77E0@CY1PR19MB0614.namprd19.prod.outlook.com>
 <57308150.5060308@broadcom.com>
 <CY1PR19MB0614DA6ED0946583EF186645A7700@CY1PR19MB0614.namprd19.prod.outlook.com>
 <5730FE8D.2050704@broadcom.com>
Cc: Tom Harada <TomHarada@lnihealth.com>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <573100E0.8070003@broadcom.com> (sfid-20160509_232817_547337_21A9B28B)
Date: Mon, 9 May 2016 23:28:00 +0200
MIME-Version: 1.0
In-Reply-To: <5730FE8D.2050704@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 9-5-2016 23:18, Arend Van Spriel wrote:
> On 9-5-2016 18:59, Barry Reinhold wrote:
>> Arend (and Hante),
>>
>> I appreciate the feedback on the core problem - that brings the issue into a lot sharper focus. Based on your response I assume we should be able to see successful coexistence with Bluetooth and 802.11 STA mode, as well as STA and AP (with Bluetooth turned off). However, BT with AP mode should fail, and BT with AP and STA will fail.
>>
>> I will rerun some of our crude tests to see if I can corroborate your understanding by testing the different "should coexist" and "should not coexist" cases. 
>>
>> You have a very interesting lead in  statement in your response (bottom of message) but the sentence just ends with "because of...". Would you be willing to complete that thought, I would like to further understand the nature of the problem.
> 
> These kind of references are why inline replies are preferrable. Anyway
> let me try and finish that sentence. An AP has to be able to sent a
> beacon on fixed times and subsequent traffic. As BT is master in most if

something dropped off again. It should say: ... and _handle_ subsequent
traffic.

> not all bt-coex schemes that can easily screw up the beacon timing,
> which by the way is a reason for clients to disconnect.
> 
>> Is there a known reason why the brcmfmac does not support the set_bitrate_mask() callback (such as the associated family of chips do not support rate limiting) or is this something that nobody has cared about to do date, ie, is it something that could be done if there was interest and resources?
> 
> No specific reason.
> 
> Regards,
> Arend
> 
>> ________________________________________
>> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
>> Sent: Monday, May 9, 2016 8:23
>> To: Barry Reinhold; linux-wireless@vger.kernel.org
>> Cc: Tom Harada; brcm80211-dev-list
>> Subject: Re: Limit rate of BCM34348 on Raspberry PI-3 via brcmfmac
>>
>> On 7-5-2016 21:24, Barry Reinhold wrote:
>>> I have observed erratic behavior with http connectivity over the WiFi interface of the Raspberry PI 3. This appears to be consistent with issues that a number of other people have reported. I fear, but can not provide definitive evidence, that these failures could be an RF design/layout issue with the RP-3 itself.
>>>
>>> The purpose of this post is to see if this possible issue can be confirmed by others, and to seek a possible work around by re configuring the BCM43438 chip via the brcmfmac driver; or the other associated wifi modules.
>>>
>>> How the issue is being seen:
>>>
>>> Note: The testing I have done is limited and has the potential to be misleading, so any input on improving the test process would be appreciated.
>>>
>>> There are two metrics we are using to define/see failure: (1) Loss/delay in ICMP Echo requests/replys (pings),  and (2) The output of messages in journalctl from the wpa_supplicant or hostapd (sudo journalctl -u wpa_supplicant -u hostapd -f) indicating a disconnect event with associated reason - typically 0 - (wlan0: CTRL-EVENT-DISCONNECTED bssid=60:02:92:cd:c9:30 reason=0).
>>> Ping times vary from 1 to several hundred ms, to outright loss.
>>> There are also failures to reassociate (wlan0: CTRL-EVENT-ASSOC-REJECT status_code=16).
>>>
>>> The test Environment is composed of:
>>> An official  Raspberry PI-3 model B with an official Raspberry PI-3 power supply.
>>> Raspbian release: Jesse (March 18)
>>> Kernel 4.4.6
>>> wpa_supplicant 2.3
>>> brcmfmac 7.45.41.23 (as reported by ethool)
>>> BCM43438 firmware: 01-cc44eda9c
>>> BlueZ 5.23
>>>
>>> We are running both wpa_supplicant and hostapd, (disabling hostapd does not impact the results of the tests).
>>> We have an application that is monitoring for BTLE/Bluetooth connections so it is scanning on a regular basis, as well as sending out Bluetooth INQUIRE messages.
>>>
>>> WiFi Access Points:
>>> 1. Cisco DPC3939B (supports n)
>>> 2. Cisco Linksys E1200 (supports n)
>>> 3. Netgear WNDR3400 (supports n)
>>> 4. Linksys WAP54G v3 (does not support n)
>>>
>>>
>>>
>>> Test Process
>>>
>>>
>>> While the application is running (thus generating Bluetooth activity)
>>> 1. Connect a PC to the RPi3's software access point and ping the RPi3 continuously.
>>> 2. Connect the RPi3 to an AP from the set above.
>>> 3. Let the system run for 10 minutes while counting wpa_supplicant disconnects and lost pings.
>>>
>>> Observations:
>>> In our testing we noticed that either we essentially got no errors, or we got 12+ errors. Some error rates high enough that we couldn't count them as they just scrolled off our screen. Hence we considered thing to work (less then 2 errors) or failed (greater than 10 errors).
>>>
>>> The results table for the different APs is as follows:
>>> DPC3939B - Failed
>>> E1200 - Failed
>>> WNDR3400 - Failed
>>> WAP54G - Passed
>>>
>>> Since only the WAP54G passed (no n support), we modified the data rate on the Netgear WND3400 and limited its data rate to 54 mbs, at this point the WNDR3400 passed.
>>>
>>> We then tried changing channels. this did not impact the metrics we were monitoring.
>>>
>>> Now being suspicious of RF issues on the board, we modified our application which performs the Bluetooth communications so that Bluetooth was disabled. This did not eliminate errors but dramatically reduced them. We then modified our application to generate a lot of Bluetooth inquiry messages and discovered that the generation and resulting response from INQUIRY messages correlated with journalctl disconnection messages.
>>>
>>> We repeated this on the AP WAP54G and the rate limited WNDR3400 and did not see problems.
>>>
>>> Our initial conjecture is that there is some coexistence/RF issue with the RPI-3 board when using Bluetooth and WiFi that is impacting when operating with a IEEE 802.11 N AP.
>>>
>>> Notes and steps taken:
>>> Background reading led us to try the following fixes that have worked for others:
>>> 1. Disable power management
>>> 2. Set the Country Code to US
>>> These fixes did not help.
>>>
>>> I have two questions:
>>> 1. Are there some obvious things I can do to identify/validate the initial conjecture as to the cause of the error?
>>> 2. Is there a way to force the RPI-3 when operating as a client of another AP to rate limit or function as a "G" device?  If the RPI-3 or the BCM43438 do indeed have RF issues it would seem like some work around will be needed. I could not identify a way to limit the data rate in brcmfmac.
>>
>> Hi Barry,
>>
>> What you are trying to do is simply not possible. Indeed the RF is such
>> that Wifi and BT share the same antenna, which is the root-cause of the
>> problems you see. When the antenna is used by BT the Wifi is
>> unavailable. This is handled by bt-coex, but that is designed
>> specifically for station mode. This is simply not possible when the Wifi
>> is operating in AP mode, because of
>>
>> The reason why things get better/working when using g-rates is probably
>> because INQUIRE scan takes 14 x 1.25ms = 17.5 ms (thanks for the
>> calculation, Hante) and wifi frame retries at g-rate get past that.
>> cfg80211_ops have .set_bitrate_mask() callback, but brcmfmac does not
>> implement that.
>>
>> Regards,
>> Arend
>>
