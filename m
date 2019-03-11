Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B56C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 03:21:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902042075C
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 03:21:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BQrVqQ+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfCKDVf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Mar 2019 23:21:35 -0400
Received: from mail-vs1-f45.google.com ([209.85.217.45]:40652 "EHLO
        mail-vs1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbfCKDVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Mar 2019 23:21:34 -0400
Received: by mail-vs1-f45.google.com with SMTP id z18so1835706vso.7
        for <linux-wireless@vger.kernel.org>; Sun, 10 Mar 2019 20:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pmiPAySxOa7br5g/s2bXyAxVps0REAsm35em50kzE9o=;
        b=BQrVqQ+4qqJx19D9Cy/32BEJbTtkh+0FETyyokpMdO25pMANzj3O/ZJvyrwhJgwJT4
         ubig6UGIW3v6hpsuBpOWis6aCKBcljKBQfT51cYafZaIsLbvSeYU2jhfP3QUQRKjsR3P
         D/vtAdlvCOs4VpMYR92TOnP3jNxHiRb+uoBB0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pmiPAySxOa7br5g/s2bXyAxVps0REAsm35em50kzE9o=;
        b=W1ZV+5OZwoWca/K1OngSDF8Su88PNF8eV2HMriioCF1o17h7H5bLlndfD3PxbZL5S/
         XyWv+A7FfyTxgQ+YPWaaA8ZLUdLZa8wok1Ixwx4XFuyUeAMqDnGdKpjbG1spn1FV6z5j
         ZsPmwFXp0yNwr/zITpERq37qLXofMWiFStNq0AoTlFaTk3wC4i0jnqF9Htyvw3gromLa
         hSRdaeTw1cUHrVeAt34THhthoifF7apuPmovYn/fBtNZ2ITvKn89msw8fJM4lpgZfN82
         J12g9gXsO0OnCsg/Wx6d5MDJyRbFfOvfXo/Iswl+lr22Bts8Pf8wCAKKK6yWdCXuyddh
         Gk4Q==
X-Gm-Message-State: APjAAAVGKssOFac2276RUZz9tyTGbVpF/cKYB0hOjuVJBTezmT/fj4kw
        tkXzVIDif8+kjhal0lVfrtSML32al4zjzkwJwT/R0hL+abVcBw==
X-Google-Smtp-Source: APXvYqxFpMYkqRul1DFtShcpDJEa8Cx3Id5dI35k6tb82TUW7eq8wyKmRqQFLm20oubIFFEL6d0coadJNjpozcmTk8Q=
X-Received: by 2002:a67:f05a:: with SMTP id q26mr16264155vsm.174.1552274493906;
 Sun, 10 Mar 2019 20:21:33 -0700 (PDT)
MIME-Version: 1.0
References: <f90f210372b8c7f7efae0c43ab3ae925c334bc0e.camel@sipsolutions.net>
 <871s3qn91h.fsf@toke.dk> <5d26367411cf2b50d4cf237640598d1952f17673.camel@sipsolutions.net>
 <87y35ylty3.fsf@toke.dk>
In-Reply-To: <87y35ylty3.fsf@toke.dk>
From:   Kevin Hayes <kevinhayes@chromium.org>
Date:   Sun, 10 Mar 2019 20:21:23 -0700
Message-ID: <CAPJUEh3s-Bs6dKrDG54Q1Wu2+1+kwMvTDxJxxEAVBanLA0=FYA@mail.gmail.com>
Subject: Re: wireless workshop coming soon :-)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

[resending after html mode got nacked..]

Hi Johannes/Toke,
It would be fine with Kan and me to push the airtime fairness
discussion to later, to accomodate Toke.
Workshop fairness in action.  :)

K++

On Fri, Mar 1, 2019 at 3:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Johannes Berg <johannes@sipsolutions.net> writes:
>
> > On Fri, 2019-03-01 at 12:11 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wro=
te:
> >> Johannes Berg <johannes@sipsolutions.net> writes:
> >>
> >> > Please add your favourite topics to
> >> >
> >> > https://wireless.wiki.kernel.org/en/developers/summits/prague-2019
> >> >
> >> > I've added a few I think we should discuss at this stage, so also se=
e if
> >> > you have an opinion on those :-)
> >>
> >> Cool! Could we schedule the scheduling and airtime fairness topics aft=
er
> >> 10:30? Have a tutorial to run in the morning and would obviously like =
to
> >> participate in those discussions ;)
> >
> > Yeah, I'm aware. I also have a conflict with the netlink workshop, so
> > Kalle will have to take over for me some of the time :-)
>
> Great! Thought you probably were, just wanted an explicit ACK ;)
>
> -Toke



--=20

Kevin Hayes
