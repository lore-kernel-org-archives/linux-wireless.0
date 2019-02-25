Return-Path: <SRS0=l+aR=RA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C40C4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006002147C
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Feb 2019 10:59:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cJFWjMug";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CNDWvDTl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfBYK7e (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Feb 2019 05:59:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbfBYK7e (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Feb 2019 05:59:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 021CF60AA2; Mon, 25 Feb 2019 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551092373;
        bh=KgBonCZ/XB1zFvYiLWgupLInKbeVz/LdmIB3H1fviO4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cJFWjMug4t8fXUBlJr+NX1h4ap9/biyPOQFGIWeGdUqW9g38po/H/8SKRlp9Pak/R
         PHyG7PQQafKXFFSFXSEGzx3zu0gdq8MA9KQXjA33JEK2qMyaQVQyrZF++g7GNZ3Omd
         nNtcpgdBb+ZZA5q1CfIciY4AoGsnvMpU0eRvRczI=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CD8E0606CF;
        Mon, 25 Feb 2019 10:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551092370;
        bh=KgBonCZ/XB1zFvYiLWgupLInKbeVz/LdmIB3H1fviO4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=CNDWvDTlVGVjRUH9T/jqYR5cEKp4ecE7fSqAicEq2ou44/FkA/c+JCZPig2R0GIgt
         T5QfcItFnqh88pUWFJpP+ZsNwIseybqyoAZTqCdwG0JzqkqXbhoZNioYmEBxJkifm2
         V3Z8ZOZeIkzgr2kgoCtFVX77YFlL0knD0GBnTO+Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CD8E0606CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ath9k: remove set but not used variable 'acq'
References: <20190225033246.127410-1-yuehaibing@huawei.com>
        <87lg24urgq.fsf@toke.dk> <87ftscmbh7.fsf@kamboji.qca.qualcomm.com>
        <87imx8uor2.fsf@toke.dk>
Date:   Mon, 25 Feb 2019 12:59:26 +0200
In-Reply-To: <87imx8uor2.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Mon, 25 Feb 2019 11:49:21 +0100")
Message-ID: <877edom8vl.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>
>>> YueHaibing <yuehaibing@huawei.com> writes:
>>>
>>>> Fixes gcc '-Wunused-but-set-variable' warning:
>>>>
>>>> drivers/net/wireless/ath/ath9k/recv.c: In function 'ath_rx_count_airti=
me':
>>>> drivers/net/wireless/ath/ath9k/recv.c:1010:18: warning:
>>>>  variable 'acq' set but not used [-Wunused-but-set-variable]
>>>>
>>>> It's not used after 89cea7493a34 ("ath9k: Switch to mac80211 TXQ sched=
uling
>>>> and airtime APIs"). Also remove related variables.
>>>
>>> Ah, right, seems I forgot to clean that up. I wonder why I didn't get a
>>> compiler warning for it.
>>
>> I think the warning is not enabled by default and you need to use W=3D1
>> Makefile variable to enable it.
>
> Hmm, right, thanks! Guess I should get into the habit of compiling with
> warnings enabled before submitting patches :)

But you might get a lot of warnings and it could be difficult to find
new warnings from all the noise. In ath10k I just fixed all W=3D1 warnings
which I saw with gcc 8.1 and only now I was able to enable W=3D1 on my
build script.

--=20
Kalle Valo
