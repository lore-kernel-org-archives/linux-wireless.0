Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC8EC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D41EC206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SNcEpSRk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfDZK44 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:56:56 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:50341 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfDZK4z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 06:56:55 -0400
Received: by mail-it1-f193.google.com with SMTP id q14so5176885itk.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Apr 2019 03:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vTLqCpV3pgok3Olcn1gwflZXWjXcgBlQ2Sjt/NABYuo=;
        b=SNcEpSRk5dCctwO86bijNl9iInebDgHTxUf6iW23lw5NE7ulTM9w8h3Z0kPEnJgcJ1
         gyWyDL8qtnZCYRXndjO+Ou5GtWU0UVqt4RsrI00l0sYqLFr5tcck57OXrb+wIY2iVt1+
         2nkCp0JHu2vpf2Atv2eThGFe6ni3bcNt5r3EH5cJR/je+Rqcd7vVoCaW9KtZ2IUOEFXj
         vlIszd9kFGqUxqHSfGlHm2IhnPJNwFyIt5waKdzsjZZ5ly99dWyp3U2ZqWrewHIvIRrx
         2bzsbiIQ/uqaosyHIe5njNzcGDh/oEibvQVZvlAjsyRx+y8GzM9h3UijydpH5XuY3fGW
         G5rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vTLqCpV3pgok3Olcn1gwflZXWjXcgBlQ2Sjt/NABYuo=;
        b=mhzufxOygl3VWqp6BqFAltCrB6oDHPMUlimdAHrHw+YCfwSSdOH+iOeuYljPnN0vFN
         osW0NlxNg4wUcqYyVvvf9k5q+F3bSjvHq44rwtlFMNvd8gBtrVOPS0AoUqZfh77p2cuO
         K4ZCh3Fpv6ciAyvCts3qtZhd3Mdtyywc84Iyi19qEn+07yo3iq2vWG5UdSTM+5ZdWwrc
         B7mViLgkaeGWuS6W05QwycRo57KejeJ6/YoKUgb2eqf9owE8fjZTwdwOEpa0gNcxK5yI
         cW91VwFif0FmODd5C/hCqLgiyHZDSrlFSK0vjfb0La2Raxqv3/2cyEXyyrd9v5CYikod
         7dJA==
X-Gm-Message-State: APjAAAVCTVd0/JmuoYGO64vWxhdD7KqVgzhMc50zMaatSBJEBL6a/Fhc
        8kjfmhCu5LOu4/3AmZ13kWMe1l4af0/BHfw/nA4=
X-Google-Smtp-Source: APXvYqw7yXdlPqqkydm64Bf5F1efUHu7UUcqTCGA95v3nEHIKyBKuReibsKKiin64jKU45rKcALAgER2oY7Dq8RBJ8k=
X-Received: by 2002:a02:928c:: with SMTP id b12mr32176039jah.8.1556276214864;
 Fri, 26 Apr 2019 03:56:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190426095448.3169-1-chaitanya.mgit@gmail.com>
 <cb1c3fcafc7addf0ed8d8d946658801472ad8a1b.camel@sipsolutions.net>
 <CABPxzYK3MuJT=r3o6UgBqv-m1B2pqCACwq+i1DDRkC2ZHExvxQ@mail.gmail.com> <d569a6171e50a8bdb026a2ec86c78268c9d7e989.camel@sipsolutions.net>
In-Reply-To: <d569a6171e50a8bdb026a2ec86c78268c9d7e989.camel@sipsolutions.net>
From:   Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date:   Fri, 26 Apr 2019 16:26:43 +0530
Message-ID: <CABPxzYKKMJ0PYwbA706qferBGPEitw26uG5Jp4qKzsaGPx+Dqg@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: Handle bss expiry during connection
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 26, 2019 at 4:15 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Fri, 2019-04-26 at 16:05 +0530, Krishna Chaitanya wrote:
>
> > > > +             /* Meanwhile if BSS is expired then add it back to the list as
> > > > +              * we have just connected with it.
> > > > +              */
> > > > +             if (list_empty(&ibss->list))
> > > > +                     cfg80211_bss_update(rdev, ibss, ibss->pub.signal);
> > >
> > > But I think this adds *another* reference, which is wrong? We do need
> > > one reference (the original one the driver gave us) but not a second
> > > one?
> >
> > This was assuming found will be false so refcnt will be reset and a fresh ref
> > is taken.
>
> Yes, it actually adds a new entry entirely, not refs the old entry. But
> then you have a new entry returned from cfg80211_bss_update() with a
> reference, and leak that reference in the code as written.
>
> You probably need to unref the old one, and keep the new one to pass on
> to the next function etc.
>

Right, we should unref after the update.

> > > Maybe the copy we do in cfg80211_bss_update() isn't so bad, but then I'd
> > > probably expose it without the signal_valid part and signal/timestamp
> > > updates, and just copy the information raw there? However, the "if
> > > (found)" part should never be possible here, right? Actually, maybe it
> > > is, if we got a *new* entry in the meantime, but then we'd override the
> > > newer information with the older, which is kinda bad?
> >
> > If we get new information (scan during connection) the bss would not have
> > expired right? so this code will not be triggered.
>
> It could have expired and been re-added, no? Ok, I'll admit that's a
> stretch since the driver is busy connecting and not scanning, but I
> suppose it could happen with multiple VIFs etc?

Yes, it might be possible with multiple VIF's, when one VIF is connecting
and other VIF is scanning, it can find the connecting bssid in its scan results.

> > My initial stab was in similar lines, something like below: But as the
> > bss is expired
> > we need to udpate ts, signal and other fields anyway, so I went ahead
> > with full update.
>
> Why would we want to update ts, signal etc.? We just keep the old
> information, and then the entry will be held for the duration of the
> connection, presumably it'll get new updates while you're connected.

If we are holding it, then we will not be using ts anyway, so updating or
not should not matter. But as its old info better to leave it that way, and
update these fields only from scan results.

> > +void cfg80211_add_expired_bss(struct cfg80211_registered_device *rdev,
> > +                            struct cfg80211_internal_bss *new)
> > +{
> > +       if (!new)
> > +               return;
> > +
> > +       spin_lock_bh(&rdev->bss_lock);
> > +       new->ts = jiffies
> > +       list_add_tail(&new->list, &rdev->bss_list);
> > +       rdev->bss_entries++;
> > +
> > +       rb_insert_bss(rdev, new);
> > +       rdev->bss_generation++;
> > +
> > +       bss_ref_get(rdev, new);
> > +
> > +       spin_unlock_bh(&rdev->bss_lock);
> > +}
>
> Yeah, I was thinking along those lines too, except there's a bit of an
> issue with the hidden and non-transmitting lists?
Ok, let me think for a bit and will send you V2. Thanks for quick review.
> johannes
>


-- 
Thanks,
Regards,
Chaitanya T K.
