Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:42181 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbeH2X3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 19:29:19 -0400
Received: by mail-io0-f173.google.com with SMTP id n18-v6so5475068ioa.9
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 12:30:59 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
 <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
 <1535569548.5215.33.camel@sipsolutions.net> <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
 <1535570007.5215.34.camel@sipsolutions.net>
In-Reply-To: <1535570007.5215.34.camel@sipsolutions.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Wed, 29 Aug 2018 21:30:47 +0200
Message-ID: <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com> (sfid-20180829_213109_262456_C2BE0786)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is set
 to one
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 29, 2018 at 9:13 PM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2018-08-29 at 21:12 +0200, Lorenzo Bianconi wrote:
>
> > That has been fixed by Sara's patch since now we add the pad directly
> > on the head of the
> > subsequent subframes (not to the tail of the first one). Am I missing something?
>
> As far as the pad is concerned, yes, but I think the header length also
> changes?

Ops, maybe I got your point:
ieee80211_amsdu_realloc_pad() in ieee80211_amsdu_prepare_head() can
expand the headroom on the first frame
but if ieee80211_amsdu_realloc_pad() on the second one fails, we do
not take into account the extra len added on the
first subframe. Is that what you mean?

>
> I'm too tired now - will think about it again tomorrow.
>

ack :)

Regards,
Lorenzo

> johannes
