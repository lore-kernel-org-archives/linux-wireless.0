Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:34598 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbaAOIeO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 03:34:14 -0500
Message-ID: <52D6472B.2060207@neratec.com> (sfid-20140115_093418_017252_377AD064)
Date: Wed, 15 Jan 2014 09:30:35 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com>	<21198.40916.260973.48444@gargle.gargle.HOWL>	<52CEA5A3.2040308@neratec.com>	<21198.43395.235654.597422@gargle.gargle.HOWL>	<52CEAB24.5090700@neratec.com>	<52D3F962.1010302@neratec.com>	<21204.319.492595.58625@gargle.gargle.HOWL>	<52D402C3.3070606@neratec.com>	<21204.1991.201080.986559@gargle.gargle.HOWL>	<21204.2384.710460.402183@gargle.gargle.HOWL>	<21204.3832.404821.109119@gargle.gargle.HOWL>	<52D63EBB.7020607@neratec.com> <21206.17284.157496.206327@gargle.gargle.HOWL>
In-Reply-To: <21206.17284.157496.206327@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2014 09:15 AM, Sujith Manoharan wrote:
> Wojciech Dubowik wrote:
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.026210] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/53/-34
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.028515] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/55/-32
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.028768] ath: phy0: Set HW Key
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.028827] ath: phy0: Set HW Key
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032695] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/53/-34
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032710] ath: phy0: bmiss: 10 sleep: 15360
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032716] ath: phy0: next DTIM 106306560
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032717] ath: phy0: next beacon 106306560
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032718] ath: phy0: beacon period 15360
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032719] ath: phy0: DTIM period 15360
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032749] cfg80211: Found new beacon on frequency: 5180 MHz (Ch 36) on phy0
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.032758] cfg80211: Pending regulatory request, waiting for it to be processed...
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.048561] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/39/-48
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.063921] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/37/-50
>> Jan 15 08:43:44 wlanTS kernel: [ 1177.079283] NOISE/RSSI/SIGNAL for 04:f0:21:04:56:9e: -87/33/-54
> I can reproduce this issue too and this happens only once - right after
> association. After association, running a background scan doesn't show any
> problems.
>
> Sujith
I have seen the wrong rssi in scan results but I just don't have yet 
have a proof on clean
wireless testing. It seems that when I put a lot of printk I don't see 
the problem because
maybe scanning/calibration/etc. is shifted more away. Anyway it's just a 
guess so I will dig
further.

Wojtek
