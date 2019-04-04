Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8285C10F0C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:40:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979B2206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 16:40:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="g8ut8LyD";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gV3uonkc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbfDDQkM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 12:40:12 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43294 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfDDQkM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 12:40:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1A96A60746; Thu,  4 Apr 2019 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554396011;
        bh=gGxqswoSC8eyw2H1E80LMaN0g64Olwvj3RMSqJJYLYQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=g8ut8LyDMbhIFK9oiU6YpFyZIXFGi+TiomvzGy+Tc9uGyWYoC9JxFdYoVJ+Yy9h7m
         JxFFlxNEOQl/cG/DNNl06Tr5rUKHp8STX/Sai6rWWHecYuK3LTGRVKaA2ijlNtdxND
         1kLHNb0VroZNYU5OME0l2gdNG0qiULjXkUnUTKiY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 4238560350;
        Thu,  4 Apr 2019 16:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554396010;
        bh=gGxqswoSC8eyw2H1E80LMaN0g64Olwvj3RMSqJJYLYQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gV3uonkcBikVeo1pPwwneFXwapnPVs8SaFW5+OSquWc+rju5CjnSW73hjei0UTEkH
         DhmL6vH/MG3rY2kP7dpQ4p2pbxWkpzxgdIrsEifHbdRLlZ0lXuG28iKFqL+sZhI/RQ
         MfyxskMDSnzcBMCeJozRCMqdu5nhaaBCx2IVwPxc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 4238560350
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] qtnfmac: replace qtnf_cmd_acl_data_size() with struct_size()
References: <20190403170236.GA31637@embeddedor>
        <20190404133234.2uatru2vlw3ntrmv@bars>
        <e56579c6-da6e-4cb2-90b1-89e7774debf9@embeddedor.com>
        <3baa19c1-a213-3dcf-2f03-23b058ec419a@embeddedor.com>
Date:   Thu, 04 Apr 2019 19:40:06 +0300
In-Reply-To: <3baa19c1-a213-3dcf-2f03-23b058ec419a@embeddedor.com> (Gustavo A.
        R. Silva's message of "Thu, 4 Apr 2019 11:33:56 -0500")
Message-ID: <87imvtsp09.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Gustavo A. R. Silva" <gustavo@embeddedor.com> writes:

> On 4/4/19 11:01 AM, Gustavo A. R. Silva wrote:
>> 
>> 
>> On 4/4/19 8:32 AM, Sergey Matyukevich wrote:
>>>> One of the more common cases of allocation size calculations is finding
>>>> the size of a structure that has a zero-sized array at the end, along
>>>> with memory for some number of elements for that array. For example:
>>>>
>>>> struct foo {
>>>>     int stuff;
>>>>     struct boo entry[];
>>>> };
>>>>
>>>> size = sizeof(struct foo) + count * sizeof(struct boo);
>>>> instance = kzalloc(size, GFP_KERNEL)
>>>>
>>>> Instead of leaving these open-coded and prone to type mistakes, we can
>>>> now use the new struct_size() helper:
>>>>
>>>> size = struct_size(instance, entry, count);
>>>>
>>>> or
>>>>
>>>> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL)
>>>>
>>>> Based on the above, replace qtnf_cmd_acl_data_size() with the
>>>> new struct_size() helper.
>>>>
>>>> This code was detected with the help of Coccinelle.
>>>>
>>>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>>>> ---
>>>>  drivers/net/wireless/quantenna/qtnfmac/commands.c | 15 ++++-----------
>>>>  1 file changed, 4 insertions(+), 11 deletions(-)
>>>
>>> Hi Gustavo,
>>>
>> 
>> Hey Sergey,
>> 
>>> Thanks for the patch! By the way, it does not apply cleanly, so it needs
>>> to be rebased on top of the up-to-date wireless-drivers-next tree. Let
>>> me know if you would prefer me to care about rebase. Then I will
>>> add this patch to the upcoming series of qtnfmac fixes.
>>>
>> 
>> Don't worry. I'll do it and send this again.
>> 
>
> Hmm... I just applied it cleanly on top of wireless-drivers-next/master:
>
> 973a99be7943 (HEAD) qtnfmac: replace qtnf_cmd_acl_data_size() with struct_size()
> 38bb0baea310 (wireless-drivers-next/master) rtlwifi: move spin_lock_bh
> to spin_lock in tasklet
> 60209d482b97 rtlwifi: fix potential NULL pointer dereference
> 765976285a8c rtlwifi: fix a potential NULL pointer dereference
>
> Do you see any issues with this?

Yeah, I also was able to apply it without problems. So it's in w-d-next
now :)

-- 
Kalle Valo
