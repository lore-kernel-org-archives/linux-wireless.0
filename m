Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4466 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753735Ab2GJIfJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 04:35:09 -0400
Message-ID: <4FFBE92B.7070304@broadcom.com> (sfid-20120710_103517_435445_73C08398)
Date: Tue, 10 Jul 2012 10:34:51 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	linville@tuxdriver.com
Subject: Re: [PATCH v2] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1340974563-77085-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <4FFAE252.4070504@broadcom.com>
 <4FFB5709.6070403@net.t-labs.tu-berlin.de>
In-Reply-To: <4FFB5709.6070403@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 12:11 AM, Thomas Huehn wrote:
> Hi Arend,
> 
>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>>> index 01b190a..d341c91 100644
>>> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
>>> @@ -665,7 +665,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>>>  			u8 plcp0, plcp3, is40, sgi;
>>>  			struct ieee80211_sta *sta;
>>>  
>>> -			sta = tx_info->control.sta;
>>> +			sta = tx_info->rate_driver_data[0];
>>
>> The sta pointer is not used in this function so this assignment is not
>> needed. Also the rate_driver_data[0] does not yet hold the sta pointer
>> upon reaching this function. brcms_c_sendampdu is called from
>> brcms_c_sendpkt_mac80211 (see below).
>>
>> Just remove the sta pointer here.
> 
> 
> Good catch ! v2 is already sent.
> 

Given the subject of this one, I suspect it should have been v3. Hope
John can keep them apart.

Gr. AvS



