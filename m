Return-Path: <SRS0=/oVT=PK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D38C43444
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 15:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82A69218CD
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Jan 2019 15:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SIVntgj3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbfABPai (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Jan 2019 10:30:38 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40363 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729886AbfABPai (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Jan 2019 10:30:38 -0500
Received: by mail-pl1-f196.google.com with SMTP id u18so14633275plq.7
        for <linux-wireless@vger.kernel.org>; Wed, 02 Jan 2019 07:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aotKXRgI5ukT4+MDFSiCmLWgKTQf+3ZKVeVttVdQs8k=;
        b=SIVntgj3pdOMeja7HJx9uNiQTutdLM/R47mNTw1lTZUKmMS1kSm7Bs7x+jZhFx12R3
         TMDVtgiZ7SkkQ5329dpqWppFkx1VlgyFOD6vAScU2kdH1gUJkWBb4EU/2+rR/bwU9iF6
         Uw5MoGvcp10PgtMJMrupsPV1Z7ZlyxZ0z38v55yw1Co47aPv1DOHkrYTNrGvVDSK/uUy
         0w2FGOFEqyH0D5xHD4GmzIv7yJ/wtKE/O9jbAg3sXUbJkv7GDIZca61B230BXpEiX3B1
         BzIa/TWlzMEXDrG04Y+pnr2czcRzhtyozPQPAF0syd2UgqWqulkfYX4RwRPY+DnVdlVa
         HxSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aotKXRgI5ukT4+MDFSiCmLWgKTQf+3ZKVeVttVdQs8k=;
        b=IXCeRo/hSuul0U/20pGS+MaqrN24jx/cg3gJmTW4vmHB+Uho2TmbG0+OQWWkYQvCGd
         yaOS0wDjumEpK9JYfqupQy0c+AEYmq7PBMl1dqPxkfGkvscFftH7hxKnrqy5whf659Jx
         tLVQ2/ubSDbjtZHBM5TLVVzvwy9wqeb4pw1UZ1P67A8agRrKeatg8GKfG6ERignrC4Ib
         msmRQpOw6BYPYEWoXaODoLQIJxVcND4ezOyHmPoJSwcUhHDbCjXXqnOz9+0XhPUiccOw
         JtI/DQ/qIA+1tC3Z6sP+sSEwypSf5+iV4GC5VYZ0AglnrqaJfUZKwc4X7JQ4SooRNOrR
         CZ+Q==
X-Gm-Message-State: AJcUukf0qKCijsjkVQHCvvx7bE0nmpVoXNFB0nfL1cjRWwJrcxm7Xgp6
        OWLIMPgAk7VrRgBj4p/ytNxEGq3w1C9RrmylFGYZBuR6d+M=
X-Google-Smtp-Source: ALg8bN4eWtyV/c9h4bUe0I8Ah5BznJgnzedri0hDWjIkPmPVfFreq4xkm00CDpi30Y6ReuER6Azk08RcWRnH4QDYT7Y=
X-Received: by 2002:a17:902:a58a:: with SMTP id az10mr44489200plb.10.1546443036861;
 Wed, 02 Jan 2019 07:30:36 -0800 (PST)
MIME-Version: 1.0
References: <75ce3040b4086ffa2d2e088ad7f24f5e4a87be56.1523552145.git.andreyknvl@google.com>
 <20180604042900.GB31498@zurbaran.ger.intel.com>
In-Reply-To: <20180604042900.GB31498@zurbaran.ger.intel.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 2 Jan 2019 16:30:25 +0100
Message-ID: <CAAeHK+yvf-LqrfdQ18FMzaCNqdNHqAjgrDMrwUReZq8ei=hTYQ@mail.gmail.com>
Subject: Re: [PATCH] NFC: fix attrs checks in netlink interface
To:     Samuel Ortiz <sameo@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jun 4, 2018 at 6:29 AM Samuel Ortiz <sameo@linux.intel.com> wrote:
>
> Hi Andrey,
>
> On Thu, Apr 12, 2018 at 06:56:56PM +0200, Andrey Konovalov wrote:
> > nfc_genl_deactivate_target() relies on the NFC_ATTR_TARGET_INDEX
> > attribute being present, but doesn't check whether it is actually
> > provided by the user. Same goes for nfc_genl_fw_download() and
> > NFC_ATTR_FIRMWARE_NAME.
> >
> > This patch adds appropriate checks.
> >
> > Found with syzkaller.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  net/nfc/netlink.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> Thanks, applied to nfc-next.

Hi Samuel,

It's been 6 months and this fix is still not in mainline. Did it get lost?

Thanks!

>
> Cheers,
> Samuel.
