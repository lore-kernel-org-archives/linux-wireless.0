Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC493C282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C17620855
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 15:44:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g727yUE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729050AbfAVPoj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 10:44:39 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:35399 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbfAVPoj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 10:44:39 -0500
Received: by mail-oi1-f193.google.com with SMTP id v6so17764200oif.2;
        Tue, 22 Jan 2019 07:44:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jySj76otXaOTOM3jZMZUQKaNajoL056bBFNn8sS0UsA=;
        b=g727yUE8A2nSQzRd7uw1KsHFd6KYx0dPQ+wd/RYy5DKg0nQn/4zcaNbj2/ZhRMrdKw
         hwAt31ShcD0EdxGjvLygy8jlikmMbY6Y8rrG1hVm4TxNuk5L7093MN6dUhSvguCFjtV7
         Rd+p4r0yQi+UMNX7X8/ne0IR5DfECOCHUtZ4wj4oEs8cAYexEDnDLr7dbQx+1sCvzYZz
         NfJR8VPETFi0Ja8/l7YAs1FTxkgzWkWDBjTA53AD0HfsnyqNZ9m/IqtfOqBW3uyx2PAn
         vNrPcoRX2Fq28xh11qF++JCdr9Xsh04nWxjS1yKexFqycxcLcCy+g8BVi2PX+JmRq0rk
         x8BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jySj76otXaOTOM3jZMZUQKaNajoL056bBFNn8sS0UsA=;
        b=FgqrEQFj0WJxu27Ae2N/Xpaw160T/DGb6tbgHy4KkXMRALVQ09CgtZ7BahKyf3gfVm
         HU97KT2Z1TIhPzTOhQkxXghHFCb0tNriAIRt/yQw94MUdoeQWuT7TbMR792yPfJVy+3w
         dSTNRotG4ld6i8AvCqYOoC4ZWkO/j29DY7HXTFuTvxGnIsNxj7wcmzQDNjFAtFtLmjbb
         xrXswyjdDcVfXtVp5HS1IdcRzK9tRYL67BMVIy9INqnC1F1it8OcixijJK8NXzuwQhTK
         iBvbNbACIbIspAyoOZaylS/SlxDS4bSr5LZ8neyfdPhW+gVX2mHfD41Okq8uGEQaYrW1
         yfpg==
X-Gm-Message-State: AJcUukdePnzhzTFPyMtCGznH4GoaCheNhAdMt8JSPW48TuR3vkNIbA6d
        EDTyTMU5fxQGzucC1VH3qPzh0P+z
X-Google-Smtp-Source: ALg8bN7XBH47d57iXYQ/S88Fvq0CNTQVfGB/IvzBdxZ8TzSdLgW0HZkOEtX539CaBDCD6076GQVdaA==
X-Received: by 2002:aca:720a:: with SMTP id p10mr8218016oic.169.1548171878586;
        Tue, 22 Jan 2019 07:44:38 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id c132sm7535850oia.41.2019.01.22.07.44.37
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 07:44:38 -0800 (PST)
Subject: Re: [PATCH] realtek: no need to check return value of debugfs_create
 functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
References: <20190122152151.16139-34-gregkh@linuxfoundation.org>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c09a1fb9-45e4-c21e-3c19-09ba94ebd859@lwfinger.net>
Date:   Tue, 22 Jan 2019 09:44:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190122152151.16139-34-gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/22/19 9:21 AM, Greg Kroah-Hartman wrote:
> When calling debugfs functions, there is no need to ever check the
> return value.  The function can work or not, but the code logic should
> never do something different based on this.
> 
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Greg,

Please change the subject to read "rtlwifi: ...". Otherwise the patch is correct.

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry
