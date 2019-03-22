Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D253BC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 22:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93EDC218D4
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 22:29:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibsgaard-io.20150623.gappssmtp.com header.i=@ibsgaard-io.20150623.gappssmtp.com header.b="RNP+49jp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfCVW3Q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 18:29:16 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36828 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbfCVW3Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 18:29:16 -0400
Received: by mail-it1-f196.google.com with SMTP id h9so5810854itl.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 Mar 2019 15:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ibsgaard-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HpMRB4T9Vcmut0Bv3IjZ7VvWCPFTxqtnqWFzP6QHqHU=;
        b=RNP+49jpDvKidFNqHgOi45gj2AJvUJirISmkdPPSw7E195BEQ++LnABnB2xTpraVNf
         NabaSydm6d8esnXyss8hTSNTtuNx5sXMijgedLBBiK5ymafY3r/vexEcIu+fmK2qpAZ6
         COh1ShnJ0REvIspeOA0uYH5FIN+kXadlCzhG4zLVlahM/BP+eRDFNlj2MNCDLwwwvU/n
         H6/i4Y204HN8owofQ9ez8tlKkqYfsrFFemMMfL4WEqfaZliMFHlKDs3M0tZbZ9IwwGVR
         xLMHE1L9vq3UAoH08KG255lVwVNDbu5bkUXqLu/S+w0P32HgKuxuzes+w+nuYxOOyEar
         sGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HpMRB4T9Vcmut0Bv3IjZ7VvWCPFTxqtnqWFzP6QHqHU=;
        b=QdyVOCR8NxT/vsJ0QkWxSiQYsT4+NhOAyYoP5fafzVz7721gOpIJgbGo6AzuSOMGUr
         JPwk39audUpWuCT7sqlVzy6z+JBp4CARhwVOZAgmOgLk2h7DS+p8Tu/Tgxy84S+ClT99
         PQL8GCPjNsAj//gsitQJZabG9ZOYHh9hqcdgwSFyzecy5JXClZ3WOzNOzKOdyINSVvSP
         pBcDggYsfv3HQlknnoOIWsyMXO7WA4V0pRLTgl5/Uh1vFuEb+OSsimGwvfdMgkycq9Zu
         jKGaacUCkanalCdD65CpkpL8lBU6Kyv76SlwtcTz5mdpsEp1hzbp8qm9N5b0h4kZwhN0
         ckAg==
X-Gm-Message-State: APjAAAU0lFUFu6BIml8uc2n6aKteIalDM7rTOOn2RL0cgTkmmPHPJk9h
        W2ZBuMjRP2Gm5yKrHWzi2Q+zmWTsRGu2AORCReDoEzR9lX0=
X-Google-Smtp-Source: APXvYqzuln9V7gMoCzEHnC8ju0OSmSbKbI0YruqBYnSU5miHwbasTg6ohjrMRNT4s7fgLg8j83pjab7pkJWnWbPLbdo=
X-Received: by 2002:a24:75c7:: with SMTP id y190mr139121itc.108.1553293755545;
 Fri, 22 Mar 2019 15:29:15 -0700 (PDT)
MIME-Version: 1.0
References: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
 <83dad8c2478e141e382b02056389ba281bc72720.camel@sipsolutions.net>
 <CABWD38kCrzns2RkShGDY6ip99fAFM3Ar_n6zDhk73KHxLTDbpQ@mail.gmail.com>
 <3ae333867edab6cc30e8154cce47ce3b4555fa43.camel@sipsolutions.net> <eb3df21727c81ceed319b9106db895d735f4919d.camel@sipsolutions.net>
In-Reply-To: <eb3df21727c81ceed319b9106db895d735f4919d.camel@sipsolutions.net>
From:   thomas <thomas@ibsgaard.io>
Date:   Fri, 22 Mar 2019 15:29:04 -0700
Message-ID: <CABWD38nXRk5d7LPafnt9dvXc6nxFrEzeoDEREbdswga+WjpEMw@mail.gmail.com>
Subject: Re: preparing for 802.11ah channels
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Mar 22, 2019 at 1:50 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2019-03-22 at 21:46 +0100, Johannes Berg wrote:
> >
> > In effect, an existing
> >
> >       u32 freq;
> >
> > would become
> >
> >       u32 freq, freq_fractional;
> >
> > and we'd just treat the two as a 32.32 fixed point integer.
>
> Maybe easier would be to say
>
>         u32 freq;
>         u16 freq_partial_khz;
>
> and basically say
>
>         freq_khz = freq * 1000 + freq_partial_khz;
>
> Same reasoning and similar logic, but no need to do any sort of fixed
> point conversions.

I guess it's a tradeoff between leaving MHz-only drivers alone and
wrapping existing assignments and comparisons in maybe a macro to
extract the final KHz value. The current set of changes is about 150
lines in net/mac80211/ and net/wireless/ [1] with drivers/ being about
the same.

Adding the KHz part to center_freq, center_freq1, and rx_status->freq
may be fewer overall changes in mac80211 and cfg80211, and should be
none for existing drivers.

I'll give this a shot at some point when it comes time to rebase on
upstream wireless-testing.

[1] https://paste.debian.net/1074289/
