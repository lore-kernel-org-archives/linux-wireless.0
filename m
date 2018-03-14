Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:32822 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751748AbeCNUoY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 16:44:24 -0400
Received: by mail-wm0-f45.google.com with SMTP id s206so20194016wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 13:44:24 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: drop Inter-Access Point Protocol packets by
 default
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180314110119.13631-1-zajec5@gmail.com>
 <5AA91C67.90001@broadcom.com> <f145e568e9033db57a436ed3e2dad2c8@milecki.pl>
 <ec7ef5fd9fb4193f92c0e0189cbe5e3e@milecki.pl>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>, bridge@lists.linux-foundation.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5AA989A5.5060400@broadcom.com> (sfid-20180314_214555_840483_DB32CB65)
Date: Wed, 14 Mar 2018 21:44:21 +0100
MIME-Version: 1.0
In-Reply-To: <ec7ef5fd9fb4193f92c0e0189cbe5e3e@milecki.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/14/2018 4:57 PM, Rafał Miłecki wrote:
> On 2018-03-14 16:39, Rafał Miłecki wrote:
>> On 2018-03-14 13:58, Arend van Spriel wrote:
>>> On 3/14/2018 12:01 PM, Rafał Miłecki wrote:
>>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>>
>>>> Testing brcmfmac with more recent firmwares resulted in AP interfaces
>>>> not working in some specific setups. Debugging resulted in discovering
>>>> support for IAPP in Broadcom's firmwares. This is an obsoleted standard
>>>> and its implementation is something that:
>>>> 1) Most people don't need / want to use
>>>> 2) Can allow local DoS attacks
>>>> 3) Breaks AP interfaces in some specific bridge setups
>>>>
>>>> To solve issues it can cause this commit modifies brcmfmac to drop IAPP
>>>> packets. If affects:
>>>> 1) Rx path: driver won't be sending these unwanted packets up.
>>>> 2) Tx path: driver will reject packets that would trigger STA
>>>>     disassociation perfromed by a firmware (possible local DoS attack).
>>>>
>>>> It appears there are some Broadcom's clients/users who care about this
>>>> feature despite the drawbacks. They can switch it on by a newly added
>>>> Kconfig option.
>>>
>>> Thanks for taking this approach. Looks fine except for .... (see below)
>>>
>>> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>>> ---
>>>>   drivers/net/wireless/broadcom/brcm80211/Kconfig    | 20 +++++++++++
>>>>   .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 39
>>>> ++++++++++++++++++++++
>>>>   2 files changed, 59 insertions(+)
>>>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/Kconfig
>>>> b/drivers/net/wireless/broadcom/brcm80211/Kconfig
>>>> index 9d99eb42d917..876787ef991a 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/Kconfig
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/Kconfig
>>>> @@ -68,6 +68,26 @@ config BRCMFMAC_PCIE
>>>>         IEEE802.11ac embedded FullMAC WLAN driver. Say Y if you want to
>>>>         use the driver for an PCIE wireless card.
>>>>
>>>> +config BRCMFMAC_IAPP
>>>> +    bool "Partial support for obsoleted Inter-Access Point Protocol"
>>>> +    depends on BRCMFMAC
>>>> +    ---help---
>>>> +      Most of Broadcom's firmwares can send 802.11f ADD frame every
>>>> +      time new STA connects to the AP interface. Some recent ones
>>>> +      can also disassociate STA when they receive such a frame.
>>>
>>> I do not see any evidence that this would occur only for recent
>>> firmware. That stuff is old and not touched recently.
>>
>> My evidence is comparing firmwares for 4366b1: 10.10.69.3309 (r610991)
>> vs. 10.10 (TOB) (r663589).
>>
>> The first one is from linux-firmware.git and it doesn't implement IAPP
>> in the TX path. The later one is what I got from you privately and it
>> implements it.
>>
>> Also a firmware for 4366c0: 10.10.122.20 (r683106) which is relatively
>> new implements IAPP in the TX path.
>>
>>
>>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>> index 19048526b4af..db6987015fb1 100644
>>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
>>>
>>> [...]
>>>
>>>>   static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
>>>>                          struct net_device *ndev)
>>>>   {
>>>> @@ -250,6 +278,12 @@ static netdev_tx_t
>>>> brcmf_netdev_start_xmit(struct sk_buff *skb,
>>>>           goto done;
>>>>       }
>>>>
>>>> +    if (!IS_ENABLED(CONFIG_BRCMFMAC_IAPP) && brcmf_skb_is_iapp(skb)) {
>>>> +        dev_kfree_skb(skb);
>>>> +        ret = -EINVAL;
>>>> +        goto done;
>>>> +    }
>>>
>>> This is not right. The function must return netdev_tx_t type. Here is
>>> kerneldoc of .start_xmit():
>>>
>>>  * netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb,
>>>  *                               struct net_device *dev);
>>>  *    Called when a packet needs to be transmitted.
>>>  *    Returns NETDEV_TX_OK.  Can return NETDEV_TX_BUSY, but you
>>> should stop
>>>  *    the queue before that can happen; it's for obsolete devices and
>>> weird
>>>  *    corner cases, but the stack really does a non-trivial amount
>>>  *    of useless work if you return NETDEV_TX_BUSY.
>>>  *    Required; cannot be NULL.
>>
>> Please take a closer look at how brcmf_netdev_start_xmit() works. Above
>>  code *will* return netdev_tx_t.
>>
>>
>>> You may want to increase dropped netstat or add driver internal
>>> statistic counter so there is visibility of IAPP packets being
>>> dropped.
>>
>> OK, I'll try to find a stat to increase.
>
> So after checking brcmf_netdev_start_xmit() again, I realized I actually
> *do* that. Doing:
> ret = -EINVAL;
> goto done;
> results in increasing tx_dropped.

Okay, okay. Admittedly I only looked at the patch. Feel free to remove 
the Reviewed-by.

Regards,
Arend
