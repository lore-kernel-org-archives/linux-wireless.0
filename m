Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:36712 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbeH3McU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 08:32:20 -0400
Received: by mail-wm0-f54.google.com with SMTP id j192-v6so1090134wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Aug 2018 01:31:19 -0700 (PDT)
Date: Thu, 30 Aug 2018 10:31:16 +0200
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is set
 to one
Message-ID: <20180830083115.GA9867@localhost.localdomain> (sfid-20180830_103122_416814_16996C82)
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
 <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
 <1535569548.5215.33.camel@sipsolutions.net>
 <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
 <1535570007.5215.34.camel@sipsolutions.net>
 <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
 <1535616192.5215.37.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1535616192.5215.37.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> First of all, I applied your patch with now, but changed the commit
> message. I hope it still makes sense.

Thx, definitely better than mine :)

> 
> > Ops, maybe I got your point:
> > ieee80211_amsdu_realloc_pad() in ieee80211_amsdu_prepare_head() can
> > expand the headroom on the first frame
> 
> Right.
> 
> > but if ieee80211_amsdu_realloc_pad() on the second one fails, we do
> > not take into account the extra len added on the
> > first subframe. Is that what you mean?
> 
> Yes, that's what I was thinking of, but you described it much better
> than me :)
> 
> If this needs to be addressed, please send a separate patch.

Reviewing the code I guess it is not necessary since pskb_expand_head routine
does not modify head->len (or skb->len). Packet len (if we consider padding)
is only modified in:

memset(skb_push(skb, pad), 0, pad);

and if we hit that point, we will account new skb->len in flow backlog. Do you
agree?

Looking at the code maybe I spotted another issue, I guess there is an
off-by-one issue in 'n' estimation since it does not take into account
the first frame. We hit the line:

while (*frag_tail) {
}

starting from the second subframe, but if the head does not have packet in the
fraglist we will end up having n = 1, while it is actually the second frame.
Does n count just subsequent frames or also the first one?

Regards,
Lorenzo

> 
> johannes
