Return-Path: <SRS0=d+R+=CQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8ED8C2D0E0
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 16:25:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7246720678
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 16:25:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c7/0AXxm";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="ZQ+WkNJG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgIGQZ2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:25:28 -0400
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:36162
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730333AbgIGQZW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Sep 2020 12:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599495922;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=uC6aquUmIjDpwEsVJnaHXWj+WFYelQTAusJJrY1BpCc=;
        b=c7/0AXxmyuCR8uJeBK277Uk60P2jzFf2mJfxLR8kt3el9wVK0eqLH0ArDeFoECad
        Hu+hs6fO6Mvqos5warmSdxTjqob6I5GakgMR64NtqGurh6Mi0nuCjvhz4SP4539AOkk
        9Na3xnomZN/NxfsyseNJvPUQB1nHOxRnSh2SrrJk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599495922;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=uC6aquUmIjDpwEsVJnaHXWj+WFYelQTAusJJrY1BpCc=;
        b=ZQ+WkNJGzQwO9d1MhIMEdKjTE78YOqQ+tT9IhV0akVNcZV+Sree0FTG517qDe5dw
        +eyYIjmU20BedvCKm8Vg/3ZStXhkgaHsnocPqTIskOb6TTvqUNugUMO75y6Ek/D/wWB
        3n4PqbHtu9Z6yk/1L9nNoJk4wxzqlIi/KpnrM9YU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3E5C5C560C8
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     akolli@codeaurora.org
Cc:     devicetree@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org
Subject: Re: [PATCH v6 2/3] ath11k: copy ce service configs to hw_params
References: <1598287470-1871-1-git-send-email-akolli@codeaurora.org>
        <1598287470-1871-3-git-send-email-akolli@codeaurora.org>
        <87363t52nj.fsf@codeaurora.org>
        <010101746838d751-613bfbba-7cfe-496c-9244-41fc2262f665-000000@us-west-2.amazonses.com>
Date:   Mon, 7 Sep 2020 16:25:22 +0000
In-Reply-To: <010101746838d751-613bfbba-7cfe-496c-9244-41fc2262f665-000000@us-west-2.amazonses.com>
        (akolli@codeaurora.org's message of "Mon, 7 Sep 2020 10:59:49 +0000")
Message-ID: <010101746962e1ce-dcf1c48c-efdc-4f9f-b28b-7839697630ce-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2020.09.07-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

akolli@codeaurora.org writes:

> On 2020-09-07 15:28, Kalle Valo wrote:
>> Anilkumar Kolli <akolli@codeaurora.org> writes:
>>
>>> No functional changes, added target ce service configurations to
>>> hw_params.
>>>
>>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
>>
>> [...]
>>
>>> --- a/drivers/net/wireless/ath/ath11k/core.c
>>> +++ b/drivers/net/wireless/ath/ath11k/core.c
>>> @@ -812,12 +812,6 @@ int ath11k_core_init(struct ath11k_base *ab)
>>>  		return ret;
>>>  	}
>>>
>>> -	ret = ath11k_init_hw_params(ab);
>>> -	if (ret) {
>>> -		ath11k_err(ab, "failed to get hw params %d\n", ret);
>>> -		return ret;
>>> -	}
>>
>> This is very suspicious.
>
> ath11k_core_pre_init() is calling ath11k_init_hw_params(), again
> calling same function in ath11k_core_init() is not needed.
>
> Will send this as a new patch ?

Yes, please send this in a new patch with a proper commit log explaining
the situation.

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
