Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AD5EB64D8
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jun 2023 05:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbjFNFVg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jun 2023 01:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbjFNFVf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2023 01:21:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E781A3
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2023 22:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A89636F6
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2023 05:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8CCC433C8;
        Wed, 14 Jun 2023 05:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686720092;
        bh=YFl7JkAlPByIvT7viYOGAQdr74o93Wn+L4fRDjxXg9k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VTW87qqUKlgWmBWoWzLvQlMCANscJ8CmWl/HSqkyr2lEQOtI75GjKmihADFF+cmOo
         6Bb2OnoDNivOVC00Z8KT+FD5j7wSEOZjC9FhhZMtrRyQZq0manej2+IayvNK5jmyS3
         TbOtDKRaBundF9J3E6H71fSccNlsjN+eW9u0+WQr4YHMNnKOI1Vp37ajsuaXbn8/zJ
         fiDh5M736+FRX20laOkdbEcQiuHrcUEwRyMCF9TN8877kfbqePizC2RVoZppfuKtit
         xG6JP/w+UAg9Z/WcAnDcCCxYGYkZMNoOMm2yodGQaibP9obXiPogBrqtnaybVxJjtt
         dyci2TS3ieNkA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] [v2] wifi: rtlwifi: simplify LED management
References: <20230608095051.116702-4-dmantipov@yandex.ru>
        <168664510862.24637.10587241603155144086.kvalo@kernel.org>
        <e030e496-b667-b1de-492b-8b0cc04ffe14@yandex.ru>
Date:   Wed, 14 Jun 2023 08:21:30 +0300
In-Reply-To: <e030e496-b667-b1de-492b-8b0cc04ffe14@yandex.ru> (Dmitry
        Antipov's message of "Tue, 13 Jun 2023 11:36:05 +0300")
Message-ID: <87h6rad3fp.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

> On 6/13/23 11:31, Kalle Valo wrote:
>
>> Is there a reason why you are changing error messages to debug messages like here:
>>
>> -		pr_err("switch case %#x not processed\n",
>> -		       pled->ledpin);
>> +		rtl_dbg(rtlpriv, COMP_ERR, DBG_LOUD,
>> +			"unknown LED pin %d\n", pin);
>
> Well, this sounds to be more problem-specific rather than
> generic "something unexpected in the switch statement".
>
>> The commit log mentions nothing about that.
>
> It seems I have to write more detailed commit message.
> Should I resend?

We prefer one logical change per patch, so it's better to remove all the
pr_err() conversions and resend as v3. And let's just drop the pr_err()
conversions, rtlwifi is an old driver and we want to keep changes to
that driver to the minimum. rtlw8xxxu, rtw88 and rtw89 are the active
Realtek drivers.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
