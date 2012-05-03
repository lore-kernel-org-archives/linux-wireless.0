Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:28695 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2ECFP1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:15:27 -0400
Message-ID: <4FA21468.6060909@qca.qualcomm.com> (sfid-20120503_071532_485430_00043735)
Date: Thu, 3 May 2012 08:15:20 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jonathan Bagg <jbagg@lenbrook.com>
CC: Anthony Ginger <mapfly@gmail.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: ath6kl hostapd
References: <CAK0tYSKLhALwUca2LPiRLfXTK-Qt3Oh3Lvk=V272AXdb=aAP7w@mail.gmail.com> <4F4B25F5.4090204@qca.qualcomm.com> <4F8546C7.40703@qca.qualcomm.com> <4FA036B6.7040002@lenbrook.com> <4FA03939.4080307@qca.qualcomm.com> <4FA0535D.2060907@lenbrook.com>
In-Reply-To: <4FA0535D.2060907@lenbrook.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/02/2012 12:19 AM, Jonathan Bagg wrote:
> On 12-05-01 03:27 PM, Kalle Valo wrote:
>> On 05/01/2012 10:17 PM, Jonathan Bagg wrote:
>>>
>>> When you tried hostapd on the N900, did you use a kernel built from your 
>>> https://github.com/kvalo/ath6kl.git or from compat-wireless?
>> Just to clarify: I was running hostapd on my x86 box which has ar6003
>> and I used N900 as the client connecting to the x86 box.
>>
>> I used ath6kl.git for my tests. I use compat-wireless very little (if
>> any) in my tests.
>
> I can not get hostapd with ath6kl working with the following.....
> libnl 3.2.8
> hostapd v2.0-devel (cloned today)
> compat-wireless backport based on linux-next.git next-20120424
> kernel = 2.6.35.3 + freescale's patches
> platform = arm, imx51 babbage dev board
> 
> rfkill: Cannot open RFKILL control device
> nl80211: Failed to set interface wlan0 into AP mode
> nl80211 driver initialization failed.

That's strange. Does dmesg so anything? Are you sure that you are using
the correct version of ath6kl_sdio.ko and not some older version?

Also please enable full debug messages on hostapd and send a full log.

> I'll try and get your kernel from ath6kl.git to boot on my imx51 babbage
> dev board.

That might be challenging. I think it's easier if you add debug messages
and try to pinpoint where it is failing. For example
ath6kl_cfg80211_change_iface() is a good place to start debugging.

Kalle
