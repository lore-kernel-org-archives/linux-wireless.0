Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42636 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbeG3Ucd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 16:32:33 -0400
Received: by mail-ed1-f66.google.com with SMTP id r4-v6so4554778edp.9
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jul 2018 11:56:12 -0700 (PDT)
Subject: Re: [PATCH] ath10k: Limit available channels via DT
 ieee80211-freq-limit
To: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org
References: <20180730153933.3771-1-sven.eckelmann@openmesh.com>
 <5B5F5EF2.2050100@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B5F5F4A.3000302@broadcom.com> (sfid-20180730_205616_112214_435FCEB4)
Date: Mon, 30 Jul 2018 20:56:10 +0200
MIME-Version: 1.0
In-Reply-To: <5B5F5EF2.2050100@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/30/2018 8:54 PM, Arend van Spriel wrote:
> + Rafał
>
> On 7/30/2018 5:39 PM, Sven Eckelmann wrote:
>> Tri-band devices (1x 2.4GHz + 2x 5GHz) often incorporate special
>> filters in
>> the RX and TX path. These filtered channel can in theory still be used by
>> the hardware but the signal strength is reduced so much that it makes no
>> sense.
>>
>> There is already a DT property to limit the available channels but ath10k
>> has to manually call this functionality to limit the currrently set wiphy
>> channels further.
>
> Wondering whether we can call it in wiphy_register() like below. Not
> sure why we did not explore that with the introduction of it by Rafał.
> Maybe he remembers. I did not find something in that direction in
> patchwork, but may have missed it. I know mt76 drops the band reference
> if it ends up with all channels disabled. Maybe that was the reason.

Sorry for sending this twice. My wifi connection was quirky.

Gr. AvS
