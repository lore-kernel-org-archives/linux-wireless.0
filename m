Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFE5CC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 11:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B77EA205C9
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 11:49:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WL+P570n";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PmS58J+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B77EA205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbeK2Wyy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 17:54:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726946AbeK2Wyy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 17:54:54 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9163760B26; Thu, 29 Nov 2018 11:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543492188;
        bh=9+Sr6CFnJy2+v/mYjThoN4202AN3/1AoRxP6uB1gVV4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WL+P570nzPgvXpcND6Oiuestu8gB3TkNAvxlD9Paddcfzwy5nAGgEv7KZV0EeT4Af
         tPPHG7DKt8x1uqvv+W9Xzrz0QdtvsWmduU10F+Xk3rZl8bkNF5PeGG0KvBIycVOMR+
         sQKvGr4WVTl7WMgCu5urZp80C3f8MGfcghR1pozA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A413860251;
        Thu, 29 Nov 2018 11:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543492187;
        bh=9+Sr6CFnJy2+v/mYjThoN4202AN3/1AoRxP6uB1gVV4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PmS58J+jLgrjDokKhTWo3T/ct1fUgl6SDui+97eDu3ceDsKd1Swg+sFeAsDEuAJ/L
         oyTiC5nSQdMmEOCdDhQvR3Js4KmQ4r6xv9dr+rFGrW/bL7aOCpWhbGbjXF67m0BTKP
         lQf6lk4O+ZvVtHYlOp4myXaDnYK7zRYpEVbGqmjc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A413860251
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?utf-8?Q?Rafa?= =?utf-8?Q?=C5=82_Mi=C5=82ecki?= 
        <rafal@milecki.pl>, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.19 06/68] brcmutil: really fix decoding channel info for 160 MHz bandwidth
References: <20181129055559.159228-1-sashal@kernel.org>
        <20181129055559.159228-6-sashal@kernel.org>
Date:   Thu, 29 Nov 2018 13:49:43 +0200
In-Reply-To: <20181129055559.159228-6-sashal@kernel.org> (Sasha Levin's
        message of "Thu, 29 Nov 2018 00:54:57 -0500")
Message-ID: <87y39c85ns.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sasha Levin <sashal@kernel.org> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> [ Upstream commit 3401d42c7ea2d064d15c66698ff8eb96553179ce ]
>
> Previous commit /adding/ support for 160 MHz chanspecs was incomplete.
> It didn't set bandwidth info and didn't extract control channel info. As
> the result it was also using uninitialized "sb" var.
>
> This change has been tested for two chanspecs found to be reported by
> some devices/firmwares:
> 1) 60/160 (0xee32)
>    Before: chnum:50 control_ch_num:36
>     After: chnum:50 control_ch_num:60
> 2) 120/160 (0xed72)
>    Before: chnum:114 control_ch_num:100
>     After: chnum:114 control_ch_num:120
>
> Fixes: 330994e8e8ec ("brcmfmac: fix for proper support of 160MHz bandwidt=
h")
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please mark your stable patches with:

X-Patchwork-Hint: ignore

This way patchwork ignores them and this saves my time. Thank you.

--=20
Kalle Valo
