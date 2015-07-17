Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:34112 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757358AbbGQJdk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 05:33:40 -0400
Received: by iebmu5 with SMTP id mu5so73159069ieb.1
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 02:33:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1437124562.1933.7.camel@sipsolutions.net>
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
 <1434530870.1884.12.camel@sipsolutions.net> <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
 <1434538909.1884.39.camel@sipsolutions.net> <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com>
 <1434541047.1884.41.camel@sipsolutions.net> <CABPxzYKmsGyhmM_5e11N2sgw8c-ARyJJ_rPkfjwCcZ6+hfqHgg@mail.gmail.com>
 <1437124562.1933.7.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Fri, 17 Jul 2015 15:03:20 +0530
Message-ID: <CABPxzYJF1Oi1wdW3PUCOJ5hYiA0TmA4neJDF8w6FDFm-jGmbnQ@mail.gmail.com> (sfid-20150717_113354_912229_1A28535B)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state stuck
 in ACTIVE caused by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2015 at 2:46 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>
> I've applied this patch.

Thanks.

>
>
> > > I really hate this whole powersave code btw - we really should
> > > refactor
> > > that into its own little library module or so...
> > Yes, that sounds good.
>
> want to work on that? :)
Sure, but i cannot spend full time on that so the progress might be slow.

>
> The whole thing is awfully broken anyway since it does hw-level
> configuration based on vif-level state, and ath9k does in fact support
> multiple vifs ...
Yes, we have faced problems with this especially handling fake ps,
roc...we should move it to per vif config
