Return-Path: <SRS0=DbkN=SR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0756DC10F0E
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:11:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9A8820880
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Apr 2019 15:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BqnvLoJW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfDOPLb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Apr 2019 11:11:31 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33966 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727456AbfDOPLa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Apr 2019 11:11:30 -0400
Received: by mail-lj1-f195.google.com with SMTP id j89so16022355ljb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2019 08:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZJ72lDUMbTTlNUfwojOOLgHyRg5scfMx60Rr8ZhneCo=;
        b=BqnvLoJWht2MDyTwPARoBjNsv2btlenn/07dxmtmL5yIaRCTx/sxyOSAbFXTtSYila
         l8xrlWmexjcBse5dm2dcVqyR0hWlKCnbGZOJDLS20GcMzfK8s2Zsye2TuyCsdohGQW1d
         hsnyK98169TKnx25t1zvknIlBS8kIi9dj3tujCZAEoGu3Ew13jqQZAAM1/9qCepOv2KP
         fgdBXjMEwHY6Xzc1QxiHdJ3DyVmp13BxZUetHKzn2FF46tj4b8Ukci5UH5qczUh79mvf
         KarEatJbP8jfVo7a1Z/En/s4rdTscgZ83MFFrxWUwwVQhAgBbxcG3Rleuvryzzz+zGJM
         WJvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZJ72lDUMbTTlNUfwojOOLgHyRg5scfMx60Rr8ZhneCo=;
        b=FYM2WYslCiE4fCOxFywJYZjPkIWbfHqiZWrOE2Mcxafc0Y0bgCBTjiMJuYqJj1KVbf
         6VCB4S8Y7IRJqoVK01OaLOPLIbylISmVGAOCzHBl7vADD8s+3iJcz7CUf3e9hwuX7cON
         2r0nWC+2BGSHirlE6IUYRxeZLeviMS2RxzpyZMx655HTBIK2HQ1HwZ9D6L7E7WQpTIMp
         gZpT6mkNxE2X7iIRrGtvcUsa8BQ5HRiNwpszN49364rCIKWpWl7fIOt78vUe5Ja2U4uc
         mY3nigIWf93jsATao3yjTAjq36g92JGk2lAiciNxzSb7mqV6VX7Xm3W5dqm77f2uspFP
         a/Rw==
X-Gm-Message-State: APjAAAVS5W45sq9sjSE+PRzrq7dBKBYYHV6bozX9U72QWgxvRJsecLGe
        2vBsBYs+LSCNrFRWGwXv35mH3bPA
X-Google-Smtp-Source: APXvYqwPjryTrDK/5n6mhlN/ESzaiRJ0xjaAP/UzTcJ20PEiv+Zy6FmYi9fyIjsgxO+3ZW379a/6/g==
X-Received: by 2002:a2e:8507:: with SMTP id j7mr14701lji.85.1555341088726;
        Mon, 15 Apr 2019 08:11:28 -0700 (PDT)
Received: from [192.168.1.244] (81-233-89-221-no75.tbcn.telia.com. [81.233.89.221])
        by smtp.gmail.com with ESMTPSA id n10sm11105831ljh.36.2019.04.15.08.11.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 08:11:28 -0700 (PDT)
Subject: Re: [PATCH 6/6] ath10k: sdio: replace skb_trim with explicit set of
 skb->len
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
References: <20190409190851.4557-1-erik.stromdahl@gmail.com>
 <20190409190851.4557-7-erik.stromdahl@gmail.com>
 <87zhovcqhl.fsf@kamboji.qca.qualcomm.com>
From:   Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <deca77d1-f171-e0cd-b571-89c2f8bafc87@gmail.com>
Date:   Mon, 15 Apr 2019 17:11:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <87zhovcqhl.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 4/12/19 3:17 PM, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
> 
>> This patch fixes a bug with padding of the skb data buffer.
>> Since skb_trim can only be used to reduce the skb len, it is useless when
>> we pad (increase the length of) the skb. Instead we must set skb->len
>> directly.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/sdio.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
>> index 3eb241cb8a25..989e3f563f3d 100644
>> --- a/drivers/net/wireless/ath/ath10k/sdio.c
>> +++ b/drivers/net/wireless/ath/ath10k/sdio.c
>> @@ -1496,7 +1496,12 @@ static int ath10k_sdio_hif_tx_sg(struct ath10k *ar, u8 pipe_id,
>>   		skb = items[i].transfer_context;
>>   		padded_len = ath10k_sdio_calc_txrx_padded_len(ar_sdio,
>>   							      skb->len);
>> -		skb_trim(skb, padded_len);
>> +		/* FIXME: unsure if just extending the skb len is the right
>> +		 * thing to do since we might read outside the skb->data
>> +		 * buffer. But we really don't want to realloc the skb just to
>> +		 * pad the length.
>> +		 */
>> +		skb->len = padded_len;
> 
> Good catch! But I don't think you can modify skb->len directly like
> that. There is skb_pad() but that doesn't change skb->len, so that most
> likely needs more changes. So maybe skb_put() is the safest here?
> 
I have tried a few different solutions for this, but none seems to be
bullet proof.

skb_pad() raises a BUG() if there is not enough space in skb->data.

The best candidate so far has been skb_put_padto(). It pads and reallocates
the skb if needed.

The problem is that it also cause a panic if there is more than one reference
to the skb (skb_shared() returns true).

Some of the management frames via nl80211 have a refcount of 2.
In this case it is not possible to free and allocate the skb since there are
other users/references.

I think I will have to make some kind of solution where I copy the content of
the skb to an internal buffer instead.
