Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34258 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753677AbdEJQuk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 May 2017 12:50:40 -0400
Received: by mail-wr0-f193.google.com with SMTP id 6so185938wrb.1
        for <linux-wireless@vger.kernel.org>; Wed, 10 May 2017 09:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLGbRL8NQi03U60AwEtOq-W0mFOn1uDmc_TXWRJofPqcP6VXg@mail.gmail.com>
References: <20170510162546.15439-1-adrian@freebsd.org> <CALLGbRL8NQi03U60AwEtOq-W0mFOn1uDmc_TXWRJofPqcP6VXg@mail.gmail.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Wed, 10 May 2017 09:50:38 -0700
Message-ID: <CAJ-Vmom+3Gecd=rejpQyfuAOkmk3cg8uES7Cvt_h1Pye5vMa2g@mail.gmail.com> (sfid-20170510_185043_883988_68D67B85)
Subject: Re: [PATCH] ath10k: add configurable debugging.
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

grr, no. lemme go re-add that and resubmit.

thanks!


-a


On 10 May 2017 at 09:44, Steve deRosier <derosier@gmail.com> wrote:
> Hi Adrian,
>
> On Wed, May 10, 2017 at 9:25 AM, Adrian Chadd <adrian@freebsd.org> wrote:
>
>> diff --git a/drivers/net/wireless/ath/ath10k/debug.h b/drivers/net/wireless/ath/ath10k/debug.h
>> index 257d10985c6e..7bd461927029 100644
>> --- a/drivers/net/wireless/ath/ath10k/debug.h
>> +++ b/drivers/net/wireless/ath/ath10k/debug.h
>> @@ -200,27 +200,43 @@ void ath10k_sta_update_rx_duration(struct ath10k *ar,
>>  #endif /* CONFIG_MAC80211_DEBUGFS */
>>
>>  #ifdef CONFIG_ATH10K_DEBUG
>> -__printf(3, 4) void ath10k_dbg(struct ath10k *ar,
>> +static inline int
>> +_ath10k_do_dbg(struct ath10k *ar, enum ath10k_debug_mask mask)
>> +{
>> +       if (ar->trace_debug_mask & mask)
>> +               return (1);
>> +       if (ar->debug_mask & mask)
>> +               return (1);
>> +       return (0);
>> +}
>> +
>> +void _ath10k_dbg(struct ath10k *ar,
>>                                enum ath10k_debug_mask mask,
>>                                const char *fmt, ...);
>> -void ath10k_dbg_dump(struct ath10k *ar,
>> +
>> +void _ath10k_dbg_dump(struct ath10k *ar,
>>                      enum ath10k_debug_mask mask,
>>                      const char *msg, const char *prefix,
>>                      const void *buf, size_t len);
>> +
>> +#define        ath10k_dbg(ar, mask, ...)                                       \
>> +       do {                                                            \
>> +               if (_ath10k_do_dbg(ar, mask)) {                         \
>> +                       _ath10k_dbg((ar), (mask), __VA_ARGS__);         \
>> +               };                                                      \
>> +       } while (0)
>> +
>
> Looks to me you dropped the "__printf(3, 4)" safety check. Was that intentional?
>
> Thanks,
> - Steve
