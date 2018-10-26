Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC17C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 11:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B3E9207DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 11:10:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PhCx7Avq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="crVCBDP7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4B3E9207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbeJZTrN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 15:47:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:54408 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeJZTrM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 15:47:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 66A2F60A33; Fri, 26 Oct 2018 11:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540552232;
        bh=eNA1ezzLTb365ihzr1MQ53srG3jRg4b2k7LlhvG4DIo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PhCx7AvqDh+/LLTApOGVgdfJ2aFHOKUEKJ0voU/Yp1b/rnwuZrXZ/YmlOzsPuwbU7
         RUjHy2jI88NHttxIa5NQLgrIa0eLeTeDRBgfhcfJEFk4QHy7WGlDZet5/gKAQgXJI3
         yyOhgOfXq6ieVmCeyq4eCu5sQMGBlxN1Tha8vfTM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D750E60A33;
        Fri, 26 Oct 2018 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540552231;
        bh=eNA1ezzLTb365ihzr1MQ53srG3jRg4b2k7LlhvG4DIo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=crVCBDP7cLSaHvfLj2l7fFnq8nbaIt3HZ0s84t/LzuS4TBWCKOvTnxg4WkQiCpXFm
         WBfIFi05464luPx3XYGdFUP0Pu60x+57KzR/AKilSGAZ1PChWCFt6Lt6R4tPYPXkfa
         Vd1aoq/BZEr1VOdP4P79n9hpHfgfpZKq/qoB6ZmM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org D750E60A33
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH 4.20 FIX] brcmutil: really fix decoding channel info for 160 MHz bandwidth
References: <20181026105039.11445-1-zajec5@gmail.com>
Date:   Fri, 26 Oct 2018 14:10:25 +0300
In-Reply-To: <20181026105039.11445-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Fri, 26 Oct 2018 12:50:39 +0200")
Message-ID: <875zxpgdzy.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
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

I'll queue this for 4.20.

--=20
Kalle Valo
