Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55197C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 22B74217D7
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 19:06:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iiSz84I6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="K/mNl1s4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfBRTGh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:06:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51080 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbfBRTGh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 14:06:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 54E30607EF; Mon, 18 Feb 2019 19:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550516796;
        bh=esPdABJBpGSqp931ZQiOXnlVd6J4TnHzDy08pTMrC9A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=iiSz84I6xLMtcdAZ13csQWbp/x0QENs0bnepTQiwjCv83dGIjaV5qYaVriMWQBJhX
         q7Jjy1wcCr2tSnAcM6rOmN19+C85frrmyVX9+ERRVBcIylrtzbTa1Z+f1nT7cKe0rA
         1z3LGnC0BavSN0oZZshLsM9+JMO4vskdGijyI47k=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B4CB260740;
        Mon, 18 Feb 2019 19:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550516795;
        bh=esPdABJBpGSqp931ZQiOXnlVd6J4TnHzDy08pTMrC9A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=K/mNl1s4LJP6VfOQwStdcLZfeXVFuB8vMkIAyRaRXUEL2vmspI5JL6+Lwef9AjK6L
         4XZ83VCR+Y+aVqhi36Jc/X/yml7HrNs8eXD0zmwtGyQscJwG26FdVI0CgWIglMoHXd
         1vcdrH3sr5bA0AkaoFpouVqVpLlxdjs8dgjLMYHk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B4CB260740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-wireless@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, Felix Fietkau <nbd@nbd.name>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH 1/2] wireless: mt76: call hweight8() instead of __sw_hweight8()
References: <1550469571-25933-1-git-send-email-yamada.masahiro@socionext.com>
        <1550469571-25933-2-git-send-email-yamada.masahiro@socionext.com>
        <877edxt1f1.fsf@kamboji.qca.qualcomm.com>
Date:   Mon, 18 Feb 2019 21:06:29 +0200
In-Reply-To: <877edxt1f1.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 18 Feb 2019 20:08:18 +0200")
Message-ID: <87tvh0syq2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Masahiro Yamada <yamada.masahiro@socionext.com> writes:
>
>> __sw_hweight8() is just internal implementation.
>>
>> Drivers should use the common API, hweight8().
>>
>> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
>
> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>
>> This patch should go to x86 tree along with 2/2.
>>
>> Otherwise, all{yes,mod}config of x86 would be broken.
>>
>> This patch is trivial enough.
>> I want ACK from the net/wireless maintainer
>> so that this can go in via x86 tree.
>
> Sounds good to me, feel free to push via the x86 tree.

Actually, can you wait a bit? Felix just reminded me that we have a
similar patch pending from Ben Hutchings:

https://patchwork.kernel.org/patch/10808203/

And it seems there are two instances of __sw_hweight8, at least in my
wireless-drivers-next tree:

drivers/net/wireless/mediatek/mt76/mac80211.c:  int i, nstream = __sw_hweight8(dev->antenna_mask);
drivers/net/wireless/mediatek/mt76/mac80211.c:  int n_chains = __sw_hweight8(dev->antenna_mask);

So we need to think what to do.

-- 
Kalle Valo
