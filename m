Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:51016 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727626AbeH3MEQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 Aug 2018 08:04:16 -0400
Message-ID: <1535616192.5215.37.camel@sipsolutions.net> (sfid-20180830_100343_738079_6D1198D1)
Subject: Re: [PATCH v2] mac80211: do not aggregate frames if max_frags is
 set to one
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 30 Aug 2018 10:03:12 +0200
In-Reply-To: <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com> (sfid-20180829_213100_455683_8CE20018)
References: <cover.1535567864.git.lorenzo.bianconi@redhat.com>
         <d016cad18842b71c6f06710cbc71cb3d55466a2e.1535567864.git.lorenzo.bianconi@redhat.com>
         <1535569548.5215.33.camel@sipsolutions.net>
         <CAJ0CqmVv=FYEb1ARMvoUZHbwCUtAxuO6-c6U-nvi+c-s_63C-Q@mail.gmail.com>
         <1535570007.5215.34.camel@sipsolutions.net>
         <CAJ0CqmWVi2QiP=V3i+_6Gxz18muyOD2+FiFrx=OJgK2CHcdM3Q@mail.gmail.com>
         (sfid-20180829_213100_455683_8CE20018)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all, I applied your patch with now, but changed the commit
message. I hope it still makes sense.

> Ops, maybe I got your point:
> ieee80211_amsdu_realloc_pad() in ieee80211_amsdu_prepare_head() can
> expand the headroom on the first frame

Right.

> but if ieee80211_amsdu_realloc_pad() on the second one fails, we do
> not take into account the extra len added on the
> first subframe. Is that what you mean?

Yes, that's what I was thinking of, but you described it much better
than me :)

If this needs to be addressed, please send a separate patch.

johannes
