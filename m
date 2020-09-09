Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F09AC2D0A8
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 17:12:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4663C21D93
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 17:12:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mm6CG7lz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731294AbgIIRMs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731174AbgIIRMK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 13:12:10 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB402C061573
        for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2020 10:12:08 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k15so3758929wrn.10
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2020 10:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Rx250Or8XH4TqTzAPwSVuKMV9ObIQiINN7hpUwQB9JU=;
        b=mm6CG7lz6duP1I3U2LZ1xIwTCg5ljPlWYG21zjAImoVMymxVgP38XqhtfmvH8SuJq7
         en5cROIqLttJOcP+KFbDT0UAgdvqKhxa3sibkqP9sUSLh7mHkyAlFfL7w6QkD7iiPQ9t
         GIPL9TiGiyldKQKshyNAsFGmGdyVSIyNFeavLfhmZCblZMS+MeSrnrXvqc/LSsZILl01
         eBWIlenZgl/N3wAq5hpdjwb92ipKY1XEJVdkoSgoq73qrAkGkYChDjnMays3PoQ2UVh6
         988/xaQ092RiIzYL3ZRNQXMeFUYvPLF+6lKf1bkTzCNk7oeBSeXeYnR8KqfM39f2puW8
         mfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Rx250Or8XH4TqTzAPwSVuKMV9ObIQiINN7hpUwQB9JU=;
        b=r2t0nao0q41HbexR947h1dtq3CJF18gZoyE5SsTDKDWiUax/jF39VPHS1M+H4L5eKd
         wl3S5/wyw1R0WpBOCYqRv/ZObD3gnsm5Nb8cwc/esqdrv1zr9zr7eUHfx9uPbxr4XyRR
         HZEc5/LCGUq/upYlcXnXHeS/Vxgc2s9O2qU/LRAnUFtdcB6o7wB6jYLUBnDS+5jJg222
         SNUoBZHbsoK8+k+ItedVFcIyOWJ+xY3olpEFgeHSiodw3SHzh9LIG2g0w42QOdhQV5fW
         K1e3zdah3b3913vGaapJoJ/YGIlMQ6+QHi4kEMJ/Wf/0+rs+xHLgVXkMyFhi5xdRQOGU
         /+Kg==
X-Gm-Message-State: AOAM533lMefKVxU26ufNzwtbjeUBqO5zraOIPVrx1WBmTw/Uh2pJHLTn
        YsHE/EloYiEoBlQwm77t94wtLw==
X-Google-Smtp-Source: ABdhPJxNhddTBajEiZTWdNNJNXl7ABH66Xo9+2gAUJa96PQ3+8Ug9Cn1nJzDDaVY/EDT5se/3Hk3xg==
X-Received: by 2002:adf:fa0c:: with SMTP id m12mr4758548wrr.406.1599671527665;
        Wed, 09 Sep 2020 10:12:07 -0700 (PDT)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id d190sm4886138wmd.23.2020.09.09.10.12.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 10:12:07 -0700 (PDT)
Subject: Re: [PATCH v4 0/4] wcn36xx: Enable VHT when supported
To:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc:     shawn.guo@linaro.org, loic.poulain@linaro.org
References: <20200909153736.2905114-1-bryan.odonoghue@linaro.org>
 <01601cdf-66a6-6362-3710-93cc02ba1c89@nexus-software.ie>
From:   Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Message-ID: <52844def-a164-d8bf-428e-f54f9c44de7c@linaro.org>
Date:   Wed, 9 Sep 2020 18:12:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <01601cdf-66a6-6362-3710-93cc02ba1c89@nexus-software.ie>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/09/2020 18:04, Bryan O'Donoghue wrote:
> On 09/09/2020 16:37, Bryan O'Donoghue wrote:
>> This series is six in a set of seven to add support for wcn3680 at 
>> 802.11ac
>> data-rates.
>>
>> These two commits have been moved later in the set of commits so that the
>> patches to enable advertisement of VHT capabilities happen after all 
>> of the
>> supporting code has been comitted.
>>
> 
> No idea why the rest of the patches haven't turned up on the list
> 
> Made it to the wcn36xx list..
> 
> http://lists.infradead.org/pipermail/wcn36xx/2020-September/thread.html
> 
> I guess I will resend the series but, slower...

Oh, they just appeared *mad*

Never mind, all good.
