Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fbr02-uk.csee.siteprotect.eu ([81.3.27.132]:38618 "EHLO
	fbr02-uk.csee.siteprotect.eu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751966AbcAEQTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 11:19:32 -0500
Subject: Re: Reading the current monitor flags of an interface
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <5687FA72.9000301@beardandsandals.co.uk>
 <1452009755.12357.44.camel@sipsolutions.net>
From: Roger James <roger@beardandsandals.co.uk>
Message-ID: <568BED11.50302@beardandsandals.co.uk> (sfid-20160105_171939_714951_75698BB1)
Date: Tue, 5 Jan 2016 16:19:29 +0000
MIME-Version: 1.0
In-Reply-To: <1452009755.12357.44.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/01/16 16:02, Johannes Berg wrote:
> On Sat, 2016-01-02 at 16:27 +0000, Roger James wrote:
>> Hi,
>>
>> I am trying to get at the current monitor flags setting of a wireless
>> monitor mode virtual interface. I have tried to do this by hacking
>> the
>> iw source. However I never see a NL80211_ATTR_MNTR_FLAGS attribute
>> returned in response to the
>>
>> TOPLEVEL(info, NULL, NL80211_CMD_GET_INTERFACE, 0, CIB_NETDEV,
>> handle_interface_info,
>>        "Show information for this interface.");
>>
>> command in iw's interface.c code.
>>
>> Questions.
>>
>> 1. Am I wasting my time? (e.g. the rt2800usb driver never returns
>> this
>> info, or there is another easy way of viewing this info, etc)
>>
> Looks like it's never set in the corresponding kernel code.
>
> johannes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Thanks Johannes, that was my conclusion, but I was not sure if that was 
true in all cases. I tried another chipset and got the same results. I 
am trying to debug a problem with an adapter only seeing broadcast and 
multicast packets in monitor mode, and the significance of the setting 
of the  otherbss flag in this case. It would be really helpful if iw 
could return the complete state of an interface, but it looks like that 
would require a kernel patch. This seems like a can of worms to me.

Roger
