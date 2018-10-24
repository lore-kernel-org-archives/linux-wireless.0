Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCFFC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93AB42082F
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 09:41:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PvLSmLJ1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93AB42082F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbeJXSI1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 14:08:27 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55344 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbeJXSI1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 14:08:27 -0400
Received: by mail-wm1-f66.google.com with SMTP id s10-v6so2574914wmc.5;
        Wed, 24 Oct 2018 02:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZtgObpVvHrAsDw9OZTWexptw1jCGycSDOQHSyb17Jc=;
        b=PvLSmLJ1DekD2dXe1U8rg+H6aWVBfURMq72Tq1g4Ai/6usKhmzlvqc4D1+/JlIviQS
         UiB9VX8Ngcl+xSfCnEzRegbtU9GH2gl54MIsr4+V50GC6vYmHiNKGI12SJXspKB4aKVV
         VWKnAimTm4hRXUiXi3Ejgv2PJQduG6fAHShY0z2DNfWmg2jOFwrNNyBVmDELJXDn7qud
         Zi9EVHDIpRPJkSawcRFGaOQBxG2i62WbdmthK0B5WDWKioYyaEG8NrlQwZXaS9PRaVqw
         zqr9S2Q+5PMNwJb5tbo55vCU779bbGKe8xRm3uemXwK2CS3/6/aruxA+YX06yZ0bEWBZ
         kbtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZtgObpVvHrAsDw9OZTWexptw1jCGycSDOQHSyb17Jc=;
        b=myFbRaqbMCvmaeEvfZ79x+7xv7lIzN4wKEfXwHmS2ya634BaxICYWAdoT341+2765Q
         sH7NJ/cokMO8djD9jpVL6AR7gU8fgkvDHhpq/KveNhWDlUtfd7PKjY7YtnKUTjZvkXWw
         3bqsalYt2pw2OybdAvahOWPw1Z9uWyY3qEGoDfIBhXVGZ9Poxiiov1CwiPiFU82kuXnE
         GdSx3JBE7Ox0nwTa1yOKEtc4nNcTaB8Mjipk+J2+I1rRow4w0EDUIodbQpnfehf/xB4m
         iXHIc89ZHh2AuOk4LueF225V51BGaI62IdMwhVRbuXQCCWfX3jy7my0Ag3rYVEO0+DWc
         Rnmw==
X-Gm-Message-State: AGRZ1gJqa+ZO7vttc6CWRS2WzSJStTnhAHR0p6gEVk/bHwk2jTX8fjDm
        kABxSZXF0N4hy7j9LAAqb7pf9T99Qf1kUNBvddE=
X-Google-Smtp-Source: AJdET5c2LnyQ0LYCuDIz7YssSCqWG/cYYwIZAMjL6YAr/xqyerygPKAQcz1Vv6K8E6SX5ePWopZ47ByEJ2BHBuXq1bE=
X-Received: by 2002:a1c:1250:: with SMTP id 77-v6mr1841177wms.70.1540374061872;
 Wed, 24 Oct 2018 02:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20181023001308.GA4150@embeddedor.com> <0b3197a734f71bdfffaf717e63b17e2fe31720a2.camel@sipsolutions.net>
 <f0a240e2-cae7-07f4-757f-a8606199d29e@embeddedor.com> <c2fad584-1705-a5f2-d63c-824e9b96cf50@embeddedor.com>
 <94958073867a5bbf8161d7ea8851aaea026762b1.camel@sipsolutions.net>
In-Reply-To: <94958073867a5bbf8161d7ea8851aaea026762b1.camel@sipsolutions.net>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Wed, 24 Oct 2018 20:40:47 +1100
Message-ID: <CAGRGNgVC6TMYRF98yp=54BNETsT9tnzVuE9y8t0+tq_jJcxRjQ@mail.gmail.com>
Subject: Re: [PATCH v2] wireless: mark expected switch fall-throughs
To:     gustavo@embeddedor.com
Cc:     "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Gustavo,

On Wed, Oct 24, 2018 at 7:36 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Tue, 2018-10-23 at 12:58 +0200, Gustavo A. R. Silva wrote:
> > On 10/23/18 10:59 AM, Gustavo A. R. Silva wrote:
> > >
> > > On 10/23/18 9:01 AM, Johannes Berg wrote:
> > > > On Tue, 2018-10-23 at 02:13 +0200, Gustavo A. R. Silva wrote:
> > > > > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > > > > where we are expecting to fall through.
> > > > >
> > > > > Warning level 3 was used: -Wimplicit-fallthrough=3
> > > > >
> > > > > This code was not tested and GCC 7.2.0 was used to compile it.
> > > >
> > > > Look, I'm not going to make this any clearer: I'm not applying patches
> > > > like that where you've invested no effort whatsoever on verifying that
> > > > they're correct.
> > > >
> > >
> > > How do you suggest me to verify that every part is correct in this type
> > > of patches?
> > >
> >
> > BTW... I'm under the impression you think that I don't even look at
> > the code. Is that correct?
>
> That's what your commit log looks like, yes. This is your full commit
> log:
>
>    In preparation to enabling -Wimplicit-fallthrough, mark switch cases
>    where we are expecting to fall through.
>
>    Warning level 3 was used: -Wimplicit-fallthrough=3
>
>    This code was not tested and GCC 7.2.0 was used to compile it.
>
>    For all I know, you could've run spatch to add the comments wherever
>    there was no break, and then compiled it once.

It might also help to split these up by the "type" of change. For
example this patch contains:

1. A whole lot of places where there's a "if (condition) { break; }"
just before the fall through

You could add a line describing the logic there to the commit message,
maybe something like:

As there's a conditional break at the end of the case, the fall
through appears to be intentional.


2. Reformatting an existing comment

These should definitely be split out as they're just reformatting
comments to match gcc's expectations. You could describe this like:

Reformat existing fall through messages into the format expected by gcc.


Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
