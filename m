Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:53528 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbeH2Bet (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Aug 2018 21:34:49 -0400
Received: by mail-it0-f54.google.com with SMTP id p79-v6so4815014itp.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Aug 2018 14:41:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1535489707.git.lorenzo.bianconi@redhat.com>
 <d67c1a6772d46f449dbb74d61ddf4d80dee7a350.1535489707.git.lorenzo.bianconi@redhat.com>
 <1535490861.20033.8.camel@sipsolutions.net>
In-Reply-To: <1535490861.20033.8.camel@sipsolutions.net>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Tue, 28 Aug 2018 23:41:02 +0200
Message-ID: <CAJ0CqmWLw11bmofttBfJQmNkCVhz-N3K9ah2HJkTbjZ6EDf-Xg@mail.gmail.com> (sfid-20180828_234117_573058_1EEAEA03)
Subject: Re: [PATCH] mac80211: do not aggregate frames if max_frags is set to one
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, sara.sharon@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> On Tue, 2018-08-28 at 23:07 +0200, Lorenzo Bianconi wrote:
> > Do not try to aggregate packets in a A-MSDU frame if max_tx_fragments
> > or max_amsdu_subframes is set to 1.
>
> Yeah that seems valid.
>
> > Moreover take into account
> > tail padding added on the first frame into flow backlog if
> > ieee80211_amsdu_realloc_pad routine on the second frame fails.
>
> That's not really right - the padding shouldn't have been added to the
> first subframe in the first place as the last one shouldn't have padding
> at all. There's also a separate bug in that the A-MSDU subframe length
> should NOT include the padding.
>

Assuming the A-MSDU subframe is composed by two packets, the last one
must not contain padding, is my understanding correct?

> My colleague Sara (CC'ed now) has a patch to fix all of this (we just
> did that this morning). I'll send it out tomorrow morning. Can I bother
> you to try that?
>

Sure, no worries :)

> We'd have to fix the first point independently though, or I guess we can
> roll that into our bugfix too, which would you prefer?
>
> johannes
>

If the patch is already done I can add the fix for the first point on
top of it, does it sound good?

Regards,
Lorenzo
