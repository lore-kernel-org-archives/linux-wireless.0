Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.245]:41155 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758536AbZAaDML (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2009 22:12:11 -0500
Received: by ag-out-0708.google.com with SMTP id 26so439770agb.10
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2009 19:12:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4983BAB6.1020304@openwrt.org>
References: <20090131022310.GA3342@makis> <4983BAB6.1020304@openwrt.org>
Date: Sat, 31 Jan 2009 05:12:10 +0200
Message-ID: <40f31dec0901301912s797d8d8eqe245f7e842aa5b70@mail.gmail.com> (sfid-20090131_041219_561020_2CCA5818)
Subject: Re: [PATCH 1/5] ath5k: PHY code cleanup
From: Nick Kossifidis <mickflemm@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/31 Felix Fietkau <nbd@openwrt.org>:
> Nick Kossifidis wrote:
>> * Clean up initial rf buffer settings (new file rfbufer.h) and
>> introduce a new way to access specific rf registers (will use it
>> later)
>>
>> * Clean up initial rf gain settings by moving them on a new file
>> (rfgain.h) so we can later work on gain optimization functions
>>
>> * Update initial rf buffer settings and initial rf gain settings from
>> HALs. This breaks things for now because our current dumps come from
>> pre-configured rf buffer (regdumps already had the needed values set
>> from binary HAL).
>>
>> Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> For the whole series:
> Acked-by: Felix Fietkau <nbd@openwrt.org>
>
> Nick: Do you want me to rebase my 2413 RF changes on top of
> this series? Another thing: could you please test if my stuff also
> works on RF2425? I don't have such a card.
>

Sure i'll test it asap and let you know but i don't have access to the
spectrum analyzer right now (i'm still in Athens), all i can check is
that card works better than before (i guess it'll be fine, all
post-2413 chips have the same power table stuff if i recall corectly).
Feel free to rebase your changes just force a low tx power value for
now so we are not out of regulatory restrictions (i guess 3dbms are
enough) or even better comment out hw_txpower.

Thanks a lot for the ACK ;-)



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
