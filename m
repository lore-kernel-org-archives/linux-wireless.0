Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:34395 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727554AbeH2XLG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Aug 2018 19:11:06 -0400
Received: by mail-it0-f66.google.com with SMTP id x79-v6so42656ita.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2018 12:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
 <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
 <1535569548.5215.33.camel@sipsolutions.net>
In-Reply-To: <1535569548.5215.33.camel@sipsolutions.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Wed, 29 Aug 2018 21:12:38 +0200
Message-ID: <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com> (sfid-20180829_211315_617690_DE11A7F1)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is set
 to one
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Sara Sharon <sara.sharon@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On Wed, 2018-08-29 at 21:03 +0200, Lorenzo Bianconi wrote:
> > Do not try to aggregate packets in a A-MSDU frame and add A-MSDU header
> > on the first packet if max_tx_fragments or max_amsdu_subframes are
> > set to one
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> > Changes since v1:
> > - rebased on top of mac80211 master branch
> > - removed ieee80211_amsdu_realloc_pad chunk
> >
> Don't you still have to account for the changed header length if the
> second one fails or something?
>

That has been fixed by Sara's patch since now we add the pad directly
on the head of the
subsequent subframes (not to the tail of the first one). Am I missing something?

Regards,
Lorenzo

> You said you wanted to account for the pad bytes - which now aren't
> there - but didn't that also take the changed header of the first
> subframe into account?
>
> johannes
