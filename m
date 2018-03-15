Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51942 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751289AbeCOJXP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 05:23:15 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        =?utf-8?Q?Raf?= =?utf-8?Q?a=C5=82_Mi=C5=82ecki?=
        <zajec5@gmail.com>, Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Felix Fietkau <nbd@nbd.name>, bridge@lists.linux-foundation.org
Subject: Re: [PATCH] brcmfmac: drop Inter-Access Point Protocol packets by default
References: <20180314110119.13631-1-zajec5@gmail.com>
        <878tau7n23.fsf@codeaurora.org>
        <52b1812dd3e843adb63ff67fbe95975f@milecki.pl>
        <877eqe63kr.fsf@codeaurora.org> <5AA98C3B.2070406@broadcom.com>
Date: Thu, 15 Mar 2018 11:23:07 +0200
In-Reply-To: <5AA98C3B.2070406@broadcom.com> (Arend van Spriel's message of
        "Wed, 14 Mar 2018 21:55:23 +0100")
Message-ID: <87k1ud7kw4.fsf@kamboji.qca.qualcomm.com> (sfid-20180315_102323_811695_D40FC829)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3/14/2018 5:10 PM, Kalle Valo wrote:
>> Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> writes:
>>
>>>>> +	unsigned char *eth_data =3D skb_mac_header(skb) + ETH_HLEN;
>>>>> +#if !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>>>>
>>>> #ifndef?
>>>
>>> I followed what is used in the include/linux/etherdevice.h. Is that a
>>> good exceuse? Could it be there any some good reason for #if defined()?
>>
>> Don't know, maybe just a matter of taste? But it would be nice to know
>> the background behind #ifdef vs #if defined(), never figured it out why
>> two different forms.
>
> Well. In this case you could use either one, but if you have more
> conditions #if defined() is bit more efficient:
>
> #ifdef A
> #ifdef B
> #endif
> #endif
>
> vs.
>
> #if defined(A) && defined(B)

Oh yeah, here defined() definitely helps.

--=20
Kalle Valo
