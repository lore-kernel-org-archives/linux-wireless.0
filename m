Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64323 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab1GDKtC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2011 06:49:02 -0400
Received: by yxi11 with SMTP id 11so1544107yxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Jul 2011 03:49:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E1199A9.2040008@openwrt.org>
References: <1309758467-1712-1-git-send-email-nbd@openwrt.org>
	<1309758467-1712-2-git-send-email-nbd@openwrt.org>
	<1309758467-1712-3-git-send-email-nbd@openwrt.org>
	<1309758467-1712-4-git-send-email-nbd@openwrt.org>
	<CAFtRNNzHqQLYxoZBBgpyttLgXRp1SWabPdQvNr4gvRPvPpPOBw@mail.gmail.com>
	<4E1199A9.2040008@openwrt.org>
Date: Mon, 4 Jul 2011 13:49:01 +0300
Message-ID: <CAFtRNNxOe5u-oUO-a6q-rGhnL6SOzpYZ2kATrm3DigAJZk8U6Q@mail.gmail.com> (sfid-20110704_124907_436811_BEA991B0)
Subject: Re: [ath5k-devel] [PATCH 4/8] ath5k: initialize common->clockrate
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/7/4 Felix Fietkau <nbd@openwrt.org>:
> On 2011-07-04 5:40 PM, Nick Kossifidis wrote:
>>
>> 2011/7/4 Felix Fietkau<nbd@openwrt.org>:
>>>
>>>  Fixes a division by zero when setting distance before activating the
>>>  device for the first time.
>>>
>>>  Signed-off-by: Felix Fietkau<nbd@openwrt.org>
>>>  ---
>>>   drivers/net/wireless/ath/ath5k/base.c |    1 +
>>>   1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>>  diff --git a/drivers/net/wireless/ath/ath5k/base.c
>>> b/drivers/net/wireless/ath/ath5k/base.c
>>>  index a6623dd..a413aa7 100644
>>>  --- a/drivers/net/wireless/ath/ath5k/base.c
>>>  +++ b/drivers/net/wireless/ath/ath5k/base.c
>>>  @@ -2422,6 +2422,7 @@ ath5k_init_softc(struct ath5k_softc *sc, const
>>> struct ath_bus_ops *bus_ops)
>>>         common->ah = sc->ah;
>>>         common->hw = hw;
>>>         common->priv = sc;
>>>  +       common->clockrate = 40;
>>>
>>>         /*
>>>          * Cache line size is used to size and align various
>>>  --
>>>  1.7.3.2
>>>
>>
>> We better set this to 44 for g (according to docs core frequency is 44MHz
>> for g)
>
> It shouldn't make a difference, since the first hardware reset will reload
> all the settings anyway.
>
> - Felix
>

O.K.

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
