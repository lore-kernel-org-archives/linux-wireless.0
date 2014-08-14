Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:50199 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbaHNISX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2014 04:18:23 -0400
Message-ID: <53EC70C7.2030008@broadcom.com> (sfid-20140814_101836_576913_9DB01CD8)
Date: Thu, 14 Aug 2014 10:18:15 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: "C. McPherson" <ccmcphe@verizon.net>,
	Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Netlink Question
References: <53E917AB.3020002@verizon.net> <53E9D38B.1060509@broadcom.com> <CABPxzYK3wwGigXnPL7ZoQYTyenqf0kcNs4naxB2+8bsdeARj9g@mail.gmail.com> <53EBB602.7060901@verizon.net>
In-Reply-To: <53EBB602.7060901@verizon.net>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/13/2014 09:01 PM, C. McPherson wrote:
>
> On 08/12/2014 05:32 AM, Krishna Chaitanya wrote:
>> On Tue, Aug 12, 2014 at 2:12 PM, Arend van Spriel <arend@broadcom.com>
>> wrote:
>>> + linux-wireless
>>>
>>> Not really a backports question so adding linux-wireless
>>>
>>> On 08/11/2014 09:21 PM, C. McPherson wrote:
>>>> I have some private WiFi ioctl's that are associated with a couple of
>>>> drivers and I would like to convert those private ioctl's into netlink.
>>>> Does anyone know if there is any documentation on this or a URL that I
>>>> could reference before I attempt?
>>>
>>> I guess the "private WiFi ioctl's" you are referring to are the ones
>>> used in Android wpa_supplicant driver_cmd lib? There is no real
>>> cookbook on how to add nl80211 commands (maybe I am wrong here), but
>>> there are sufficient patches to be found in the linux-wireless
>>> archive. A recent one about key management offload adds a couple of
>>> commands and attributes which may give an idea what is needed:
>>>
>>> http://mid.gmane.org/1406076875-8549-1-git-send-email-clanctot@qca.qualcomm.com
>>>
>>>
>>> Obviously, you need to modify the "couple of drivers" to deal with
>>> the nl80211 netlink commands.
>>>
>> We had same requirement in our driver,  we have patched the iw to send
>> custom commands specific to our hardware and used NL80211_CMD_TESTMODE
>> to process and send it to driver.
>> --
>> To unsubscribe from this list: send the line "unsubscribe backports" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> Yeah thanks a lot, I could use NL80211_CMD_TESTMODE, I'll have to check
> that out. I was also thinking about using NL80211_CMD_VENDOR. These
> IOCTL's are not and will not be used by wpa_supplicant (but I will check
> out the URL you sent), they are just some custom commands we use with
> several chipsets.

If you are using recent kernel or backports package, I would say go for 
the vendor command. It is quite similar to TESTMODE except that it is 
always enabled, ie. not depending on kernel config.

However, if the custom commands would add functionality that might be 
interesting to linux-wireless drivers in general you may consider adding 
them as nl80211 commands.

Regards,
Arend

