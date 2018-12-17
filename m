Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E23F8C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 18:14:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0F7320675
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 18:14:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MLC9Iqjj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732948AbeLQSOX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 13:14:23 -0500
Received: from mail-lf1-f54.google.com ([209.85.167.54]:46694 "EHLO
        mail-lf1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727627AbeLQSOW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 13:14:22 -0500
Received: by mail-lf1-f54.google.com with SMTP id f23so10145166lfc.13
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2018 10:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GaUoLhkKIwWgm60HYVt/7eOWxVccozlwVYo72qcHsgA=;
        b=MLC9IqjjdfFhEND6G9qVDZlSH+E2i7qSa2e1pv8wuAgomH0CWy6px3EIjMaf2IRq/h
         qgJXl5LGw+UJqJgO0T7GtzGQrp5o28DnzzmawrJsBt3UU+D73rYTGZQpEtY2ZbNsS7lO
         1r+ThvYATtBVwMu8lwPIZkY+gI/ojGPENbKLOBqiQWZG9xvX+CVz9FnYfu14vZNpvbjP
         dZc3CMqHbJNradUc6zhxvhznhfrlx37LdQk69wJAeNPQVs8rsbMogFW7vDGb3b9DAvBs
         5b/F20asQHhaqXiekbl9TShnSZ7Ue9eXrxQ9b0OLq8ygoHUOfoefGGDSmkV3s5xrI4a2
         gWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GaUoLhkKIwWgm60HYVt/7eOWxVccozlwVYo72qcHsgA=;
        b=kfhj9r9gGLxurLaYRuRQbHz2wz9y7kajJm+/Gqh+CbLoEcx5xyGx11nKWDPIe1YZfw
         f5Kzemmhoxwcu1i3qeez5jEXW3I5Ck8qrwWmkPScrsyGsjQpXXKckwceZ354hU1oOoqD
         nUP73nF5kijoH6ti0evtNLP/CPbZdbPXJQTI40/wssqwPm5xA2Whl2IF+2ur9QKRVt5u
         qiNvFBuWN8sOR8J+j9aOsY/wnJBqhOXOm4ZG3PYqm2HspHwwJbxIwLpLjLxJvnoydTff
         4+YUW8j5lKkIheDEjrMpJ0w3gCLsAP4vQ0P55Y6pWq8pw+RZls1ZKmLJR8TnUXelzXB6
         zHrw==
X-Gm-Message-State: AA+aEWa3bd226mcU1N0LZMFu9+3Ia04L0KW7ZkImeSgJtWidnCKp7BxU
        KEY2hdIdc9qMq00JP0WaiOBVpDAldIrXI3x99TLfn2bLaRM=
X-Google-Smtp-Source: AFSGD/XHSDjduv3uS9ym79vmIe9RFxQKQyEAtwSz5asjg2h4+Ud6+ycMe0ufgIhud2RsfiNgXwMP9tGvpxJwSIqbOPQ=
X-Received: by 2002:a19:d8d8:: with SMTP id r85mr7891860lfi.92.1545070460573;
 Mon, 17 Dec 2018 10:14:20 -0800 (PST)
MIME-Version: 1.0
References: <CANWiEciGLPxDc5JT0+gVrzEyEC6GOcUJUf8XR4PrYHj4TysHpA@mail.gmail.com>
 <112ca7a8933b6113edf29e874d95207a22ccb790.camel@sipsolutions.net>
In-Reply-To: <112ca7a8933b6113edf29e874d95207a22ccb790.camel@sipsolutions.net>
From:   Marcin Sielski <marcin.sielski@gmail.com>
Date:   Mon, 17 Dec 2018 19:14:09 +0100
Message-ID: <CANWiEci5fFFr0n4Eu7N=ox7djf9KSXnma77+N=vRNc1=U997FQ@mail.gmail.com>
Subject: Re: wireless-regdb for automotive
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> > Do you possibly have ideas how to adjust wireless-regdb package
> > to support also automotive use cases as described in:
> > https://www.efis.dk/documents/44659
>
> You might want to explain what changes this requires ...

Let's take 5150 - 5250 MHz as an example. It is ok to use it in in the
Cars if EIRP is limited to 25mW,
These regulations applies to EU countries as well as all the countries
which recognize EU rules.
Currently the only solution is to update db.txt to reflect these
regulations by OEM/Tier 1. There is no
generic solution that would cover various applications (e.g. in
automotive) where Linux kernel is used.

Best Regards

Marcin Sielski
