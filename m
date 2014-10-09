Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:40595 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaJIKW3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 06:22:29 -0400
Message-ID: <543661E1.3050606@broadcom.com> (sfid-20141009_122231_467971_9AEAF56C)
Date: Thu, 9 Oct 2014 12:22:25 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Maximilian Engelhardt <maxi@daemonizer.de>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Seth Forshee <seth.forshee@canonical.com>,
	"brcm80211 development" <brcm80211-dev-list@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH][RTF][RFC] brcmsmac: add workaround for old BCM4313 devices
 with Bluetooth
References: <1412843867-26563-1-git-send-email-zajec5@gmail.com>	<CACna6ry-+hzMJ4n5PG7GJq9fZ+zwU38HGt-xZkUqKEP8yX6avA@mail.gmail.com>	<54365985.1020104@broadcom.com> <CACna6ryTwBQQnbZg+CSvoYakb4DA1+FH7j-XwfuYmoDzJORenA@mail.gmail.com>
In-Reply-To: <CACna6ryTwBQQnbZg+CSvoYakb4DA1+FH7j-XwfuYmoDzJORenA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/14 12:11, Rafał Miłecki wrote:
> On 9 October 2014 11:46, Arend van Spriel<arend@broadcom.com>  wrote:
>> On 10/09/14 11:02, Rafał Miłecki wrote:
>>>
>>> On 9 October 2014 10:37, Rafał Miłecki<zajec5@gmail.com>   wrote:
>>>>
>>>> +       /* TODO: Fix the condition. Only for boards>= P250 */
>>>> +       if (ai_get_chip_id(wlc_hw->sih) == BCMA_CHIP_ID_BCM4313&&
>>>> (wlc_hw->boardflags&   BFL_FEM_BT)) {
>>>> +               pr_info("Applying BCM4313 WL/BT workaround\n");
>>>> +               ai_btcombo_p250_4313_war(wlc_hw->sih);
>>>> +       }
>>>
>>>
>>> This of course have to be checked in some hardware documentation for
>>> the correct condition. We already have some workaround (right above
>>> the newly added code) for boards with boardrev>= 0x1250. So my guess
>>> is the code I added applies to some other cards. The board this patch
>>> is supposed to fix is:
>>> board vendor: 14e4
>>> board type: 608
>>> board revision: 1109
>>> board flags: 402201
>>> board flags2: 884
>>> firmware revision: 262032c
>>>
>>> So whatever condition we will need it'll likely need to cover above
>>> case (maybe boardrev == 0x1109?).
>>
>>
>> Well, there is something fishy going on. The brcmsmac code looks like:
>>
>> if (bfl&  BFL_FEM&&  chip == 4313) {
>>          if (!(boardrev>= 0x1250&&  bfl&  BFL_FEM_BT))
>>                  ai_epa_4313war(wlc_hw->sih);
>> }
>
> Ohh, I didn't notice this negation at the beginning... Now meaning of
> my functions makes more sense. The old code it only for boardrev<
> 0x1250 (plus other conditions). This new function has "p250" in its
> name, that may mean it's for boardrev>= 0x1250.
>
>
>> However the boardflags above (0x402201) only has BFL_FEM_BT set so this code
>> is never called. I have to ask if !BFL_FEM&&  BFL_FEM_BT is a valid
>> combination.
>
> Yeah, that's fishy. Maybe that new function ai_btcombo_p250_4313_war
> should be called if !BFL_FEM&&  BFL_FEM_BT? But it sounds weird.

I know where the function should be called according our driver and 
guess what:

   if (bfl&  BFL_FEM&&  chip == 4313) {
   	if (!(boardrev>= 0x1250 && bfl&  BFL_FEM_BT))
           	ai_epa_4313war(wlc_hw->sih);
+	else
+		ai_btcombo_p250_4313_war(wlc_hw->sih);
   }

I hate this inverse logic as it is so easy to overlook ;-)

Regards,
Arend
