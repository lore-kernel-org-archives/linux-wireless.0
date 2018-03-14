Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43492 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750862AbeCNQKU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 12:10:20 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
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
Date: Wed, 14 Mar 2018 18:10:12 +0200
In-Reply-To: <52b1812dd3e843adb63ff67fbe95975f@milecki.pl> (=?utf-8?Q?=22R?=
 =?utf-8?Q?afa=C5=82_Mi=C5=82ecki=22's?=
        message of "Wed, 14 Mar 2018 16:44:43 +0100")
Message-ID: <877eqe63kr.fsf@codeaurora.org> (sfid-20180314_171025_003913_C84B4FA5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl> writes:

>>> +	unsigned char *eth_data =3D skb_mac_header(skb) + ETH_HLEN;
>>> +#if !defined(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)
>>
>> #ifndef?
>
> I followed what is used in the include/linux/etherdevice.h. Is that a
> good exceuse? Could it be there any some good reason for #if defined()?

Don't know, maybe just a matter of taste? But it would be nice to know
the background behind #ifdef vs #if defined(), never figured it out why
two different forms.

--=20
Kalle Valo
