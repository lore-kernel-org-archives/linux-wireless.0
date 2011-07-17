Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:44001 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1GQGBF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 02:01:05 -0400
Received: from [195.4.92.10] (helo=0.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #5)
	id 1QiKPW-0004st-Jt
	for linux-wireless@vger.kernel.org; Sun, 17 Jul 2011 08:01:02 +0200
Received: from p54a19116.dip0.t-ipconnect.de ([84.161.145.22]:45933 helo=mail.maya.org)
	by 0.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.72 #5)
	id 1QiKPW-0002Op-9f
	for linux-wireless@vger.kernel.org; Sun, 17 Jul 2011 08:01:02 +0200
Message-ID: <4E227AE0.6080709@01019freenet.de> (sfid-20110717_080234_959981_EB510805)
Date: Sun, 17 Jul 2011 08:02:08 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Olivier_Cr=EAte?= <olivier.crete@ocrete.ca>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Sometimes rtl8187 stops sending/receiving packets under load
References: <1310851053.5700.14.camel@TesterBox.tester.ca> <4E221A18.2070504@lwfinger.net> <1310864785.3540.5.camel@TesterBox.tester.ca>
In-Reply-To: <1310864785.3540.5.camel@TesterBox.tester.ca>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Olivier Crête wrote:
> On Sat, 2011-07-16 at 18:09 -0500, Larry Finger wrote:
>> On 07/16/2011 04:17 PM, Olivier Crête wrote:
>>> I get this on my dmesg:
>>> ieee80211 phy0: wlan0: No probe response from AP 00:0f:66:e2:5f:dd after 500ms, disconnecting.
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 1)
>>> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 2)
>>> wlan0: authenticate with 00:0f:66:e2:5f:dd (try 3)
>>> wlan0: authentication with 00:0f:66:e2:5f:dd timed out
>>>
>>> The wireless card is the one built-in a Asus P5K-E/wifi-ap motherboard.
>>> And the router is a WRT54G v2 running the latest OpenWRT.
>>>
>>> This bit of dmesg output may also be useful:
>>> usb 1-3: reset high speed USB device using ehci_hcd and address 2
>>> cfg80211: Calling CRDA to update world regulatory domain
>>> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
>>> ieee80211 phy0: hwaddr 00:15:af:37:19:b3, RTL8187vB (default) V1 + rtl8225z2, rfkill mask 2
>>
>> I have the same device as you as shown in the following:
>>
>> ieee80211 phy1: hwaddr 00:1b:2f:a2:07:ca, RTL8187vB (default) V1 + rtl8225z2, 
>> rfkill mask 2
>>
>> I have run this card extensively in the past several months and have not seen 
>> any problems. One of my APs is a WRT54GL running a fairly recent openWRT.
>>
>> Does this only happen when running torrents, or does it happen with a different 
>> heavy load?
> 
> I can only reproduce it with torrents, downloading something with a
> single TCP connection doesn't crash. So my guess it has something to do
> with the upload side maybe or maybe with loading both directions at the
> same time.
> 
>> Please try to repeat with a 2.6.39 or 3.0 kernel.
> 
> Alright, upgraded to 3.0-rc7 and I could still reproduce it in less than
> 10 minutes. 

Do you have a SMP-machine (there are running more then one threads
parallel)? If yes, there have been problems fixed in the rt2x00 driver,
which showed similar problems as you described. I "forced" them with
netperf to get them easily reproduced. Don't know, if these patches
would address your problem, too.

https://patchwork.kernel.org/patch/951132/
https://patchwork.kernel.org/patch/951222/
https://patchwork.kernel.org/patch/951192/


Unfortunately, there are more load-related problems in the WLAN stack,
especially with hostapd / wpa_supplicant, which are just ignored by the
programmer.



Andreas
