Return-Path: <SRS0=hJv2=OF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0018BC43441
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C188220873
	for <linux-wireless@archiver.kernel.org>; Mon, 26 Nov 2018 21:59:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C188220873
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbeK0Iyn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 27 Nov 2018 03:54:43 -0500
Received: from mail-it1-f181.google.com ([209.85.166.181]:51458 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbeK0Iyn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Nov 2018 03:54:43 -0500
Received: by mail-it1-f181.google.com with SMTP id x19so30936706itl.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2018 13:59:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C/aWOTDr8mSYdaehHJMKL3LzB/QVedm/htk+dy5kkzA=;
        b=XueUERZrV60+QJNIMFj/tF42IcXjCaa6vGllk46N3XhcFC7MCIqptrN+ZBqQIzS3Xh
         IJgpJNwSCy6LWTdgTzNnOYEm/exghY6byKa2DVpZZphMgKOMQRmWsKRVXUKqcbTz8YjE
         l9pgpbEnxy1lRcQf6Urn1aKI7xz4E5a1ZCPNT08PeQco3x+bNy12pHBqL4dY7wBAR09v
         YADbTz7EQZ3lge7u7LR0rgeWQiUSIfJv6pU3AFClYv5yGO0YfhevaBzNwoCECu4nFTwz
         52ledpB22srBEnL0osDbD5zRjqMuIeatOYX+VEanXV90MyZ2yQ/xklQ6S3Mh8l1tfKQq
         RtSw==
X-Gm-Message-State: AA+aEWauosBuyvQUEw9wKYGGuEEYaRi+vjD2G9BZlQJ0anJ1VyC+IR49
        jhouz8Rr1TWCxuaeqtIP7wDNtlZd+Lit4JUrxyRvWA==
X-Google-Smtp-Source: AFSGD/WSzztrWeVRcAni05lczW0EYUKsjKhnZ2tVxK1E9oSC7ymXx3Y9CF4frv+3z39SZ75clvCYQID9UWddR05rYKQ=
X-Received: by 2002:a24:a141:: with SMTP id n1mr5917143iti.31.1543269550552;
 Mon, 26 Nov 2018 13:59:10 -0800 (PST)
MIME-Version: 1.0
References: <20181123213724.14018-1-eduardoabinader@gmail.com>
 <CAJ0CqmV5byNc+Tmxh5rjHHv9TML31vSWToXq=Fb7aV7JwdJPBw@mail.gmail.com>
 <20181126095935.GA5710@redhat.com> <CAGoNHngacV2jd59FXYxsiBuQOXmdFPe=4TrHh5PYT7Bk8e-37g@mail.gmail.com>
 <CAJ0CqmWTzkh_=XuhSYAwD4Uu1_W6D-mCFSqAwhQUdRD=ciJ7cg@mail.gmail.com> <CAGoNHnguGbWWSNjG=XUt8wHeti1fOtUd0gfX4j4x9C0GDi77fg@mail.gmail.com>
In-Reply-To: <CAGoNHnguGbWWSNjG=XUt8wHeti1fOtUd0gfX4j4x9C0GDi77fg@mail.gmail.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Mon, 26 Nov 2018 22:58:59 +0100
Message-ID: <CAJ0CqmUmf2bqn0rFRdTtQ_V5mABS2Nz3ZWqfX=fugaK6rVcvYw@mail.gmail.com>
Subject: Re: [PATCH] mt76: handle protocol error to proper deinit rx_tasklet
To:     eduardoabinader@gmail.com
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> On Mon, 26 Nov 2018 at 22:31, Lorenzo Bianconi
> <lorenzo.bianconi@redhat.com> wrote:

[...]

> > Hi Eduardo,
> >
> > AFAIU the -EPROTO error is reported only during device removal or just
> > sporadically
> > (you have never experienced any infinity loop). Is it correct?
> > If so I guess we do not need to develop any intrusive workaround since
> > it is just an annoying log message
> >
>
> It is reported only during device removal as I've been seen with my
> comfast dongle.
> The device removal does not lead to an infinity loop, but there's a
> bouncing around 100 urb failed msgs...
>

Thx for the clarification Eduardo. So is it better to mute all -EPROTO errors
or tolerate these annoying messages during dongle removal? I would prefer the
second choice since would be useful to know if the controller reports
that kind of errors.

Regards,
Lorenzo
> Thanks,
> Eduardo
>
> > Regards,
> > Lorenzo
> >
> > >
> > > Regards,
> > > Eduardo
> > > >
> > > > Thanks
> > > > Stanislaw
