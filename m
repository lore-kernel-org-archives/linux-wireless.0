Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DC49C282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BC312184D
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:21:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PpyBqisY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbfA3QVu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:21:50 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:46901 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfA3QVu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:21:50 -0500
Received: by mail-ot1-f66.google.com with SMTP id w25so36388otm.13
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2019 08:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HwSNKIJOw/zyUNgpQKMfIooP90dFkgYu2x/mnmwq824=;
        b=PpyBqisYJKvWc73RMh9AfitQQitXV06gI+slnLzT69qZ/zL7HYvZiGjyOwO0v1Uq98
         EcmZRizfnQm2yCYyHonYTNZ10PIDoTma98/o40qKlA9iQdwRnIuvaedqnOZkvEXmSjGR
         yXaGvJWMBD/LKfCXKVfEqCchwsNwfU1ieqHPrLsXlr85lAk/rM8n6Bn6QB+gnKEudmLb
         +xgF5q1J5SxN7KqtoukbmdU3OqsQm2VZY65Ei7hZzdRoCemus5lsSNyNf8IdH+gIifqj
         M77qUufcIu5XI9CY+QtJLaQjEtSRzNSyATB7uQ015DKs5fA8ygUxyOCvhE6dXLxqmuWL
         fasA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HwSNKIJOw/zyUNgpQKMfIooP90dFkgYu2x/mnmwq824=;
        b=g/g1xrH0OOaZ7+rYybnuTvy3uPFWt4sgOunen50bYgS5JNYFtdRLUmwJO29P4h627f
         vNcWacVZSrz1Uw098KdgKh925tvo8p28y3+YN7KkNXT3tm6cBgezF1iGHB6W6fJ0Iv9h
         xBL4fdbuITiTWnyl/KD6eYXG6wjy+DJ+1A5sMMlgNT9LwLqtfP54UXQljQhz1GWwSN4m
         +wMm599iAEhKB9AB/Uu4Vlij2HxztqdwdlNpranRXQMhbTSRBwFhyNfanx3G+D85wYU6
         Ow6EqWy/WAYkYzvw2qa4DN8StH+x99ACQxKLuqeHNxiPnp6uUTbQDqr5AfPcLlWxdATN
         FVzg==
X-Gm-Message-State: AJcUukcUTw1PiY9SvUjicr7OKNRAZvd2rP1UPsnCB5kjs5zVOBvHoJM5
        wfDd/GRwEqxNjQ3YLuK025V8Rqyh
X-Google-Smtp-Source: ALg8bN51qNpj34A5gqRrfKsKlCSC6xGqzVdT7GsferH0wMm6dIZ8VaN8yyKgAS72t9TZaeciAXlp7g==
X-Received: by 2002:a9d:4ac:: with SMTP id 41mr19255807otm.344.1548865309329;
        Wed, 30 Jan 2019 08:21:49 -0800 (PST)
Received: from [192.168.1.112] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id v1sm651618otq.80.2019.01.30.08.21.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 30 Jan 2019 08:21:48 -0800 (PST)
Subject: Re: [PATCH v4 01/13] rtw88: main files
To:     yhchuang@realtek.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net
Cc:     pkshih@realtek.com, tehuang@realtek.com, briannorris@chromium.org,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-2-git-send-email-yhchuang@realtek.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <143e9b9f-f8fb-aa45-8403-a498cfb7a5e9@lwfinger.net>
Date:   Wed, 30 Jan 2019 10:21:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1548820940-15237-2-git-send-email-yhchuang@realtek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/29/19 10:02 PM, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang<yhchuang@realtek.com>
> 
> main files for Realtek 802.11ac wireless network chips
> 
> Signed-off-by: Yan-Hsuan Chuang<yhchuang@realtek.com>
> ---

This patch is corrupted, and will not apply.

It should be OK to resend only this one.

Larry

