Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:38597 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaAINjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jan 2014 08:39:07 -0500
Message-ID: <52CEA5A3.2040308@neratec.com> (sfid-20140109_143911_770978_21949EFE)
Date: Thu, 09 Jan 2014 14:35:31 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k: Fix TX IQ calibration for SoC chips
References: <1384665016-12022-1-git-send-email-sujith@msujith.org>	<1384665016-12022-5-git-send-email-sujith@msujith.org>	<52CE934D.1020400@neratec.com> <21198.40916.260973.48444@gargle.gargle.HOWL>
In-Reply-To: <21198.40916.260973.48444@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2014 02:10 PM, Sujith Manoharan wrote:
> Wojciech Dubowik wrote:
>> This code will always set run_agc to true. Does it mean you always have
>> to run agc cal no matter what since default is anyway true or it's just a typo?
> That was the aim of the patch.
>
> When it has been decided to do TX IQ calibration, AGC cal has to be
> run. IQ cal can be done separately in the driver (pre-AR9485) or it
> can be taken care of by the HW when AGC cal is triggered.
Ok
>> The reason I am asking is that I have ran into problem with rssi reporting
>> when calibration is ongoing.  It looks like beacon received just after IQ
>> mismatch calibration is reported ~10-15 dB higher than it should. I have
>> verified power with wireshark and they are ok at antenna port.  Next beacons
>> are reported fine. I have tried to enable disable different antennas but it
>> doesn't seem to affect the results.
>>
>> It doesn't happen all the time but since iq calibration is on every time we
>> are scanning it puts wrong rssi value in scan result entry. I don't have a
>> proof yet but it might affect probe responses as well.
> Which chip ? Is this issue seen with an older snapshot of the driver ?
> (There is an IQ cal fix for AR955x which I haven't ported to ath9k yet).
AR9590 running on powerpc with latest openwrt i.e. 
compat-wireless-2013-11-05 backported with
your changes for split pci/soc IQ calibration.

I could try to reproduce it on my host with latest wireless testing if 
you think
it helps.

Wojtek
>
> Sujith

