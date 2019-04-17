Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421DAC282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 14:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F31720872
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 14:15:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="no+Mhss/";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="L5FY7w4c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbfDQOPr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 10:15:47 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55706 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731743AbfDQOPq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 10:15:46 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1984F60712; Wed, 17 Apr 2019 14:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555510545;
        bh=tqY4NFkgCKC+FgcHHXXVp6JzILZm0CF5/WkCbF/Ykzw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=no+Mhss/2l3tESJVVJAg0oRF0a0yyX1jGofs6pdnsEFekgygb0Yrh49IwjvwKUb5B
         qOZ+7S6EX0CNxVa+KO7vQynjAIBgfLE+8CEBcAsOEOIz+LrnSxfXRPT/4WQHiHdRCe
         XrapN7CZzyT5elD7YsOfKtjaa/B24bTuZjYY6vsI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E67D660779;
        Wed, 17 Apr 2019 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555510539;
        bh=tqY4NFkgCKC+FgcHHXXVp6JzILZm0CF5/WkCbF/Ykzw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=L5FY7w4czKtMUCzjuw4B3ldM3TnSy9bpYHQS0a0biBH8jlJd7CInqz3HCTfdPo4jF
         k8mejzHsr1k5cXrADaJHFg5brpvSMb8Pv8zwUYu1Bf9PLrnP/W+1KyB4QWrEIuUWyY
         ybMwmqJTDmjUgKg6FSBwbYaJy0IEHaHB/beEUomA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E67D660779
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] rtlwifi: rtl8188ee: Remove extraneous file
References: <20190417003547.26271-1-Larry.Finger@lwfinger.net>
        <87tvex49yj.fsf@kamboji.qca.qualcomm.com>
        <d393389d-f3f0-491e-c83b-50065f388d75@lwfinger.net>
Date:   Wed, 17 Apr 2019 17:15:34 +0300
In-Reply-To: <d393389d-f3f0-491e-c83b-50065f388d75@lwfinger.net> (Larry
        Finger's message of "Wed, 17 Apr 2019 07:37:52 -0500")
Message-ID: <87ef604t15.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 4/16/19 9:55 PM, Kalle Valo wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>
>>> Somehow file drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej was
>>> incorporated into the sources. Obviously, it can be removed.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> Reported-by: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> ---
>>> Andrew,
>>>
>>> Thanks.
>>>
>>> Larry
>>> ---
>>>   drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej | 10 ----------
>>>   1 file changed, 10 deletions(-)
>>>   delete mode 100644 drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>> b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>> deleted file mode 100644
>>> index aa03d4605d8c..000000000000
>>> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>>> +++ /dev/null
>>
>> What tree is this? On wireless-drivers I can't find this file:
>>
>> $ ls drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej
>> /bin/ls: cannot access
>> 'drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c.rej': No such
>> file or directory
>> $
>>
>> Actually I cannot find any .rej files:
>>
>> $ find -name '*.rej'
>> $
>>
>
> It is in wireless-drivers-next. This extraneous file was added in
> commit 05f1be9594d5 ("rtlwifi: Convert the wake_match variable to
> local").

Ah, now I see it. But I think the commit adding was:

ddab2eee7949 rtlwifi: Convert the wake_match variable to local

I'll queue this for w-d-next.

-- 
Kalle Valo
