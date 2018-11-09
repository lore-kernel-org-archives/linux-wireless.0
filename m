Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 507BFC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 14:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 177BE20825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 14:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c5UCdrrq";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KN6lTWjB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 177BE20825
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbeKIXqH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:46:07 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38768 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbeKIXqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:46:07 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 519A760B7F; Fri,  9 Nov 2018 14:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541772322;
        bh=+gfFJpkoRx1qITRmbfMuCBHczsOJv1Xw9ufzHovCnEw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=c5UCdrrq13RkH7YF8a7xRj/mi8fHRhsDdELSZQ0Cphkk9lNaEOeDSaY3S/IKhVBeZ
         2lUWw/WDV9ldU89g3P79qmi6Dcz5TpbcBHQhYLIueciYknmHhaexa9v2nWzhwtjpH8
         QabDJHIF7Fetv4LMsP70/71RdtqwMah4d+mTsNdc=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C25196038E;
        Fri,  9 Nov 2018 14:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541772321;
        bh=+gfFJpkoRx1qITRmbfMuCBHczsOJv1Xw9ufzHovCnEw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KN6lTWjB/s9Nld3cEAJbkAa8QjRQHzI6BR2RMN4A0ZD3l26CaBWxs7Xh82gR+tb4g
         XsQP9EPC+LYryItuPR9simpr7XNwGjBXO7NdxIwxnJFjqf3NiwE3iOsukPAkuoWrCT
         8tQ3RyuW5DeJrLQnSCd65u7hhDA8ODs5Vbd58GAQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C25196038E
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
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        stable@vger.kernel.org
Subject: Re: [PATCH FIX] brcmfmac: fix reporting support for 160 MHz channels
References: <20181108150829.24842-1-zajec5@gmail.com>
Date:   Fri, 09 Nov 2018 16:05:15 +0200
In-Reply-To: <20181108150829.24842-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Thu, 8 Nov 2018 16:08:29 +0100")
Message-ID: <87lg62cpno.fsf@codeaurora.org>
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
> Driver can report IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ so it's
> important to provide valid & complete info about supported bands for
> each channel. By default no support for 160 MHz should be assumed unless
> firmware reports it for a given channel later.
>
> This fixes info passed to the userspace. Without that change userspace
> could try to use invalid channel and fail to start an interface.
>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Cc: stable@vger.kernel.org

Should this be queued to 4.20?

--=20
Kalle Valo
