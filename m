Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A8B2C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC70720827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 22:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fSnZwkKN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC70720827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbeKFHdP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 02:33:15 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:41590 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388164AbeKFHdO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 02:33:14 -0500
Received: by mail-yw1-f68.google.com with SMTP id c126-v6so4333055ywd.8
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 14:11:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=PVkQJ7bRZnyVIMQEUBvriExwRvWhaBGDBiRP1kIbRWU=;
        b=fSnZwkKNFo5dWDeg60b9aQFuAIeVSnErnxzpikk2EdhuaOHWAlMExlIY/4opcwmXr7
         0Ae2MlAXJGsnM5Q64yDcR+JoaZPAIJeUhclgPApHPgHdg/Eogc6r4Wq16UbhaIAJ2/ks
         /n60S2rG8r5IMgEjfOnTOC5+HEIngTZNRQGxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=PVkQJ7bRZnyVIMQEUBvriExwRvWhaBGDBiRP1kIbRWU=;
        b=QA+Hc/EcQFXrjJFC6z/h1oNHzeMlLMwiUZ8ylu/01hBM4aPw6yGrr/PI4v7K7NwrUc
         vHM5GuuBNW8yTz7T002SdE5nTQqIIvPW/D/FAFHViozhPpXKYbfuaw+hsy/eFIvJMHa5
         AcVjVx0WqJx+59gkhm3RSKHJ+bVGz2i7eETaf5hOgTXsDKEEUpPkaT2R/igny7vq3p87
         d/NSVVtE85tkcl719X8Buvh2qh/XkKuFLXGKryxZ+1M+oj1sEC3q6/F3/wmwvcFgh9kU
         +DnIiS4vSsrjKKy/WRWDXvgz9igLBXJqOVmBCmvWEROxmeYbsSnQKkiFJ39D54ylS9T7
         J6wQ==
X-Gm-Message-State: AGRZ1gLPl4mSsf88pY+kiUyv1bbJ4foMrubFaQUniXoxpSIGRxEBFeSP
        QE9eB169QWSdX9lvnau1LvtdHQ==
X-Google-Smtp-Source: AJdET5f13bXhP2KjuZ14j5OQiTPQAeGxBVJKrH6QXhXOnQY8h/fs5z6Jpo4LaF2w9twNRyEcNUsdRg==
X-Received: by 2002:a81:3b55:: with SMTP id i82-v6mr6527426ywa.397.1541455882433;
        Mon, 05 Nov 2018 14:11:22 -0800 (PST)
Received: from [10.177.251.60] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id u134-v6sm6479480ywf.86.2018.11.05.14.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 14:11:21 -0800 (PST)
Subject: Re: [PATCH v2 3/3] b43: Use cordic algorithm from kernel library
To:     =?UTF-8?Q?Michael_B=c3=bcsch?= <m@bues.ch>,
        Priit Laes <plaes@plaes.org>
References: <cover.9ec98292c595a111ae78f31383ff8618c9cb04da.1541446422.git-series.plaes@plaes.org>
 <77709642dacd9d855618bd9c2f3a56a88e881eaa.1541446422.git-series.plaes@plaes.org>
 <20181105223909.61860cdd@wiggum>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>, b43-dev@lists.infradead.org
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1b536f41-6bda-712b-cd57-0034f924992a@broadcom.com>
Date:   Mon, 5 Nov 2018 23:11:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181105223909.61860cdd@wiggum>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/2018 10:39 PM, Michael Büsch wrote:
> On Mon,  5 Nov 2018 21:37:18 +0200
> Priit Laes <plaes@plaes.org> wrote:
>
>> Kernel library has a common cordic algorithm which is identical
>> to internally implementatd one, so use it and drop the duplicate
>> implementation.
>>
>> Signed-off-by: Priit Laes <plaes@plaes.org>
>
>
> This looks nice.
> But what is the testing status of this?
> Has this been tested on actual b43-LP hardware?
>
> Is the replacement algorithm exactly the same, or are there slight
> differences (e.g. in corner cases)?

Hi Michael,

I recall doing a comparison between the algorithms and thought I put 
that in the original commit message. However, it is not there. It is not 
exactly the same as in b43 so there are difference for certain angles, 
most results are the same however. This implementation is slightly more 
accurate on the full scale.


