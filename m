Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D039CC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 22:07:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BB1A20818
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 22:07:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LFtT91CL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfDLWHx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 18:07:53 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:37000 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfDLWHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 18:07:53 -0400
Received: by mail-ot1-f67.google.com with SMTP id c16so9736297otn.4
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 15:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZLRMvPI1qcu2TaXg+Xjr+OShu3qK9PQZ6YKLZ5kaz8E=;
        b=LFtT91CLEZLFWnLeyM0POw3CU4QWwL57HqLCFJ11qRES3ejHPcE8xt8vu+62/sRVeb
         O8KPCLSaqDi9XqAlPCZv5fb3mRRinGA5Wr6FbOI34b5e2fJ3VqmpkrM48GYxuCKM+gh0
         caCXogPR5GMkMfxFkKI84mXu/8sLM/q0cpIB/VGsmrn5/CDT8bXCQ0BBnWSCW3O7cJDX
         pyv3oYfhwsxgtI1mx7BlCLPeSK6YsXP5qjbSIJ7iH8wuNXjq7uqQcG9Mzv0T0Z9W3/zv
         AC+S9BXnBbbJ2Xu5e/LEekgoA1Zqo6AncYwzKoWfUK+sBa3XqJb33F0LOa4FFu18JNLh
         Sl1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLRMvPI1qcu2TaXg+Xjr+OShu3qK9PQZ6YKLZ5kaz8E=;
        b=hiTPWWdlLedkRmhkCHmGHksHL6d53/fv3XdDtb8yIeSv5FbduNoFN+fE16HMSUhuzu
         wKrSJxSWViOumdg/PyrJU7JxT8Ibg1PjtoDOyGWkrYkAhzkc1nmDtkND+Vw5742PKTUf
         bShdd9UofN1i2w9l3sPYBPFJ7Io3cTSpLf1xc/3AfZnd3pLWPiXL0QvCOu5VhE7lwEE2
         0rjPKUaw7gNlB9D3MjPJfonh3xabg9BPE9zZceMooKZea7lYG+4+m3AmTFkhp6GC6Oqh
         Mi2nNSzxk/y3+FD4jqO8WCDU1Le2YsuFvMLdSSUqG1SWSJG/k3MpjPng8ygMPTIX0K+l
         UUew==
X-Gm-Message-State: APjAAAU6B36W2iix4yyNi1+WMWoVsJA2+ay2mXpWjnlP2M64RMDvPtOm
        ImDF9ztj5VhitbI3MritPQBCL90rWiXKcBhiINzVBFkv
X-Google-Smtp-Source: APXvYqxB3NrKOl6yl8MYu0vjhyduOymuaOYxZg49rv3nLSaEdhFaL3TxviTAg9YZ/O9wilpjIxCTJ4+yw51t6ovOxgA=
X-Received: by 2002:a05:6830:1692:: with SMTP id k18mr37281143otr.216.1555106872098;
 Fri, 12 Apr 2019 15:07:52 -0700 (PDT)
MIME-Version: 1.0
References: <1555105210-22996-1-git-send-email-greearb@candelatech.com>
 <1555105210-22996-2-git-send-email-greearb@candelatech.com>
 <CAOXD1ifE_rxU0fV6tXK2WpdOU2x9-b0J4cGsuqf3whi7YapBzA@mail.gmail.com> <ab7f61a1-0af6-a754-d9a0-388ebd0c8f15@candelatech.com>
In-Reply-To: <ab7f61a1-0af6-a754-d9a0-388ebd0c8f15@candelatech.com>
From:   Kirtika Ruchandani <kirtika@google.com>
Date:   Fri, 12 Apr 2019 15:07:40 -0700
Message-ID: <CAOXD1icnusnOZ0b0n6eTD6PRoEcf_tHVgivmCEPM1KsWu1uEng@mail.gmail.com>
Subject: Re: [PATCH 2/2] iw: Print current time in station info dump
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Tina Ruchandani <ruchandani.tina@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 12, 2019 at 2:49 PM Ben Greear <greearb@candelatech.com> wrote:
>
> On 4/12/19 2:43 PM, Kirtika Ruchandani wrote:
> > On Fri, Apr 12, 2019 at 2:40 PM <greearb@candelatech.com> wrote:
> >>
> >> From: Ben Greear <greearb@candelatech.com>
> >>
> >> This lets us more precisely calculate the absolute timestamp
> >> of last-rix (ie, now - idle).
> >
> > Can you use 64-bit timestamps? struct timeval suffers from the
> > overflow after 2038 problem.
>
> What is the preferred API to do this?  Whatever it is, it would need
> to compile on old crufty systems as well.

I am not sure what the guidance for userspace is. The kernel uses
'struct timespec64' I think.
Arnd (cc-ed) who has mostly led the 2038 problem in the kernel might
have more input on the
"old crufty systems" part.


>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
