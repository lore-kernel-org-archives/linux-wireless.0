Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A76DC67877
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 17:03:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314C621470
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 17:03:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r9WgSTcM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 314C621470
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbeJMAge (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 20:36:34 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52705 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeJMAge (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 20:36:34 -0400
Received: by mail-it1-f193.google.com with SMTP id 134-v6so19765244itz.2
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 10:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8aNT5b82KQycKJvO6BT4laOcW7CABi3f2jALYmf581I=;
        b=r9WgSTcMisLJhAvFDFPL7jSp+mUFJHRjpCmIU1S/o87OSyeBhzaxZM3YMx/9o12awq
         x9idaxSV7N+U29FS9kYH12ci18aTBIINgz9qV0uSMTJ26jNrZX3Gf45xXo4c6JmE27Uv
         A4u1JDemBOtl8tk9Mc/1piDTcClhX9AoB1cCl0vk9Z4MvnsZ9PV9OSvN1MVoKbqOUrBw
         RhrO3FpZP/QgWJFPowS5D2Oa6cXl1MinyBkBBGRer5DbuI+bvJ+fJIDIWeueoeAHKW4v
         Zg+5AESNXADH0coVyt7RUZ3NW+dRiVzVdYjA6afxvxxA5Lo9Xm89eru5+Dzdj8sIhFhS
         4W/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8aNT5b82KQycKJvO6BT4laOcW7CABi3f2jALYmf581I=;
        b=esq+1B/ho2xklQDLyJxiOmZ9bt0QrqIG0q9mPzldWf1U16AozQ/mICJgW7S/h9jt14
         ig8ewCf12QURx6COjRKhI6N0KQFq69+7nWug6pzIRs7mRmq0UFvY/z27QD+w6OY7Uy2C
         Ro6A4MamBB4MOORcypCCj/mqmXxIkkby0YmSC1lc1vRNDrbiTrIhVjOGudzb7TOjDVBO
         Co2IE/hAmmEz+fK63ZMU9XvFPbts2p8Fqv7+M2hh2X7f8CTLrbtUZoqnOrJJvSkmmMLL
         yX4KrX477LEzlrA8NKqPtRMbJ1i6ut+Yr3q0YxKTzHDrrs4v0BOk1Tcqr5ZJUWbBP7KB
         LbeA==
X-Gm-Message-State: ABuFfohD09dUr6CcMMTyJGpqH71vF6tcqT7HmtjNF7BS+We45vJgUDj6
        UGG7VoMj1fNOUGbNtS1I28kOrHyX/C28S7wvFGE=
X-Google-Smtp-Source: ACcGV63n43/z7c8sP6maiXXdCCoFdU70ITzKaOiL1Ki8yP7Eo2LEvW74YgqEzoYuzYuj77NmZLHPYI/eGQG5xgKDcD8=
X-Received: by 2002:a24:3d12:: with SMTP id n18-v6mr5061953itn.131.1539363788024;
 Fri, 12 Oct 2018 10:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <1539289141-13689-1-git-send-email-dan.haab@luxul.com> <cf6f8b8a-2638-7d32-d3b1-0fc21f74a0df@broadcom.com>
In-Reply-To: <cf6f8b8a-2638-7d32-d3b1-0fc21f74a0df@broadcom.com>
From:   Rip Route <riproute@gmail.com>
Date:   Fri, 12 Oct 2018 11:02:55 -0600
Message-ID: <CALZrXO=nwHnj0tqBwoZh=bVD_iETSvbBezE6wjMDQcUoJvTB0w@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: support STA info struct v7
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>, davem@davemloft.net,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Dan Haab <dan.haab@luxul.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 12, 2018 at 3:02 AM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> On 10/11/2018 10:19 PM, Dan Haab wrote:
> > The newest firmwares provide STA info using v7 of the struct. As v7
> > isn't backward compatible, a union is needed.
> >
> > Even though brcmfmac does not use any of the new info it's important to
> > provide the proper struct buffer. Without this change new firmwares will
> > fallback to the very limited v3 instead of something in between such as
> > v4.
>
> Hi Dan,
>
> I don't have a real problem with adding this v7 stuff, but it looks
> different from what I have here which has additional fields. For what
> new firmwares and more importantly what devices do you need this. I only
> know it is used for 43684, which we do not support with brcmfmac (yet).

Arend,

This is to be used with firmwares we generated from the SDK recommended
to me by by Broadcom, 7.14.170.34. These firmwares are used on these
Luxul devices: XWR-3150v2 and XAP-1610.

Cheers,
Dan
