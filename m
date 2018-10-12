Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB74AC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 936E120868
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 15:28:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PErAw9U4";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M2QGQotf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 936E120868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbeJLXBG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 19:01:06 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728890AbeJLXBG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 19:01:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F1B296014B; Fri, 12 Oct 2018 15:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539358087;
        bh=0+gv33IZGQqE9q9BAMZHk+b6UvcWRI/Oj9qZQr71Veg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PErAw9U4rnuXIIKGLBplS36Wu1ODjHI5Zd8nlBbeG1Vbkm8tTZt3rK6Rqsns0xXLX
         /1VuKxUfRe7tRUsZGdreQdrmI1uljwXZd1GfPJZg6VS+c3CADaLXH7/3yQa+tGWYGi
         EPNB6hNBkouEe5r9izeSql5TPvJ86ZwASl3CEyZU=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 900F260AD8;
        Fri, 12 Oct 2018 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539358081;
        bh=0+gv33IZGQqE9q9BAMZHk+b6UvcWRI/Oj9qZQr71Veg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=M2QGQotfQDN1P0gXTmPvOWdqjgYpyEScAlELrZK0XfP53a+oMlGvpd3+dRl8WACtV
         vBOdeAbQNsuCJNZ9kkRE0GtX0uLafBbdOqfcJxwTEb8skdUd67nv4ZLOQhov3+5Awp
         6v7xGyn+OJZdLK0QsNz654fMS+SXGc9fkRI6+CRo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 900F260AD8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Venkateswara Naralasetty <vnaralas@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@chromium.org>
Subject: Re: [PATCH] ath10k: Add wrapper function to ath10k debug
References: <1537766878-11238-1-git-send-email-vnaralas@codeaurora.org>
Date:   Fri, 12 Oct 2018 18:27:56 +0300
In-Reply-To: <1537766878-11238-1-git-send-email-vnaralas@codeaurora.org>
        (Venkateswara Naralasetty's message of "Mon, 24 Sep 2018 10:57:58
        +0530")
Message-ID: <87va672nib.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Venkateswara Naralasetty <vnaralas@codeaurora.org> writes:

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
>                       w/o this patch          with this patch
>         Traffic       TP      CPU Usage      TP      CPU usage
>
>         TCP          840Mbps    76.53%      960Mbps    78.14%
>         UDP          1030Mbps   74.58%      1132Mbps   74.31%
>
> Infra mode:
>
>                       w/o this patch          with this patch
>         Traffic        TP      CPU Usage      TP      CPU usage
>
>         TCP Rx       1241Mbps   80.89%      1270Mbps   73.50%
>         UDP Rx       1433Mbps   81.77%      1472Mbps   72.80%
>
> Tested platform	: IPQ8064
> hardware used	: QCA9984
> firmware ver	: ver 10.4-3.5.3-00057
>
> Signed-off-by: Kan Yan <kyan@chromium.org>
> Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>

The first Signed-off-by should be the author's, in this case
Venkateswara. If Kan helped to develop the patch you should also add
Co-developed-by:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by

> +/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
> + * disabled.
> + */
> +#define ath10k_dbg(ar, dbg_mask, fmt, ...)				\
> +do {									\
> +	if (IS_ENABLED(CONFIG_ATH10K_TRACING) ||			\
> +	    (ath10k_debug_mask & dbg_mask))				\
> +		__ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__);		\
> +} while (0)
>  #endif /* _DEBUG_H_ */

Johannes had an interesting idea to use trace_ath10k_log_dbg_enabled().
Could you investigate if that would work? That way we might get the
performance improvement even when is enabled CONFIG_ATH10K_TRACING (but
actual trace point is disabled, of course).

Documentation/trace/tracepoints.rst has more info about the
trace_*_enabled() function. It does have a special requirement but I'm
not sure if it matters here as we don't care if we loose a message or
two in the beginning:

    "The trace_<tracepoint>() should always be within the block of the
     if (trace_<tracepoint>_enabled()) to prevent races between the
     tracepoint being enabled and the check being seen."

-- 
Kalle Valo
