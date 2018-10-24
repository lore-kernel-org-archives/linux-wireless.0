Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931D5ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:40:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CB322075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:40:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="b5w1XA9/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CB322075D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbeJYDKA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 23:10:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbeJYDJ7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 23:09:59 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47C120833
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 18:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540406450;
        bh=w1cxDlU22GHKXs2IVgtP45JuItMAVYPpWjvJdjfKyzQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=b5w1XA9/y5JpdIc84GtVKCNE1T+nGHuQcDiXEyV4oka0XjpJ/wr7FlXYG+NhYnHRl
         yyrNCOFI/hWNBgvzaZpZMYLqTuOdHG20CFxNOy20qYu7htji6B4nBWHtxgnIIW7oLI
         tp/3ChY9bVVM3DVAAzrSiqpulaM/LjaGWIyYWL1s=
Received: by mail-wm1-f51.google.com with SMTP id y140-v6so225857wmd.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 11:40:49 -0700 (PDT)
X-Gm-Message-State: AGRZ1gKk9/hrki1X+DBgY/k1rbJsNU8oLfsN0nA881S2uhf0m7NJHF/6
        LbGk8agN43zWgMSTmyjltyK7Mi9gpj/X6yVAPMmV8g==
X-Google-Smtp-Source: AJdET5c2mXmkvdWFn9H9C6U7vgGJgcW0j1gR3GI8q5/TvmmrTn1E4Z5ff2t0PDn2V3VuhAoz+cRzzJLJ1yNZa7yhwkU=
X-Received: by 2002:a1c:1fcd:: with SMTP id f196-v6mr3897276wmf.19.1540406448251;
 Wed, 24 Oct 2018 11:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20181024070436.4466-1-johannes@sipsolutions.net>
In-Reply-To: <20181024070436.4466-1-johannes@sipsolutions.net>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 24 Oct 2018 11:40:36 -0700
X-Gmail-Original-Message-ID: <CALCETrXrU=ez0K+1Ubgw4txtpa0DfHeN2d8=n7kwm8_hnKWSxA@mail.gmail.com>
Message-ID: <CALCETrXrU=ez0K+1Ubgw4txtpa0DfHeN2d8=n7kwm8_hnKWSxA@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Wireless List <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>, joonwpark81@gmail.com,
        Stanislaw Gruszka <sgruszka@redhat.com>, rajatja@google.com,
        kirtika@chromium.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 12:05 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> From: Johannes Berg <johannes.berg@intel.com>
>
> These files have a long history of code changes, but analysing
> the remaining code leads to having only a few changes that are
> not already owned by Intel, notably from
>  - Andy Lutomirski <luto@amacapital.net>
>  - Joonwoo Park <joonwpark81@gmail.com>
>  - Kirtika Ruchandani <kirtika@chromium.org>
>  - Rajat Jain <rajatja@google.com>
>  - Stanislaw Gruszka <sgruszka@redhat.com>
> remaining in the code today.
>

Acked-by: Andy Lutomirski <luto@kernel.org>
