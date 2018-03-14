Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34322 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751379AbeCNUz0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 16:55:26 -0400
Received: by mail-wm0-f50.google.com with SMTP id a20so20214349wmd.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Mar 2018 13:55:25 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: drop Inter-Access Point Protocol packets by
 default
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20180314110119.13631-1-zajec5@gmail.com>
 <878tau7n23.fsf@codeaurora.org> <52b1812dd3e843adb63ff67fbe95975f@milecki.pl>
 <877eqe63kr.fsf@codeaurora.org>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
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
Message-ID: <5AA98C3B.2070406@broadcom.com> (sfid-20180314_215529_956986_F47430AC)
Date: Wed, 14 Mar 2018 21:55:23 +0100
MIME-Version: 1.0
In-Reply-To: <877eqe63kr.fsf@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/14/2018 5:10 PM, Kalle Valo wrote:
> Rafał Miłecki <rafal@milecki.pl> writes:
>
>>>> +	unsigned char *eth_data = skb_mac_header(skb) + ETH_HLEN;
>>>> +#if !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>>>
>>> #ifndef?
>>
>> I followed what is used in the include/linux/etherdevice.h. Is that a
>> good exceuse? Could it be there any some good reason for #if defined()?
>
> Don't know, maybe just a matter of taste? But it would be nice to know
> the background behind #ifdef vs #if defined(), never figured it out why
> two different forms.

Well. In this case you could use either one, but if you have more 
conditions #if defined() is bit more efficient:

#ifdef A
#ifdef B
#endif
#endif

vs.

#if defined(A) && defined(B)

Regards,
Arend
