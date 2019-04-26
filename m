Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38C6DC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 03A232077B
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:21:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="DIzwemiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfDZNVd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:21:33 -0400
Received: from [208.74.158.174] ([208.74.158.174]:54314 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbfDZNVd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:21:33 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 45DB313C283;
        Fri, 26 Apr 2019 06:21:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 45DB313C283
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1556284892;
        bh=BFTyDJC4GQT0Hq8AnB5sORQ/jFWqAvTeIusQfE0Hikg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DIzwemiSugt+JQFLHmqnh/AfwxG3wzQcjWdfWblVIQLkgarBM/n6Vups3Yn1Fd15Q
         506zNlVqflBalsQa8yCK+4UqFnF6zMLyaqq/Bx9LJrkvotJSGpE6dhlZv/BSKI25T1
         l9OV6ZKQHhuzE6eZUJitDvgI17GU5xHle/dgP7H0=
Subject: Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
To:     Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org, Kan Yan <kyan@chromium.org>
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <b9f263a4-e9da-18bb-5932-941a018ee860@candelatech.com>
Date:   Fri, 26 Apr 2019 06:21:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/26/19 5:58 AM, Venkateswara Naralasetty wrote:
> ath10k_dbg() is called in ath10k_process_rx() with huge set of arguments
> which is causing CPU overhead even when debug_mask is not set.
> Good improvement was observed in the receive side performance when call
> to ath10k_dbg() is avoided in the RX path.
> 
> Since currently all debug messages are sent via tracing infrastructure,
> we cannot entirely avoid calling ath10k_dbg. Therefore, call to
> ath10k_dbg() is made conditional based on tracing config in the driver.
> 
> Trasmit performance remains unchanged with this patch; below are some
> experimental results with this patch and tracing disabled.
> 
> mesh mode:
> 
> 		w/o this patch          with this patch
> Traffic       TP      CPU Usage      TP      CPU usage
> 
> TCP          840Mbps    76.53%      960Mbps    78.14%
> UDP          1030Mbps   74.58%      1132Mbps   74.31%
> 
> Infra mode:
> 
> 		w/o this patch          with this patch
> Traffic        TP      CPU Usage      TP      CPU usage
> 
> TCP Rx       1241Mbps   80.89%      1270Mbps   73.50%
> UDP Rx       1433Mbps   81.77%      1472Mbps   72.80%
> 
> Tested platform	: IPQ8064
> hardware used	: QCA9984
> firmware ver	: ver 10.4-3.5.3-00057
> 
> Signed-off-by: Kan Yan <kyan@chromium.org>
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> ---
> v2:
>   * changed trace enabled check from IS_ENABLED(CONFIG_ATH10K_TRACING)
>   * to trace_ath10k_log_dbg_enabled().
> 
>   drivers/net/wireless/ath/ath10k/core.c  |  2 ++
>   drivers/net/wireless/ath/ath10k/debug.c |  8 ++++----
>   drivers/net/wireless/ath/ath10k/debug.h | 22 ++++++++++++++++------
>   drivers/net/wireless/ath/ath10k/trace.c |  1 +
>   drivers/net/wireless/ath/ath10k/trace.h |  6 +++++-
>   5 files changed, 28 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
> index cfd7bb2..ab709bf 100644
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -26,6 +26,8 @@
>   #include "coredump.h"
>   
>   unsigned int ath10k_debug_mask;
> +EXPORT_SYMBOL(ath10k_debug_mask);
> +
>   static unsigned int ath10k_cryptmode_param;
>   static bool uart_print;
>   static bool skip_otp;
> diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
> index 32d967a..1b63929 100644
> --- a/drivers/net/wireless/ath/ath10k/debug.c
> +++ b/drivers/net/wireless/ath/ath10k/debug.c
> @@ -2620,8 +2620,8 @@ void ath10k_debug_unregister(struct ath10k *ar)
>   #endif /* CONFIG_ATH10K_DEBUGFS */
>   
>   #ifdef CONFIG_ATH10K_DEBUG
> -void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
> -		const char *fmt, ...)
> +void __ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
> +		  const char *fmt, ...)
>   {
>   	struct va_format vaf;
>   	va_list args;

Do you still need the check later in this method:

if (ath10k_debug_mask & mask)

since you already checked in the ath10k_dbg() macro?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

