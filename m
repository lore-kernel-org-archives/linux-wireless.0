Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7226EC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:52:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A5ED2075A
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 21:52:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="DM6OgTR+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbfBVVwr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 16:52:47 -0500
Received: from 5.mo2.mail-out.ovh.net ([87.98.181.248]:42641 "EHLO
        5.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbfBVVwq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 16:52:46 -0500
X-Greylist: delayed 1802 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Feb 2019 16:52:46 EST
Received: from player739.ha.ovh.net (unknown [10.109.159.222])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 67AF41846F4
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2019 22:15:11 +0100 (CET)
Received: from awhome.eu (p57B7E5A0.dip0.t-ipconnect.de [87.183.229.160])
        (Authenticated sender: postmaster@awhome.eu)
        by player739.ha.ovh.net (Postfix) with ESMTPSA id 31913321600A;
        Fri, 22 Feb 2019 21:15:10 +0000 (UTC)
Subject: Re: [RFC PATCH v3 08/12] iwlwifi: dvm - EXT_KEY_ID A-MPDU API update
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550870109;
        bh=2YBMr/x42U0TNcfY/BEGp8175TyFuApL3hDvDG+Tqnw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=DM6OgTR+h2f0T+PHEIzubqhUt1TyxzGEHB8t7Js6wzaIhy6+aw/2znuWxFWaLtLRs
         wYUjbnF8L+8+hYb6IpH4hnlt6sFoLvNqgOvNCNe0t1FV2wQ2EyBtCDpWef4tiJxpQa
         WsTUdrqVKOWqGUkuCF0CifwsojQkncg3z1ZaShoA=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-9-alexander@wetzel-home.de>
 <63fecadcf3f38f24b547143d9d53b3454adc417a.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <4bd73bd3-9027-4689-54e7-7c082eefa327@wetzel-home.de>
Date:   Fri, 22 Feb 2019 22:15:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <63fecadcf3f38f24b547143d9d53b3454adc417a.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 7376614717861010631
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddruddtgddugeelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
>> When using Extended Key ID mac80211 drops @IEEE80211_TX_CTL_AMPDU for
>> the last packet which can be added to a A-MPDU in preparation.
>>
>> Don't throw a warning and just handle the frame as if
>> @IEEE80211_TX_CTL_AMPDU would have been set.
>>
>> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
>> ---
>>
>> I cold not figure out so far how to make sure the card will not mix
>> A-MPDU frames. Looks like that is handled fully in the HW and I didn't
>> find any interface to influence it. (It even may work already, I have
>> some problems to capture A-MPDU frames with A-MPDU information intact
>> and the topic was pretty low on the list so far. After all it works...)
> 
> You can't really do that, as far as I can tell, unfortunately. So this
> might be better in a "compat on steroids" mode?

I hoped that the HW would already enforce the key border. But ok: The 
cards will still be able to use NATIVE mode. Only now the driver will 
have to request to disable Tx aggregation when finding a key border. 
Since Tx aggregation is disabled per default anyhow many users will not 
even see a difference.

(Off topic here, but I suspect the not reproducible problems leading to 
change the Tx aggregation default to off could also have been ptk0 rekey 
freezes. In that case we could now allow it again. But I've not found 
raw error reports and guess it's not worth the efforts/risks to change 
the default again.)

Alexander
