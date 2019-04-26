Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387CCC43218
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F4136206DD
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:35:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C+8YKtm9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfDZKfk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:35:40 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45747 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725877AbfDZKfj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 06:35:39 -0400
Received: by mail-io1-f66.google.com with SMTP id e8so2497726ioe.12
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 03:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6h+6xCRZVOSPMnN/aaNHpLqMrH8eTsyco2pj2bjVqW8=;
        b=C+8YKtm9Vn18dobG8vkOJ/GTyh1h8QMizpQxcveHuh/F63++O6LGEmUIQfJDQA+gO2
         d8tVpIR1dojZrZqkynTmLPGjLTeRFDqTI3KUDdKRSLaF8OTsSIkTc1aoHcU6pS2T2SZw
         QPBQ9vZsaR9XiyTSVd9tr2sQc1o94FQyix2w0Mny11V0kQVToZkYrGix2SSaUrNNjOZR
         IaUBz8lSnpSs2JutJjsDHr/mQL74QrEfpszktHX6SQJCGbntMspvwoBLY4SF0KBatNp9
         tS4O6hTS2a2IWaURC4x+qp5HP2TKJEX7CJz4eU2Lid0EqkrzcdCi5YBKlyb0XiJ5FjuF
         Xmww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6h+6xCRZVOSPMnN/aaNHpLqMrH8eTsyco2pj2bjVqW8=;
        b=rmozWQIi5dZFyGTXk7md8J0TtJxQM+ONael8QEJ4NMhcy33arfgMIqpKnA2N+fE5ET
         cgdGexz3+3HJOjKV+62iaeXrPmIDan1ZgCzCUe8+HH+53XmY4cQqOK1Lzqbhn+56j4Jw
         pfsI/mSzKD3TcBpuKQUzNJK/dMvlV/RWFbHSsHyyoMmF+2STSRPvo0s70A0ARjeC1mlD
         1ZACyZejpjK9QtiqTL7wOKQE4mOfehGKvOk0FQP0TmiwouTz2HcOX1TNAQcHHWG1ldBS
         Srints5h1RFr4gYlILzxCAG3zm7a6ihU7rax2ccVyOkZ2zq9f8+GklsnoxLOLCrkasLl
         2xyw==
X-Gm-Message-State: APjAAAXgiq+Un6kKxJ+SArxDijQan2+2OadOsv0iw9kSTrMGWcDZ+HXK
        aGg1mTZyPXDSFR3U1gdKhRdlUBwPIktycSHEIiNLmF5Re90=
X-Google-Smtp-Source: APXvYqzWuYxIKnQIjii8q11DHyf9dKqwUGT3zU+9e3yrC//Xs0wcvY5dfrpj+RMDMH1BL+0NfN3FRuGfu5wsUlzX9RA=
X-Received: by 2002:a6b:fe01:: with SMTP id x1mr8521141ioh.4.1556274938560;
 Fri, 26 Apr 2019 03:35:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190426095448.3169-1-chaitanya.mgit@gmail.com> <cb1c3fcafc7addf0ed8d8d946658801472ad8a1b.camel@sipsolutions.net>
