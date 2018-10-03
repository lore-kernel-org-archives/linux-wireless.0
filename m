Return-Path: <SRS0=nRo4=MP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B26C2C00449
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:57:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56DED2089F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Oct 2018 16:57:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jGnDLwoD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 56DED2089F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbeJCXrJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Oct 2018 19:47:09 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:38991 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbeJCXrI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Oct 2018 19:47:08 -0400
Received: by mail-io1-f66.google.com with SMTP id z16-v6so5609443iol.6
        for <linux-wireless@vger.kernel.org>; Wed, 03 Oct 2018 09:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4VBHY0CbnyOfeaUKOFX6cs4HBFiwwsn2ahZMEC8Vas8=;
        b=jGnDLwoDd8UcuVaoIr0avA98f0Br43tOF5o2npnyzLb31vkGmDjZ6wvSTkUHORvjD3
         cTuFBNe/T3/NoIXZXn8uWkPCql6qPSE7Akx7DcskZh/Eh59zMdDXy7oWCTQ7XMZzGU6m
         nDtEtohOWC5HH0K70rftBiWcevp2GSymxt+ppLqNR4kx0LbBxWfi9illgSftIXHByEfz
         L48T4vd0lBzubTFJx3kiap91r/1eiZnw4O74Ls2ttxLovIfYTvdNg6qev5R+W2GNWY3l
         BI4DHKNITW1hUlg4/9Ffzm3fOzSNkP2FFVfZ6vPVhfMgwOl9CjNZYJ9ECN0RQEYgVuLZ
         yLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4VBHY0CbnyOfeaUKOFX6cs4HBFiwwsn2ahZMEC8Vas8=;
        b=W/zmTvfUUh2Qz0x1bHre3eS3l0b9exUL5SYwRTKWEm8jTZVs8oQUN7igP1XOyC8Noe
         pISid+HAyRfDSNIRMTl2bEnLlqx+uI2u0k3nXRuQShfjSfY29DLPDDsncrJ0co4RdPiQ
         KLKTaJ2LIT4MxabjRSxSQ6ZifEr+RuPEpFT+84T8qcALH/DbufbF9D9fEHz7Bf8fSc+R
         1VS1pClhCsloGJ+ly/LLLEeIuDkC4Ntl+gx9xKWbh0zTpgjbkGzYTs9YbhQvdeZCdRi9
         OEYkx3mOOp68eupms6Kagz/uqp25nw/ELIoNvKdp0h1yvKL4FM0opGrkwICXx2ccJZfP
         hIKw==
X-Gm-Message-State: ABuFfoikTIXoxO8G2hG9OVyzhiQ/JKj4U4ARIaQ4BFJugOs6OnABc9j5
        jnHk4phfktyi7ssC2W6idHJJdWG5nhfm2bk5LJs=
X-Google-Smtp-Source: ACcGV60lLuo3Z8uOE/fhwLOY/MLE5xClw6SI+5wpgUUISFd++KVjJ3pUXeT7PZrklYFESCdJQw9354/OyDWol5s9YjA=
X-Received: by 2002:a6b:6d06:: with SMTP id a6-v6mr1561157iod.27.1538585875096;
 Wed, 03 Oct 2018 09:57:55 -0700 (PDT)
MIME-Version: 1.0
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <CAM0KTbAkm+crgK98kus7N7fCZFA5w9aRJ=Fam+Qe5cv_t9x=DA@mail.gmail.com> <3aa94c69-9cdf-77e0-f7b6-d31b501beaee@lwfinger.net>
In-Reply-To: <3aa94c69-9cdf-77e0-f7b6-d31b501beaee@lwfinger.net>
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Wed, 3 Oct 2018 12:57:47 -0400
Message-ID: <CAM0KTbDE0sHXO2xdo91HuDnDx6Gc2jUfZBfYCie4yqrC7h690g@mail.gmail.com>
Subject: Re: [RFC v2 00/12] rtw88: mac80211 driver for Realtek 802.11ac
 wireless network chips
To:     Larry.Finger@lwfinger.net
Cc:     yhchuang@realtek.com, Kalle Valo <kvalo@codeaurora.org>,
        pkshih@realtek.com, tehuang@realtek.com, sgruszka@redhat.com,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 3, 2018 at 12:52 PM Larry Finger <Larry.Finger@lwfinger.net> wrote:
>
> On 10/3/18 11:15 AM, Sid Hayn wrote:
> > Is there a public repository where I can track development for this driver?
>
> For the moment, this is it. Once the driver is accepted into the
> wireless-drivers-next tree, I will create a new rtw88 branch in
> http://github.com/lwfinger.git with this driver to accomodate people that want

I think you lost part of that link.

Thanks,
Zero

> to use the driver with an older kernel.. At the moment, it is still in too much
> of a flux.
>
> Larry
>
>
