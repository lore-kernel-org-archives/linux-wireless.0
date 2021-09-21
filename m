Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87E0C433F5
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Sep 2021 05:56:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDBD961090
	for <linux-wireless@archiver.kernel.org>; Tue, 21 Sep 2021 05:56:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbhIUF5u (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 21 Sep 2021 01:57:50 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:62685 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhIUF5s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Sep 2021 01:57:48 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1632203779; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=5J+mY/GIZ6S+95pX2KeVLWJAtGrqksmvQfiqOpSBkMc=; b=lKiLMBQYxBqL+tq9ReHzk7N6hyL76kwfwMiXH5aChrw41aLmtwTeA4DCB7Rw8FV4w61ii4bM
 1Fia5Q7A+HsuyLwfmOW9JRs7CCueC4jEz+85zuIVGX7Dimtw3SgCWimhNW1pAKdCC7YkAd6T
 PaPzBAWm28DToiZEDUB82iw+NJo=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyI3YTAwOSIsICJsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmciLCAiYmU5ZTRhIl0=
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 614973f7648642cc1cf1db2c (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Tue, 21 Sep 2021 05:56:07
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BC0BDC4361A; Tue, 21 Sep 2021 05:56:07 +0000 (UTC)
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 67C9DC4360D;
        Tue, 21 Sep 2021 05:56:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 67C9DC4360D
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Len Baker <len.baker@gmx.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] brcmfmac: Replace zero-length array with flexible array member
References: <20210904092217.2848-1-len.baker@gmx.com>
        <20210912191536.GB146608@embeddedor> <87o88sy2gk.fsf@codeaurora.org>
Date:   Tue, 21 Sep 2021 08:55:59 +0300
In-Reply-To: <87o88sy2gk.fsf@codeaurora.org> (Kalle Valo's message of "Thu, 16
        Sep 2021 18:17:31 +0300")
Message-ID: <871r5iwjyo.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> "Gustavo A. R. Silva" <gustavoars@kernel.org> writes:
>
>> On Sat, Sep 04, 2021 at 11:22:17AM +0200, Len Baker wrote:
>>> There is a regular need in the kernel to provide a way to declare
>>> having a dynamically sized set of trailing elements in a structure.
>>> Kernel code should always use "flexible array members"[1] for these
>>> cases. The older style of one-element or zero-length arrays should
>>> no longer be used[2].
>>> 
>>> Also, make use of the struct_size() helper in devm_kzalloc().
>>> 
>>> [1] https://en.wikipedia.org/wiki/Flexible_array_member
>>> [2]
>>> https://www.kernel.org/doc/html/v5.14/process/deprecated.html#zero-length-and-one-element-arrays
>>> 
>>> Signed-off-by: Len Baker <len.baker@gmx.com>
>>
>> Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>
>> I'll take this in my -next tree. :)
>
> Why? It should go to wireless-drivers-next.

Gustavo, so have you dropped this from your tree now? I do not want to
get any conflicts because of this.

I'll reiterate again: do not take any patches touching
drivers/net/wireless unless I have acked them.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
