Return-Path: <SRS0=UyAc=W5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954D5C3A5A4
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Sep 2019 03:13:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6797B20656
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Sep 2019 03:13:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="oZ4KIPT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfIBDNl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 1 Sep 2019 23:13:41 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42284 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbfIBDNl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Sep 2019 23:13:41 -0400
Received: by mail-qt1-f195.google.com with SMTP id t12so14222249qtp.9
        for <linux-wireless@vger.kernel.org>; Sun, 01 Sep 2019 20:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28+/T/OSoe5xtTzXYJfwA8f5Dr5EAdXkZvx39Gcm3do=;
        b=oZ4KIPT6ygpwz/Kpa81scsD4zlNEt5xhNBTHj8ZrW8Bc5VYs/kwJkdw4SV1YZASFWF
         9CzU/IvmZVICWBHBR55dPrnFFZHhNLJGRKWFsSpwLradlMFnk3rb1hVifY5GUWKDrBK3
         dhgTPtdSFFs6CsbhlG8miEtN6dim9HDg6pKxLd+29ck4BenL08mX/x19TFEwuPvyYVCc
         g/9WZ2luvKvuHuOxOmJeoke/jcz45d87fH8L9j05pn2hIMhDA2O2lUGBRM+qdHoq/lqC
         yiVk5ZsPqKxeIrqltkKCy4KsmVJdhxN3dAIKC8G4PmVKd62u5/Uzuh2GsgwTgvsfzOi5
         O2HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28+/T/OSoe5xtTzXYJfwA8f5Dr5EAdXkZvx39Gcm3do=;
        b=khF6BTUV4zdU/FEkNGqaj1S8zdR2MzpDlXsUEcPssDxMFyHiZuK2rPLaP5QQUlM0sB
         i6/ZoCPGwaTspiX34lZme7Ek2+0h8gtitgQsGeoDQp47t1CpLfDVe2zQjc00/t37rq5S
         i8cAtTWiifHZ/Fx3hF1dXeyx0B6DTI5YRT+w1FQpZAfyc7gCjK7hmoTk+iO9wCjne73c
         LThkh2jp1o4e6G74Gs3jVP9RAsSsYFtRax2GPBWZchdk0ymleiMIYHKtQYXXYVtmnUS9
         WzMXK5c/hzWsp3gRMKPK6DkfhI8B5InLqTJ3AOPUNPqeM0922oivy6wUIDGC87mBhIBO
         gLgw==
X-Gm-Message-State: APjAAAXeZWWm0pk5Xr6NIhXrDcOrgvmDLArZoIXXZd/IZRroiJWkcKW2
        ulOlMeQjKiG5i3mlH7LtPmJefw0uX6mny5o2d5gVJA==
X-Google-Smtp-Source: APXvYqyVH6U0gxCfJa1EEVj8oYso/0tkvX3CFptxi0mbga9qQWi3387Vcmjb5/jUhHeQ2ZQ4zyi7JxSgpjjSprEs4Q0=
X-Received: by 2002:ac8:3389:: with SMTP id c9mr11098775qtb.391.1567394020247;
 Sun, 01 Sep 2019 20:13:40 -0700 (PDT)
MIME-Version: 1.0
References: <1565166487-22048-1-git-send-email-yhchuang@realtek.com>
 <20190823063728.14117-1-drake@endlessm.com> <CA+K+NcSYKEkdx5ux6iwUs7pMidObZBrg9yDcP1zT73DcccpDPQ@mail.gmail.com>
 <F7CD281DE3E379468C6D07993EA72F84D18AE7C8@RTITMBSVM04.realtek.com.tw>
 <CAD8Lp46=Adn3GWAkHspdqBHVjz6sekET9nzNOCnW7sCFGtoeDQ@mail.gmail.com> <F7CD281DE3E379468C6D07993EA72F84D18C1ABF@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D18C1ABF@RTITMBSVM04.realtek.com.tw>
From:   Daniel Drake <drake@endlessm.com>
Date:   Mon, 2 Sep 2019 11:13:28 +0800
Message-ID: <CAD8Lp46djFdVmifZn-CovgjFURAbbaeeBuc21hd1v0He071kUw@mail.gmail.com>
Subject: Re: [PATCH v2] rtw88: pci: enable MSI interrupt
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     =?UTF-8?B?SsOhbiBWZXNlbMO9?= <jano.vesely@gmail.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "gojun077@gmail.com" <gojun077@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Sep 2, 2019 at 11:02 AM Tony Chuang <yhchuang@realtek.com> wrote:
> Indeed it is a little strange but it works like that, if I don't disable HIMR,
> interrupt could be lost and never gets into interrupt handler again.
> If so, the interrupt will be stopped, and TX/RX path will be freezed.

OK, thanks for checking & explaining.

It's a bit hard to put in words as we have seen, but it would be good
if you could try to summarise this unusual design in the commit
message or in a code comment.

Thanks!
Daniel
