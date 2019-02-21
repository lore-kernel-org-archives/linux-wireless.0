Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1092C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:01:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77D0A2086A
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 08:01:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fnis2Jxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfBUIBR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 03:01:17 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:43976 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfBUIBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 03:01:17 -0500
Received: by mail-yb1-f196.google.com with SMTP id s76so10701331ybs.10
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 00:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RD0YUByLeT+Nxp/WH1oozLiSJDqtI1dIJdoS+4wy6f4=;
        b=fnis2JxumzMYbQ9fF+ka8gpTCASLVqNbeIa8/Gg43OJFUqOtpd+HMIYL43lF+bGP7u
         bEFQeDGh138ecL2BZAyclrFv8RVZKKf7VL9o4TCQPmYtul0acfm5kbzwANyQW5KtgNp7
         Tm9Ix8zCFVTMcN1Mu+42v6kRpePBtmJdlTnwB8uUx2tJz98QRVFBp1cfGqfO4P7Eg1Lv
         rkg8S6zIZHj3smxlssFRc4Rw0tUxXvTHyyiWJrQYEK8qTAYTsp2RbubC8Fwx7wHTk/0U
         SbyloLZgkcYQjh7GjiCBkLCrfyb6v9lO+HifF3Y5RTxUXOxgSwsedY++i4fYHSVhALet
         d4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RD0YUByLeT+Nxp/WH1oozLiSJDqtI1dIJdoS+4wy6f4=;
        b=mn/yFwosKyzy5I0+GIUpSl/734glvgYfMVatRhCiZx3zncQpkdoNkVAMRct353Wac4
         UEuMkaBYdn+7063iYUjOxbMqAw8IraNtFwnOQVl8VzCKsSfUckl7OH8wv6zyue95tLxe
         3EzanJNE70AtagowL8W/ztBb3b6GIoH8EG9U5DDlGeH7pNiWyTrT3xy2z2vdqJRXHk+/
         k9+zTkuGnhcGAMZeENcl347WQSB/dvaBOufju8N9w36rM9ikGWq2oo01E95HRfPGoyHo
         k0Dfy/2fSM5AjGrM63FccRS2q4ty1C+sAZYf5RGAXgMMxFxnc3B8vT7ZgZVX2DIz+uNw
         VnNQ==
X-Gm-Message-State: AHQUAuYDxoWtM6jJ3VuZB3EfgJqLxPhR+Ox2xtGMt7WTJiJCJkP8Nlgv
        rnxoBe7Gzqv5PRw3fkKeaXhErymQq9OtYjw7jw4=
X-Google-Smtp-Source: AHgI3IaVhoPC71MoH6P2t2PboZ8lbMDOxecbEpzw95azKSoKvKK+Gb8uclLNwHZ2NrC2V8I5xIJPYaH8l44/1xzQlgs=
X-Received: by 2002:a25:cb0b:: with SMTP id b11mr31188268ybg.375.1550736076688;
 Thu, 21 Feb 2019 00:01:16 -0800 (PST)
MIME-Version: 1.0
References: <20190220103047.8960-1-zajec5@gmail.com>
In-Reply-To: <20190220103047.8960-1-zajec5@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Thu, 21 Feb 2019 09:01:05 +0100
Message-ID: <CACna6rwwDN6svzWMGbxYXDp5CN8C=A=fV224QcfoLcACQQgLDA@mail.gmail.com>
Subject: Re: [PATCH wireless-drivers-next] brcmfmac: add basic validation of
 shared RAM address
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 20 Feb 2019 at 11:31, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> While experimenting with firmware loading I ended up in a state of
> firmware reporting shared RAM address 0x04000001. It was causing:
> [   94.448015] Unable to handle kernel paging request at virtual address =
cd680001
> due to reading out of the mapped memory.
>
> This patch adds some basic validation to avoid kernel crashes due to the
> unexpected firmware behavior.

For a reference for the further hackers. That has been caused by a
BCMA_CORE_SYS_MEM core on my BCM4366/4 not being up.
