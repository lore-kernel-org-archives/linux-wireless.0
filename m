Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1417DC0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 10:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFEB920827
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 10:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HAasIuaV";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l9HU3nz9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFEB920827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbeKGTce (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Nov 2018 14:32:34 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34194 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbeKGTce (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Nov 2018 14:32:34 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0036B60591; Wed,  7 Nov 2018 10:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541584976;
        bh=aNf0CnptxyjMLxNf3ley7xT85S9DXtn01YOO00QIwNI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HAasIuaVJmr3rMi/513CJsGQcyF/MTzlNjI1UvZ4ytMNmBGI1dpxyIzI/dVhqfS4p
         Der3EOB+gjtPLkS+7tH4MLqZqpRpQ3+iJ1UIEgGRLeOg+P2C6+UbyLJA7+E+Qksn0+
         WSqVb2s3EnFyYF+QuEUUHtxun5W5LFWldP8rXpiU=
Received: from x230.qca.qualcomm.com (85-76-66-16-nat.elisa-mobile.fi [85.76.66.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 14A6660271;
        Wed,  7 Nov 2018 10:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541584975;
        bh=aNf0CnptxyjMLxNf3ley7xT85S9DXtn01YOO00QIwNI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=l9HU3nz9cS5zHuNDCnsa7i9dDEjFSTeJjRvI56T88EoFsUUS1tTO7CjKeUyC04nsz
         lvXL79P3snNjjvXQRCQ1PSvdOVdjqy1hYsRZ4qXWd5sGavt0g+EoqytbQ+EBG8SrBo
         M0/Hwt5wGsL7R7ZAILik/1m1rtBoAwIrUP5efGLo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 14A6660271
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Rip Route <riproute@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        David Miller <davem@davemloft.net>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        \<brcm80211-dev-list.pdl\@broadcom.com\>\," 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        \<brcm80211-dev-list.pdl\@broadcom.com\>\," 
        <brcm80211-dev-list@cypress.com>, Dan HAAB <dan.haab@luxul.com>
Subject: Re: [PATCH] brcmfmac: support STA info struct v7
References: <1539289141-13689-1-git-send-email-dan.haab@luxul.com>
        <CACna6rxJUxGLw1P7d4nCRocHxSs3nyxBvHzr4YaDH9ES+kg39g@mail.gmail.com>
Date:   Wed, 07 Nov 2018 12:02:48 +0200
In-Reply-To: <CACna6rxJUxGLw1P7d4nCRocHxSs3nyxBvHzr4YaDH9ES+kg39g@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Wed, 7 Nov 2018
 10:46:23 +0100")
Message-ID: <87r2fxciif.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On Thu, 11 Oct 2018 at 22:21, Dan Haab <riproute@gmail.com> wrote:
>> The newest firmwares provide STA info using v7 of the struct. As v7
>> isn't backward compatible, a union is needed.
>>
>> Even though brcmfmac does not use any of the new info it's important to
>> provide the proper struct buffer. Without this change new firmwares will
>> fallback to the very limited v3 instead of something in between such as
>> v4.
>>
>> Signed-off-by: Dan Haab <dan.haab@luxul.com>
>
> It's too bad Broadcom's existing struct has been changed instead of
> just being extended.
>
> The patch looks good to me though. I just wanted to share my opinion /
> ping due to patch being marked as "Deferred".
>
> Reviewed-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

Good that you brought this up, I wasn't sure what to do with it so I
marked as Deferred. Arend, please let me know what I should do.

--=20
Kalle Valo
