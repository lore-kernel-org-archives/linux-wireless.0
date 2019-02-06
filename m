Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12B8DC169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2DC82073D
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 12:15:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZBtJDjqK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KcXS7iuW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729616AbfBFMPD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 07:15:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbfBFMPC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 07:15:02 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BB958609F2; Wed,  6 Feb 2019 12:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455301;
        bh=E1mJT0H/peLgM5gAGXotXox7rhxREsvUtuNzQCR2hdo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ZBtJDjqKM0jyD5ABMyr0ZEbJKCtM2bYNlyGcclFOi4SKwL+QXkHq1rrVSxGscSGwb
         TLQmL3NqztwBswpy9l0P9sAbvbpdl3QrD7shfWkKR+sWTfutjveabu+2MBi6IB2hs4
         2bHL0sqB3rEeqx2T1QdUK7K6ejNzlm5oGgRMbr+E=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DCB7E6090B;
        Wed,  6 Feb 2019 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549455300;
        bh=E1mJT0H/peLgM5gAGXotXox7rhxREsvUtuNzQCR2hdo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KcXS7iuWE1il4aahvVP9GeNKBW9IkCMUAkgJkQXXbBJGiTNdhQV428HbmUf5v/teB
         mzUIk0Mdi7zstJdgoGnsRAwheu9yWX4FCGyUV5LzHREuzhgue8fR5I1tUMRsyIce8n
         /l0CJkN6TuEX7XJoNglU4oBKb8DmBRT03PalnTbA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org DCB7E6090B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal.milecki@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V3 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
References: <20190206112816.563-1-zajec5@gmail.com>
Date:   Wed, 06 Feb 2019 14:14:56 +0200
In-Reply-To: <20190206112816.563-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Wed, 6 Feb 2019 12:28:15 +0100")
Message-ID: <87bm3pru4f.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

"Rafa=C5=82 Mi=C5=82ecki" <rafal.milecki@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> So far __brcmf_err() was using pr_err() which didn't allow identifying
> device that was affected by an error. It's crucial for systems with more
> than 1 device supported by brcmfmac (a common case for home routers).
>
> This change allows passing struct brcmf_bus to the __brcmf_err(). That
> struct has been agreed to be the most common one. It allows accessing
> struct device easily & using dev_err() printing helper.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
> V2: Add missing #include <linux/device.h>
> V3: Add #include "bus.h" to fix CONFIG_BRCM_TRACING=3Dy compilation error:
>     error: dereferencing pointer to incomplete type 'struct brcmf_bus'

Thanks, this compiles for me now. I also pushed this to w-d-next pending
branch to get more build coverage from kbuild bot.

--=20
Kalle Valo
