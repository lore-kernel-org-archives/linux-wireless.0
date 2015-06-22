Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50442 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbbFVIUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 04:20:05 -0400
Message-ID: <5587C532.3050901@broadcom.com> (sfid-20150622_102009_956789_B9304850)
Date: Mon, 22 Jun 2015 10:20:02 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211 development <brcm80211-dev-list@broadcom.com>
Subject: Re: brcmfmac: one faulty "iw interface add" command breaks in-firmware
 BSS state
References: <CACna6rzr35hM-VLxgvxtGPnnxSMPx6TM18Qfc8E1Obm7iVPG4A@mail.gmail.com>	 <5587BDA9.5000107@broadcom.com> (sfid-20150622_094800_795721_2E996996) <1434960206.19597.6.camel@sipsolutions.net>
In-Reply-To: <1434960206.19597.6.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/15 10:03, Johannes Berg wrote:
> On Mon, 2015-06-22 at 09:47 +0200, Arend van Spriel wrote:
>
>>> # iw phy phy0 interface add wlan0 type __ap
>>
>> Now this is a pretty silly scenario as there already is a wlan0
>> interface. Admittedly, this should be rejected as such. This clearly is
>> a user mistake (not sure why you quoted that :-p ) and it might be good
>> to catch this in cfg80211 as it probably applies to other drivers as
>> well. This probably explains why register_netdev fails.
>
> I don't think that's easy to catch - but the driver really should just
> see that register_netdev fails and do nothing (except for reporting the
> error back), no?

Indeed there is an issue with error handling here, but as this was a 
user fault I was looking for early detection. If as you say that will 
not be easy from cfg80211 we will need to rework brcmfmac code. 
Currently, we create interface in firmware and upon receiving 'ifc 
created' event we do the register_netdev. I think we do that to avoid 
getting start_xmit calls as we do not use netif carrier calls.

Regards,
Arend
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
