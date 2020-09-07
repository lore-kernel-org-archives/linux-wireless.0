Return-Path: <SRS0=d+R+=CQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732ABC43461
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 16:32:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B85F21532
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Sep 2020 16:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oWMY50Au";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="UQTtLpmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgIGQcY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Sep 2020 12:32:24 -0400
Received: from a27-18.smtp-out.us-west-2.amazonses.com ([54.240.27.18]:33858
        "EHLO a27-18.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729912AbgIGQcX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Sep 2020 12:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1599496342;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type;
        bh=ie/UW1q7qYJ7A4l1wEZedjb4fjgyJgYXxjxBmypAwX8=;
        b=oWMY50Auq9LvOD4CpwfSjzCuNKaCr+YMQZrnir40m3uVqfq/O004FAQrzUOnztcR
        2sVdVrja2EkpdesG3/FwPFsi0w9AnStxjbl+aniyT9ZGCaiQBMYOxQoHDsR5PW+U9h6
        EimUfz7yy55SqW5EqPkC338KJQFE5CFVIx+GZPus=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=hsbnp7p3ensaochzwyq5wwmceodymuwv; d=amazonses.com; t=1599496342;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:Message-ID:MIME-Version:Content-Type:Feedback-ID;
        bh=ie/UW1q7qYJ7A4l1wEZedjb4fjgyJgYXxjxBmypAwX8=;
        b=UQTtLpmFEEBiai2avOiuWb51RIbjT799Ld09K/lG0gzgSs2bK50b2qceOIB6U4Hc
        VfjONddx7DT76kkYznZbTy8xkUsDjp9/8Y6110pSQZyB/x0erK429gbPy5hYu7/vSlY
        gnxcOlrVqtgBT22AV6amiBbekwEC7IFQz6U3Mr74=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3B4B3C560F9
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     Allen Pais <allen.lkml@gmail.com>, chunkeey@googlemail.com,
        jirislaby@kernel.org, brcm80211-dev-list@cypress.com,
        pkshih@realtek.com, b43-dev@lists.infradead.org, dsd@gentoo.org,
        ath11k@lists.infradead.org, kune@deine-taler.de,
        mickflemm@gmail.com, Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, yhchuang@realtek.com,
        netdev@vger.kernel.org, helmut.schaa@googlemail.com,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        mcgrof@kernel.org, stas.yakovlev@gmail.com,
        Romain Perier <romain.perier@gmail.com>,
        Larry.Finger@lwfinger.net
Subject: Re: [PATCH 01/16] wireless: ath5k: convert tasklets to use new tasklet_setup() API
References: <20200817090637.26887-2-allen.cryptic@gmail.com>
        <20200827101540.6589BC433CB@smtp.codeaurora.org>
        <CAEogwTB=S6M6Xp4w5dd_W3b6Depmn6Gmu3RmAf96pRankoJQqg@mail.gmail.com>
Date:   Mon, 7 Sep 2020 16:32:22 +0000
In-Reply-To: <CAEogwTB=S6M6Xp4w5dd_W3b6Depmn6Gmu3RmAf96pRankoJQqg@mail.gmail.com>
        (Allen Pais's message of "Thu, 27 Aug 2020 16:14:45 +0530")
Message-ID: <0101017469694cc1-f6a00b6e-46ef-44be-b476-3aabf0fb4a55-000000@us-west-2.amazonses.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-SES-Outgoing: 2020.09.07-54.240.27.18
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Allen Pais <allen.cryptic@gmail.com> writes:

> Hi,
>>
>> Allen Pais <allen.cryptic@gmail.com> wrote:
>>
>> > In preparation for unconditionally passing the
>> > struct tasklet_struct pointer to all tasklet
>> > callbacks, switch to using the new tasklet_setup()
>> > and from_tasklet() to pass the tasklet pointer explicitly.
>> >
>> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
>> > Signed-off-by: Allen Pais <allen.lkml@gmail.com>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>
>> Patch applied to ath-next branch of ath.git, thanks.
>>
>> c068a9ec3c94 ath5k: convert tasklets to use new tasklet_setup() API
>>
>> --
>> https://patchwork.kernel.org/patch/11717393/
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
>
> Could you please drop these and wait for V2. A change was proposed
> for from_tasklet() api. The new API should be picked shortly. I will send out
> the updated version early next week.

Too late, I don't normally rebase my trees as it's just too much of a
hassle. Please don't submit patches which are not ready to be applied!

-- 
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
