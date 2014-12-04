Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:37744 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507AbaLDTEG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 14:04:06 -0500
Message-ID: <5480B024.5050302@broadcom.com> (sfid-20141204_200419_493035_06F83F64)
Date: Thu, 4 Dec 2014 20:04:04 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Multiple-BSSID issues with hostapd
References: <54784001.7020706@broadcom.com> <CACna6rzGB7EvMbiteWGbwjdmx+LMZymdk_04L_RKiFkT0hokvA@mail.gmail.com>
In-Reply-To: <CACna6rzGB7EvMbiteWGbwjdmx+LMZymdk_04L_RKiFkT0hokvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/14 13:03, Rafał Miłecki wrote:
> On 28 November 2014 at 10:27, Arend van Spriel<arend@broadcom.com>  wrote:
>> For the brcmfmac we started working on Multiple-BSSID support and came
>> across some issues with hostapd that are listed listed below.
>>
>> BSS1 setup on netdev wlan0
>> BSS2 setup on netdev wlan0_0
>>
>> * get_station() done on wrong netdev
>>
>> observed:
>> Upon association of STA1 with BSS2 (wlan0_0) a get_station() is done for
>> STA1 with wlan0 as netdev.
>> expected:
>> get_station() for STA1 with wlan0_0 as netdev. We verified that wlan0_0
>> ifindex was used in NL80211_CMD_NEW_STATION event.
>
> Did you do any progress on this?

Nope.

> According to the nl80211.h you are correct of course, every
> NL80211_CMD_foo_STATION command should include NL80211_ATTR_IFINDEX.
>
> There are two functions in driver_nl80211.c where
> NL80211_CMD_GET_STATION is used.
>
> 1) nl80211_get_link_signal
> It fills NL80211_ATTR_IFINDEX in the following way:
> NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);
>
> 2) i802_read_sta_data
> It fills NL80211_ATTR_IFINDEX in the following way:
> NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(bss->ifname));
>
> Did you track down which of the above functions in the one sending
> wrong NL80211_ATTR_IFINDEX?

Nope. We simply return empty sta_info. We used the hostapd that comes 
with Ubuntu 12.04 (i think) to assure it is usable. I suppose the code 
you mention here is driver_nl80211.c from the git repo. I intended to 
retry the scenario with hostapd build from git.

Regards,
Arend
