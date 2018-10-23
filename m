Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 563F9C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 18:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AD0220671
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 18:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DYpLUnyt"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1AD0220671
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbeJXCaa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 22:30:30 -0400
Received: from mail-lf1-f53.google.com ([209.85.167.53]:32834 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbeJXCa3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 22:30:29 -0400
Received: by mail-lf1-f53.google.com with SMTP id o21-v6so1905746lfe.0;
        Tue, 23 Oct 2018 11:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=E8Gg4mKKacYaQ8jlyesL8yhwS9omVZzGYBqcq8s4anE=;
        b=DYpLUnytObPZSYjDWUu7ps56mlnKKjWRvZuKd17tcfOzZoZyWjj9xs6Ki8UnwB6Syg
         3eiZ+sG+zbHpbDFKaglz+wYH6yHqy6AUcM5GDgg2+VNXmBJlSc/XZgb3gHt+C4e/FfzG
         SNDTH9GE2+G2/iATChTxlqMzu751e1rZtu4NYTLXRRQ1KSNgV0vHX15zIehM3oGFTP+D
         4bHXix0XWp4aUt6Mayvb/BQK8HSgF55ly5BCFZWeGTymOymNt6LHcUg6FOR16UFySupL
         jLg3ru5bUktmAS35P1uHNYlTrjhtY9WXmxflY0bRItUjMghP5pwPkM/4dXrQXs0Wa679
         7E7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=E8Gg4mKKacYaQ8jlyesL8yhwS9omVZzGYBqcq8s4anE=;
        b=pOoW4U99th1Ebz/UQ8r5VVO7mc/fxwzOLEbc1RN6bP3n83q0WQIHi9i+XK54C3SOy6
         gJQQaLPFmJhHP95wpoedvKlkLo7J3TJTphrN+lT7IyEUAckPIvXgm3WTnLtEZfRnReiG
         8AIqa1IpvjlhwNUk5OdbTWDCzLYfXetQYFmNVkvfYomsXEZDFZ5AmOwiLdXiQeQOAe5V
         JDd2O0ilEEEg5sAHvwz2/IJOs1S6o4ivL8ohHvmTSWoAr2NGRvj4ySFf0o/Ker6b2XfW
         lWd1HKwI5Q/D5D2dIIolsZX+NVHXoVwNNJ2ijPN15MgHRPJOgKE4SjOmndyy5J03CUgq
         MR/w==
X-Gm-Message-State: ABuFfojP7LjjDPFt7NhCCQ7kU4NOLhDsBSxDBiDUfNdvNzTxO+z8UcOc
        UmZmuQiWU70FvKg84f4D396hfdS+rAP1cTBv3+w=
X-Google-Smtp-Source: ACcGV60mbuS/f2euoCVSpjveTJx9v+pE6W3T8v/dwjg9VfSZAqQjp8G8M1ZJKXPBYIbeCJb3G9nPm/2BreVjlRjKYMk=
X-Received: by 2002:a19:7d55:: with SMTP id y82-v6mr12941001lfc.29.1540317960627;
 Tue, 23 Oct 2018 11:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <a99840d5-7d57-ec1f-1c70-37ffa6cfd31b@lwfinger.net>
 <20181023143856.GD6850@thunk.org> <alpine.LRH.2.00.1810231833260.2860@gjva.wvxbf.pm>
 <20181023173747.GG6850@thunk.org>
In-Reply-To: <20181023173747.GG6850@thunk.org>
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Tue, 23 Oct 2018 11:05:48 -0700
Message-ID: <CAKdAkRQvwe93nwLgEQuSsmbUbzMzVjO22wrfg=wzQtfHoSq2DA@mail.gmail.com>
Subject: Re: Is Fixes line enough?
To:     "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Oct 23, 2018 at 10:38 AM Theodore Y. Ts'o <tytso@mit.edu> wrote:
>
> On Tue, Oct 23, 2018 at 06:36:26PM +0200, Jiri Kosina wrote:
> > FWIW, I brought this up already at KS 2016, see Jon's coverage here:
> >
> >       https://lwn.net/Articles/705220/
> >
> > My primary motivation to bring that up back then was to try to reduce the
> > number of patches that are taken into -stable while there is no good
> > justification for that (by requiring each and every of those having Fixes:
> > present as a requirement), but it didn't really lead anywhere.
>
> Ah, I didn't get that you were trying to suggest that things only go
> into stable if it has both Fixes: *and* Cc: Stable.
>
> If that's the problem you were trying to solve, perhaps we could ask
> Stephen Rothwell if he would be willing to run a script that sends
> nag-o-grams to Maintainers who incluce patches in linux-next that have
> Cc: stable but neither Fixes nor a "# 4.x" appended to the end of the
> Cc: stable line?
>

Patches adding new PCI/USB/ACPI IDs or DMI quirks are usually accepted
into stable but normally lack "Fixes" tag.

Thanks.

-- 
Dmitry
