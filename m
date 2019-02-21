Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4D7FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 21:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B67920818
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 21:27:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="GfZ6E6P7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfBUV1K (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 16:27:10 -0500
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:34281 "EHLO
        14.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfBUV1K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 16:27:10 -0500
Received: from player761.ha.ovh.net (unknown [10.109.146.211])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 835401CEA41
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 21:07:15 +0100 (CET)
Received: from awhome.eu (p579AAB97.dip0.t-ipconnect.de [87.154.171.151])
        (Authenticated sender: postmaster@awhome.eu)
        by player761.ha.ovh.net (Postfix) with ESMTPSA id 406EF2FAE946;
        Thu, 21 Feb 2019 20:07:14 +0000 (UTC)
Subject: Re: [RFC PATCH v3 04/12] mac80211: Compatibility Extended Key ID
 support
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1550779633;
        bh=RSIdQsu9TuEd38cxkWRk5u6IVkmEGhOBIZzGgFIFWTY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=GfZ6E6P7/wVaJ62tHup9pl1Lw1DNzh4kXIezmxSFbYGcctuf/0hBBXZFNzT0rc6/R
         HjQvD4SrRfxzBAbJ+KZMXoXx7GBKP26ugsbJvHx9o16KEPzK85/56KPLcrJcum/UzK
         qHPs+Gu6fd5OD9kc036jh/5hVLb5NsRFMKOioqF8=
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
References: <20190210210620.31181-1-alexander@wetzel-home.de>
 <20190210210620.31181-5-alexander@wetzel-home.de>
 <0519f25cf73d8a91202e40b08e94de8d2520411e.camel@sipsolutions.net>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <bad49ffb-5334-03f5-62e0-4f06d7c36242@wetzel-home.de>
Date:   Thu, 21 Feb 2019 21:07:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <0519f25cf73d8a91202e40b08e94de8d2520411e.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 356628798254030023
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedutddrtdekgddufeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 
>> +	if (!ext_native && key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE) {
>> +		key->flags |= KEY_FLAG_RX_SW_CRYPTO;
>> +		/* Activate Rx crypto offload after max 10s when idle */
>> +		ieee80211_queue_delayed_work(&local->hw, &sta->ext_key_compat_wk,
>> +					     round_jiffies_relative(HZ * 10));
>> +	}
> 
> Is there much point in this?
> 
>> +		if (unlikely(rx->key->flags & KEY_FLAG_RX_SW_CRYPTO)) {
>> +			rx->key->flags &= ~KEY_FLAG_RX_SW_CRYPTO;
>> +			cancel_delayed_work(&rx->sta->ext_key_compat_wk);
>> +			ieee80211_queue_delayed_work(&rx->local->hw,
>> +						     &rx->sta->ext_key_compat_wk, 0);
>> +		}
> 
> We'll almost certainly do it from here, so never exercise the other
> path?

This is mostly to have a definite time we know the new key is used also 
for RX. In probably 99.9% of all cases it will be triggered from the Rx 
path.
Some special purpose devices may not send any packets for a long time 
and trigger the fallback, as (wrong) firewall rules. (I've e.g. tested 
it by dropping all outgoing packets on the remote sta.)

The idea was to be sure that a rekey intervall >10s prevents activating 
Rx crypt when rekeying the next key. Which now sounds kind of thin...

So I'll remove the 10s fallback.
