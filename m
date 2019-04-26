Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9275C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 998B42077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:56:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="BwwPax0P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfDZN4d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:56:33 -0400
Received: from [208.74.158.174] ([208.74.158.174]:55288 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbfDZN4c (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:56:32 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 106D013C283;
        Fri, 26 Apr 2019 06:56:31 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 106D013C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1556286991;
        bh=176ZJmXrE5Ffios5h1F6VNQEhzbC3d6Sn0napwsYuYo=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=BwwPax0PQKjUNkKDE1cMXq2PMFm35XRnbqn+xhNlO39JfvPFnRzo70bq909ZytqNW
         XM+gylcZ3CfffIbFBmwLUEkuTxvS55Yxqw5ssSOa6cUiO4fFp+zMjbLym8dkDm9l8N
         lfQRxhMCx5TmFMvFTGSVdxFXPDpoFlq39687ryLw=
Subject: Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
To:     =?UTF-8?Q?Micha=c5=82_Kazior?= <kazikcz@gmail.com>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Kan Yan <kyan@chromium.org>
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
 <CABvG-CVxmnm=JsSsgYQqEzHHYU8RJDxqCZJn4Rzy=zPLtKY1hA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <52f8d2ff-9bd0-d456-e29a-c60b99a1eb8a@candelatech.com>
Date:   Fri, 26 Apr 2019 06:56:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CABvG-CVxmnm=JsSsgYQqEzHHYU8RJDxqCZJn4Rzy=zPLtKY1hA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/26/19 6:44 AM, Michał Kazior wrote:
> On Fri, 26 Apr 2019 at 14:58, Venkateswara Naralasetty
> <vnaralas@codeaurora.org> wrote:
>>
>> ath10k_dbg() is called in ath10k_process_rx() with huge set of arguments
>> which is causing CPU overhead even when debug_mask is not set.
>> Good improvement was observed in the receive side performance when call
>> to ath10k_dbg() is avoided in the RX path.
> [...]
> 
>> +/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
>> + * disabled.
>> + */
>> +#define ath10k_dbg(ar, dbg_mask, fmt, ...)                     \
>> +do {                                                           \
>> +       if ((ath10k_debug_mask & dbg_mask) ||                   \
>> +           trace_ath10k_log_dbg_enabled())                     \
>> +               __ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \
>> +} while (0)
> 
> Did you consider using jump labels (see include/linux/jump_label.h)?
> It's what tracing uses under the hood. I wonder if you could squeeze
> out a bit more performance with that? I guess you'd need to add
> `struct static_key ath10k_dbg_mask_keys[ATH10K_DBG_MAX]` and re-do
> ath10k_debug_mask enum a bit.

Maybe first test with debugging just compiled out to see if there is still
any significant overhead with this new patch applied?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

