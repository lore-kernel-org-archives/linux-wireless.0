Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEA0AC43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9566B206A3
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 10:45:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbfDZKpp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 06:45:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56326 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfDZKpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 06:45:44 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJyMR-0001w6-1T; Fri, 26 Apr 2019 12:45:43 +0200
Message-ID: <d569a6171e50a8bdb026a2ec86c78268c9d7e989.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: Handle bss expiry during connection
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Date:   Fri, 26 Apr 2019 12:45:41 +0200
In-Reply-To: <CABPxzYK3MuJT=r3o6UgBqv-m1B2pqCACwq+i1DDRkC2ZHExvxQ@mail.gmail.com> (sfid-20190426_123540_416400_4CABD853)
References: <20190426095448.3169-1-chaitanya.mgit@gmail.com>
         <cb1c3fcafc7addf0ed8d8d946658801472ad8a1b.camel@sipsolutions.net>
         <CABPxzYK3MuJT=r3o6UgBqv-m1B2pqCACwq+i1DDRkC2ZHExvxQ@mail.gmail.com>
         (sfid-20190426_123540_416400_4CABD853)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-04-26 at 16:05 +0530, Krishna Chaitanya wrote:

> > > +             /* Meanwhile if BSS is expired then add it back to the list as
> > > +              * we have just connected with it.
> > > +              */
> > > +             if (list_empty(&ibss->list))
> > > +                     cfg80211_bss_update(rdev, ibss, ibss->pub.signal);
> > 
> > But I think this adds *another* reference, which is wrong? We do need
> > one reference (the original one the driver gave us) but not a second
> > one?
> 
> This was assuming found will be false so refcnt will be reset and a fresh ref
> is taken.

Yes, it actually adds a new entry entirely, not refs the old entry. But
then you have a new entry returned from cfg80211_bss_update() with a
reference, and leak that reference in the code as written.

You probably need to unref the old one, and keep the new one to pass on
to the next function etc.

> > Maybe the copy we do in cfg80211_bss_update() isn't so bad, but then I'd
> > probably expose it without the signal_valid part and signal/timestamp
> > updates, and just copy the information raw there? However, the "if
> > (found)" part should never be possible here, right? Actually, maybe it
> > is, if we got a *new* entry in the meantime, but then we'd override the
> > newer information with the older, which is kinda bad?
> 
> If we get new information (scan during connection) the bss would not have
> expired right? so this code will not be triggered.

It could have expired and been re-added, no? Ok, I'll admit that's a
stretch since the driver is busy connecting and not scanning, but I
suppose it could happen with multiple VIFs etc?

> My initial stab was in similar lines, something like below: But as the
> bss is expired
> we need to udpate ts, signal and other fields anyway, so I went ahead
> with full update.

Why would we want to update ts, signal etc.? We just keep the old
information, and then the entry will be held for the duration of the
connection, presumably it'll get new updates while you're connected.

> +void cfg80211_add_expired_bss(struct cfg80211_registered_device *rdev,
> +                            struct cfg80211_internal_bss *new)
> +{
> +       if (!new)
> +               return;
> +
> +       spin_lock_bh(&rdev->bss_lock);
> +       new->ts = jiffies
> +       list_add_tail(&new->list, &rdev->bss_list);
> +       rdev->bss_entries++;
> +
> +       rb_insert_bss(rdev, new);
> +       rdev->bss_generation++;
> +
> +       bss_ref_get(rdev, new);
> +
> +       spin_unlock_bh(&rdev->bss_lock);
> +}

Yeah, I was thinking along those lines too, except there's a bit of an
issue with the hidden and non-transmitting lists?

johannes

