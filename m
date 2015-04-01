Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:6362 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbbDAIgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 04:36:11 -0400
Message-ID: <551BADF5.3000409@broadcom.com> (sfid-20150401_103615_645123_DCF5EC89)
Date: Wed, 1 Apr 2015 10:36:05 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Ilan Peer <ilan.peer@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<linux-wireless@vger.kernel.org>,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: Re: [PATCH 7/7] mac80211: Count correctly interface types
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>	 <1426143210-25635-7-git-send-email-emmanuel.grumbach@intel.com>	 <CALhHN=qkEmUPEL2XBuuudmq6Rg-6s7jm0TOdRuQCetgSiKyrpg@mail.gmail.com>	 (sfid-20150401_080606_876573_33E52A4C) <1427872324.2432.3.camel@sipsolutions.net>
In-Reply-To: <1427872324.2432.3.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/01/15 09:12, Johannes Berg wrote:
> On Wed, 2015-04-01 at 08:06 +0200, Janusz Dziedzic wrote:
>
>> Hello,
>>
>> Seems this one break IBSS case when started from wpa_supplicant at
>> least for Intel7260 and ath10k where dedicated p2p_device is used.
>>
>> This is wpa_supplicant log:
>> 1427867673.149187: nl80211: Set mode ifindex 8 iftype 1 (ADHOC)
>> 1427867673.149225: nl80211: Mode change succeeded while interface is down
>> 1427867673.149234: Could not set interface wlan3 flags (UP): Device or
>> resource busy
>
> That's actually the correct behaviour, given the interface limitations,
> at least for iwlmvm devices:
>
> iw list
> [...]
> 	Supported interface modes:
> 		 * IBSS
> 		 * managed
> 		 * AP
> 		 * AP/VLAN
> 		 * monitor
> 		 * P2P-client
> 		 * P2P-GO
> 		 * P2P-device
> [...]
> 	software interface modes (can always be added):
> 		 * AP/VLAN
> 		 * monitor
> 	valid interface combinations:
> 		 * #{ managed }<= 1, #{ AP, P2P-client, P2P-GO }<= 1, #{ P2P-device }<= 1,
> 		   total<= 3, #channels<= 2
>
> So there's no combination with P2P-device and IBSS together.
>
> In our device I'm pretty sure the two couldn't be supported together.
> Perhaps the supplicant has issues though with how it creates the
> P2P-Device? Should probably not be there if you have IBSS, it's pretty
> useless anyway then. Or at least not be there if the driver doesn't
> advertise support for that combination.

I think in latest wpa_s the P2P-Device is always created. There used to 
be a driver_param to create it. Not sure if that driver_param could 
still be used to avoid P2P-Device creation.

The interface combinations look confusing to me. Why is there no IBSS or 
monitor listed there?

Regards,
Arend

> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

