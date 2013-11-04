Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3684 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401Ab3KDPF1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 10:05:27 -0500
Message-ID: <5277B7AD.6000309@broadcom.com> (sfid-20131104_160530_714668_4533C884)
Date: Mon, 4 Nov 2013 16:05:17 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>
cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: Re: How to get BRCM to work?
References: <20131104115111.GM26669@mwanda>
 <52778D30.6030605@hauke-m.de> <20131104130728.GA20521@mwanda>
In-Reply-To: <20131104130728.GA20521@mwanda>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/04/2013 02:07 PM, Dan Carpenter wrote:
> On Mon, Nov 04, 2013 at 01:04:00PM +0100, Hauke Mehrtens wrote:
>> On 11/04/2013 12:51 PM, Dan Carpenter wrote:
>>> I've been trying to remember the trick to get BRCM to work and I can't
>>> remember at all.  I'm using BCM4313.  I've enabled everything with BCMA
>>> or BRCM in the config name.
>>>
>>> The module loads and the device shows up if I type "ifconfig wlan0" but
>>> network manager doesn't see it and wicd doesn't see it.  (These are old
>>> versions of nm and wicd).
>>>
>>> This used to work under 3.8 but I didn't save my .config...  :(
>>
>> Are these old versions of nm and wicd only supporting the deprecated
>> WEXT interface? If this is the case you have to set
>> CONFIG_CFG80211_WEXT=y in your config.
>>
>
> I have that enabled.
>
>> You also need a firmware for this device /lib/firmware/brcm/bcm43xx-0.fw
>> and /lib/firmware/brcm/bcm43xx_hdr-0.fw are needed.
>
> I have the firmware.
>
>>
>> When the device gets detected by brcmsmac, it is probably not a problem
>> in the Broadcom driver.
>>
>>> I've done a google search and it seems like the broadcom driver is still
>>> a complete mess and you need to black list modules and hack everything
>>> yourself on a per system basis?  Is that right?  Why can't we fix this
>>> so it works?

There used to be a Kconfig item which would b43 claim the same device as 
brcmsmac. That was changed to a b43 module parameter. So the only issue 
could be if you previously had the proprietary broadcom-wl driver in 
use, because that adds blacklist entries for both b43 and brcmsmac and 
it does not get cleaned up when uninstalling.

If you never used the proprietary driver, there should be no issue with 
it and I would not recommend going there (I am biased). As you obviously 
do have a problem at hand, lets dive in. Can you send me a system and/or 
kernel log.

Gr. AvS

