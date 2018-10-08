Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A83CC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 06:38:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39FB2087D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 06:38:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jmSJ5rL8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jmSJ5rL8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39FB2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbeJHNsQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 09:48:16 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53856 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbeJHNsQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 09:48:16 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E723060B7A; Mon,  8 Oct 2018 06:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538980686;
        bh=bLa+d8B/HbsCXOz0+asoAEMIjDjycZnp74unzUQET8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jmSJ5rL8ZbEZ0xD+u1/uxhh8SF1CFRYkJgc26RQu42+jAWxtuGjmj8Ngrt3Ylf23F
         Xb4fhqAl2O/U3D9Yp2/3U/y0GW95iWHx9HXr+uutl23cVKk2O910Ik9qGe6N8/fReI
         Tl7UgKb67aZE5BwkKwFPc0Ljgp3KHodTo2rkx9rs=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 20D4E60769;
        Mon,  8 Oct 2018 06:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538980686;
        bh=bLa+d8B/HbsCXOz0+asoAEMIjDjycZnp74unzUQET8E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jmSJ5rL8ZbEZ0xD+u1/uxhh8SF1CFRYkJgc26RQu42+jAWxtuGjmj8Ngrt3Ylf23F
         Xb4fhqAl2O/U3D9Yp2/3U/y0GW95iWHx9HXr+uutl23cVKk2O910Ik9qGe6N8/fReI
         Tl7UgKb67aZE5BwkKwFPc0Ljgp3KHodTo2rkx9rs=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 08 Oct 2018 12:08:06 +0530
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH] ath10k: htt_rx: Fix signedness bug in
 ath10k_update_per_peer_tx_stats
In-Reply-To: <fcc51fdd-fc31-9d2c-2e68-4ceecbb86129@embeddedor.com>
References: <20181005184245.GA11700@embeddedor.com>
 <3a55bec6-d20d-f500-e741-b228a86b7117@candelatech.com>
 <dd75a8aa-b87c-e325-cc1d-a0efe3664a32@embeddedor.com>
 <fcc51fdd-fc31-9d2c-2e68-4ceecbb86129@embeddedor.com>
Message-ID: <af44d03892b3d51df391760af7af0382@codeaurora.org>
X-Sender: akolli@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-06 00:45, Gustavo A. R. Silva wrote:
> On 10/5/18 9:14 PM, Gustavo A. R. Silva wrote:
>> 
>> 
>> On 10/5/18 9:09 PM, Ben Greear wrote:
>>> On 10/05/2018 11:42 AM, Gustavo A. R. Silva wrote:
>>>> Currently, the error handling for the call to function
>>>> ath10k_get_legacy_rate_idx() doesn't work because
>>>> *rate_idx* is of type u8 (8 bits, unsigned), which
>>>> makes it impossible for it to hold a value less
>>>> than 0.
>>>> 
>>>> Fix this by changing the type of variable *rate_idx*
>>>> to s8 (8 bits, signed).
>>> 
>>> There are more than 127 rates, are you sure this is doing
>>> what you want?
>>> 
>> 
>> Based on the following function, rate_idx can only hold values from 0 
>> to 11
>> 
> 
> ... and of course -EINVAL too
> 
>> static inline int ath10k_get_legacy_rate_idx(struct ath10k *ar, u8 
>> rate)
>> {
>>         static const u8 legacy_rates[] = {1, 2, 5, 11, 6, 9, 12,
>>                                           18, 24, 36, 48, 54};
>>         int i;
>> 
>>         for (i = 0; i < ARRAY_SIZE(legacy_rates); i++) {
>>                 if (rate == legacy_rates[i])
>>                         return i;
>>         }
>> 
>>         ath10k_warn(ar, "Invalid legacy rate %hhd peer stats", rate);
>>         return -EINVAL;
>> }
>> 
>> Thanks
>> --
>> Gustavo
>> 
>>> Thanks,
>>> Ben
>>> 
>>>> 
>>>> Addresses-Coverity-ID: 1473914 ("Unsigned compared against 0")
>>>> Fixes: 0189dbd71cbd ("ath10k: get the legacy rate index to update 
>>>> the txrate table")
>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>> ---
>>>>  drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>> 
>>>> diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c 
>>>> b/drivers/net/wireless/ath/ath10k/htt_rx.c
>>>> index f240525..edd0e74 100644
>>>> --- a/drivers/net/wireless/ath/ath10k/htt_rx.c
>>>> +++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
>>>> @@ -2753,7 +2753,8 @@ ath10k_update_per_peer_tx_stats(struct ath10k 
>>>> *ar,
>>>>                  struct ath10k_per_peer_tx_stats *peer_stats)
>>>>  {
>>>>      struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
>>>> -    u8 rate = 0, rate_idx = 0, sgi;
>>>> +    u8 rate = 0, sgi;
>>>> +    s8 rate_idx = 0;
>>>>      struct rate_info txrate;
>>>> 
>>>>      lockdep_assert_held(&ar->data_lock);
>>>> 
>>> 
>>> 

I have sent a patch to address this,
https://patchwork.kernel.org/patch/10611943/

Thanks
Anil.
