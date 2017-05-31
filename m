Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34100 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750898AbdEaUUv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 16:20:51 -0400
Received: by mail-qt0-f180.google.com with SMTP id c13so21533841qtc.1
        for <linux-wireless@vger.kernel.org>; Wed, 31 May 2017 13:20:51 -0700 (PDT)
Subject: Re: [PATCH] ath10k: add configurable debugging.
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20170510211925.17468-1-adrian@freebsd.org>
 <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2a6a2af2-29c7-6b74-ead1-c5ae8688a87c@broadcom.com> (sfid-20170531_222055_071580_FD6D8237)
Date: Wed, 31 May 2017 22:20:45 +0200
MIME-Version: 1.0
In-Reply-To: <87y3tdmdbo.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-05-17 14:16, Kalle Valo wrote:
> Adrian Chadd <adrian@freebsd.org> writes:
> 
>> This adds a few configurable debugging options:
>>
>> * driver debugging and tracing is now configurable per device
>> * driver debugging and tracing is now configurable at runtime
>> * the debugging / tracing is not run at all (besides a mask check)
>>   unless the specific debugging bitmap field is configured.
>>
>> Signed-off-by: Adrian Chadd <adrian@FreeBSD.org>
> 
> [...]
> 
>> --- a/drivers/net/wireless/ath/ath10k/core.c
>> +++ b/drivers/net/wireless/ath/ath10k/core.c
>> @@ -2444,6 +2444,8 @@ struct ath10k *ath10k_core_create(size_t priv_size, struct device *dev,
>>  	ar->hw_rev = hw_rev;
>>  	ar->hif.ops = hif_ops;
>>  	ar->hif.bus = bus;
>> +	ar->debug_mask = ath10k_debug_mask;
>> +	ar->trace_debug_mask = ath10k_debug_mask;
> 
> Until now tracing has been always enabled, irrespective what debug_mask
> has contained. Now you are changing that and by default log messages are
> not delivered through tracing until user enables them. So I think to
> keep the old behaviour trace_debug_mask should be ATH10K_DBG_ANY
> (0xffffffff) by default and the user can modify the mask per device via
> the debugfs file.
> 
> But is it really needed to be able to filter trace messages? debug_mask
> I understand, but not sure about trace_debug_mask.

FWIW, in brcmfmac I decided not to filter trace messages. The overhead
is relatively small and if needed you can pass filter expressions with
trace-cmd record.

Regards,
Arend
