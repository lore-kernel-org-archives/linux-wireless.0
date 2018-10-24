Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA95C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:39:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13D08204FD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 07:39:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nrB9XMYI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13D08204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbeJXQF6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 12:05:58 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:39358 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728442AbeJXQF5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 12:05:57 -0400
Received: by mail-lf1-f65.google.com with SMTP id p11-v6so3164269lfc.6
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 00:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=GkoSdEv4GCFVToMEcnWqnbzhSlo5v+SnRtwOQPG9EY8=;
        b=nrB9XMYI2A2DPnjBDaeE7rku2nqhOwA6Cv5MtJ+4pWkXYN4LZjEjQhHiSC3O3kf7Sj
         XXd9Grcg/ajNBMVKNhIsv1ejo8ed1FmLxhAJ6On9XsErLmCZlm4DOrdXeH/BVPbEydCx
         vzsUT0hp/ME/zXgNwkn/vlJp0o99rDmOBbaa3y/tt1p3qmHRncxhTmf4+fLzbjHPMddJ
         Uq2qhNJyXLy+3hympLAPiQTH5hNKG0ECcMqbqqg2QXgv+oa2ZB9n2uJcIaNDjdSZsEKa
         diTtJ3m09XC1U8tCudY9kQy69uNEfAi0mZVvA2YoWSnwXztxLaiCa/CPMbqic0NbpRMe
         O1qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=GkoSdEv4GCFVToMEcnWqnbzhSlo5v+SnRtwOQPG9EY8=;
        b=hgZig33waFmPPP7348HzRqbC+OR97MVf9Oom6HodSTAJaR4kbv3iipdrMnvXvLXQFI
         VkJopX4PxAswVdhhPHZ8Il31UkSrR2w3rgobS0ODyHqcmrmnZsMstK8lEHSDtacoIxF8
         cb9GbjAx5OVf5w4H+AGXF/6GQTssr/FnGC74/2HLrT/APEk+BU2IsIQx9A9O6I4X+MzI
         2XC1axsmBava6Ryj4tbW5+KIUqhQch7pvArm7/3/rBqNPe3fz55fGgbGmijA0ZaseAfU
         JxZpVxo4H343eRteiOOY5vbLlXhlUoXZa5wRy95mK1d0jUY6lUkhJ3S0hMtPrQdscz83
         gwwQ==
X-Gm-Message-State: AGRZ1gLdUNCXM1aWGteJ5P1xnX+D3lT+631q4ljCKmaSBet3Osr8zBWk
        XC8/wUgIRAQq6R5PitlJwKucP5hM8CaYEIqY9Aezn5DSyKo=
X-Google-Smtp-Source: AJdET5dZGQtDxvmMV2dJM1BiOpeqaDIrgTls9/dH4+2lYSiut2mHSR7g4UGcfBoVnRGQ5kFtHjOssfkhXkGR5WBmDW0=
X-Received: by 2002:a19:d78c:: with SMTP id q12mr2335063lfi.27.1540366740509;
 Wed, 24 Oct 2018 00:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <20181024070436.4466-1-johannes@sipsolutions.net>
 <CA+icZUW=jiTs9GPu-OgNnF1vaj=bHy88b5Qm3NnhkyKVdPqeLA@mail.gmail.com> <22674c9e06c5ebe6eef92c8aa9b7fef904208497.camel@sipsolutions.net>
In-Reply-To: <22674c9e06c5ebe6eef92c8aa9b7fef904208497.camel@sipsolutions.net>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 24 Oct 2018 09:38:49 +0200
Message-ID: <CA+icZUVnM1u2Dy_okYBFZvx8VBdMLx5T41Zbcm-DTOYsn+A8eg@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, joonwpark81@gmail.com,
        sgruszka@redhat.com, luto@amacapital.net, rajatja@google.com,
        kirtika@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 9:36 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2018-10-24 at 09:33 +0200, Sedat Dilek wrote:
> >
> > > Align the licenses with their permission to clean up and to
> > > make it all identical.
> > >
> >
> > Does it make sense to put the BSD license (text) in a separate file
> > (like GPL) and reference it?
>
> I agree that it would, and in fact we already have it available to
> reference with the SPDX in the LICENSES directory.
>
> However, no files of the iwlwifi driver currently do that, and I'd
> prefer doing that sort of cleanup more generally as a separate step.
>

Sounds good to me.

- Sedat -
