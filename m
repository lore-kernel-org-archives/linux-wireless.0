Return-Path: <SRS0=3nVx=R2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F60C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 11:29:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A6852190A
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Mar 2019 11:29:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfCWL2z (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Mar 2019 07:28:55 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43062 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726801AbfCWL2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Mar 2019 07:28:55 -0400
Received: by mail-qt1-f193.google.com with SMTP id v32so5389589qtc.10;
        Sat, 23 Mar 2019 04:28:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=o05HuiFxIIEJr+jhYJZjwKCTTDpyKXuWYfcES1oSyT8=;
        b=Cur70ro+nbuvXGgP6zhAT5KsJL3GNQRo3RyWtPEjFmyNl78xv1BAbwvbbuoL0OEOHe
         Y4tYGuISkOZYmY4y12N0iALn4+szpRMLHUQOYXF1SAeuCAEqVrk0HvYdNPcdwy60/4C1
         X+ep97YH8rbcHaW0lOIN+jj3vpCDSfrXIt2c9EXPd1DkDpCjVuyjM8YNKsI2FTax6UWs
         PpSGboijTjIPTBw+Pfa8wkKbVdd97DCK1UJ7RVyT9fBcCZx9FuV0I9Psi1oj0qVShK0J
         +ic8QFQQgOclhR+9d7efRpejFBUyTiJaUV1ug8ozwA/43xNrL1UKn7IcXmljjX7vMX3/
         tXFA==
X-Gm-Message-State: APjAAAX40esfxGyeyZEYuaKoPTYtNQlMghE4wnjk3sylmtthMuIPjs9T
        HkiIFoYpVe0eigvCuh9UVjS5eNT3iog0fJV6q1g=
X-Google-Smtp-Source: APXvYqwP7x1WqW3HOkM8//lQvpbOAUarqW8YW1AwXe7BZZ2DzKu9l4lQxPz04tHdmqDFHtzMaonlAnr8AYE//60sq8Q=
X-Received: by 2002:a0c:af02:: with SMTP id i2mr11893489qvc.40.1553340534342;
 Sat, 23 Mar 2019 04:28:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190322141322.463149-1-arnd@arndb.de> <a92bc0994d5f3fa5da5da471d0ccd01f8cefeee5.camel@coelho.fi>
In-Reply-To: <a92bc0994d5f3fa5da5da471d0ccd01f8cefeee5.camel@coelho.fi>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 23 Mar 2019 12:28:36 +0100
Message-ID: <CAK8P3a0HuPU-UZgbZqVrthLAU7wzGSntQtk=7vzz+1BvLvVbDA@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: work around clang -Wuninitialized warning
To:     Luca Coelho <luca@coelho.fi>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 23, 2019 at 7:11 AM Luca Coelho <luca@coelho.fi> wrote:
>
> On Fri, 2019-03-22 at 15:13 +0100, Arnd Bergmann wrote:
> > Clang incorrectly warns about an uninitialized variable:
> >
> >
> > This cannot happen because the if/else if/else if block always
> > has one code path that is entered. However, we can simply
> > rearrange the code to let clang see this as well.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
>
> Thanks for the patch, Arnd! But I have already queued up an equivalent
> patch for v5.2 (should probably reach linux-next by the end of next
> week or so):
>
> https://patchwork.kernel.org/patch/10844025/

Thanks, and sorry for the duplicate. I forgot to check for the
patches that Nathan had already done when I started sending
out my own series on the same issues.

       Arnd