In-Reply-To: <cb1c3fcafc7addf0ed8d8d946658801472ad8a1b.camel@sipsolutions.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Fri, 26 Apr 2019 16:05:27 +0530
Message-ID: <CABPxzYK3MuJT=r3o6UgBqv-m1B2pqCACwq+i1DDRkC2ZHExvxQ@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Handle bss expiry during connection
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 26, 2019 at 3:44 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2019-04-26 at 15:24 +0530, chaitanya.mgit@gmail.com wrote:
> > From: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
> >
> > If the BSS is expired during connection, the connect result will
> > trigger a kernel warning. Ideally cfg80211 should hold the BSS
> > before the connection is attempted, but as the BSSID is not known
> > in case of auth/assoc MLME offload (connect op) it doesn't.
> >
> > For those drivers without the connect op cfg80211 holds down the
> > reference so it wil not be removed from list.
> >
> > Fix this by removing the warning and silently adding the BSS back to
> > the bss list which is return by the driver (with proper BSSID set).
> > The requirements for drivers are documented in the API's.
>
> This looks good, mostly :-)
>
> >   * @bssid: The BSSID of the AP (may be %NULL)
> >   * @bss: Entry of bss to which STA got connected to, can be obtained through
> > - *   cfg80211_get_bss() (may be %NULL). Only one parameter among @bssid and
> > - *   @bss needs to be specified.
> > + *   cfg80211_get_bss() (may be %NULL) but it is recommended to store the
> > + *   bss from the connect_request and hold a reference to it and return
> > + *   through this param to avoid warning if the bss is expired during the
> > + *   connection, esp. for those drivers implementing connect op.
> > + *   Only one parameter among @bssid and @bss needs to be specified.
>
> So while we're at it, we should probably amend the documentation to say
> that the reference to the BSS passes from the driver to cfg80211, right?
Yes
>
> > +     /* bss is not NULL, so even though bss might have expired, the driver
> > +      * is still holding a reference to it.
> > +      */
>
> is -> was? It's our reference now.
Yes
>
> >       if (params->bss) {
> > -             /* Make sure the bss entry provided by the driver is valid. */
> >               struct cfg80211_internal_bss *ibss = bss_from_pub(params->bss);
> >
> > -             if (WARN_ON(list_empty(&ibss->list))) {
> > -                     cfg80211_put_bss(wdev->wiphy, params->bss);
>
> That's why we had a put_bss() here.
I will add a change to put bss after we update.
>
> > +             /* Meanwhile if BSS is expired then add it back to the list as
> > +              * we have just connected with it.
> > +              */
> > +             if (list_empty(&ibss->list))
> > +                     cfg80211_bss_update(rdev, ibss, ibss->pub.signal);
>
> But I think this adds *another* reference, which is wrong? We do need
> one reference (the original one the driver gave us) but not a second
> one?
This was assuming found will be false so refcnt will be reset and a fresh ref
is taken.
> Also, not sure the last argument (signal_valid) is right?
>
> Basically all that really just means that cfg80211_bss_update() is
> probably not the right function to call. It also updates the timestamp,
> which is not true, we haven't received updated information we just used
> it and thus held on to it.
>
> I think we should probably just instead of a "cfg80211_bss_relink()"
> function exposed, and that just does something like
>
>         list_add_tail(&new->list, &rdev->bss_list);
>         rdev->bss_entries++;
>         rb_insert_bss(rdev, new);
>
>         rdev->bss_generation++;
>
> though I'm not - off the top of my head - sure about
> cfg80211_combine_bsses() being needed or not.
>
> Maybe the copy we do in cfg80211_bss_update() isn't so bad, but then I'd
> probably expose it without the signal_valid part and signal/timestamp
> updates, and just copy the information raw there? However, the "if
> (found)" part should never be possible here, right? Actually, maybe it
> is, if we got a *new* entry in the meantime, but then we'd override the
> newer information with the older, which is kinda bad?

If we get new information (scan during connection) the bss would not have
expired right? so this code will not be triggered.

My initial stab was in similar lines, something like below: But as the
bss is expired
we need to udpate ts, signal and other fields anyway, so I went ahead
with full update.
+void cfg80211_add_expired_bss(struct cfg80211_registered_device *rdev,
+                            struct cfg80211_internal_bss *new)
+{
+       if (!new)
+               return;
+
+       spin_lock_bh(&rdev->bss_lock);
+       new->ts = jiffies
+       list_add_tail(&new->list, &rdev->bss_list);
+       rdev->bss_entries++;
+
+       rb_insert_bss(rdev, new);
+       rdev->bss_generation++;
+
+       bss_ref_get(rdev, new);
+
+       spin_unlock_bh(&rdev->bss_lock);
+}


> johannes
>


-- 
Thanks,
Regards,
Chaitanya T K.
