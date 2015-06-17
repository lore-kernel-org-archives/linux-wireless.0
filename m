Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37901 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753424AbbFQLff (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 07:35:35 -0400
Received: by igblz2 with SMTP id lz2so34471222igb.1
        for <linux-wireless@vger.kernel.org>; Wed, 17 Jun 2015 04:35:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434538909.1884.39.camel@sipsolutions.net>
References: <1433943751-11221-1-git-send-email-chaitanya.mgit@gmail.com>
 <1434530870.1884.12.camel@sipsolutions.net> <CABPxzYL0rnht72K1fLcpyjC=eOM4nHxzHQRpD47iE6J=J-3sOg@mail.gmail.com>
 <1434538909.1884.39.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 17 Jun 2015 17:05:14 +0530
Message-ID: <CABPxzY+Nz+wOCtot-4ROZJ6SR-a1gV625ak8qmLHtjvR=JadGQ@mail.gmail.com> (sfid-20150617_133539_486694_66E6B15D)
Subject: Re: [PATCH V3] mac80211: wowlan: suspend: Fix power save state stuck
 in ACTIVE caused by race between suspend and Tx packet.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 4:31 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2015-06-17 at 15:52 +0530, Krishna Chaitanya wrote:
>
>> > I still don't like it. I also don't believe that what you're writing is
>> > actually true. The only problem I can see is that it leads to higher
>> > power consumption *while the system is suspended* - at resume time we
>> > send a packet and thus kick the timers...
>> "If" we send a packet, but until them the system will still be
>> active.
>
> But we *always* send a packet:
>
> ieee80211_reconfig:
> ...
>         /*
>          * The sta might be in psm against the ap (e.g. because
>          * this was the state before a hw restart), so we
>          * explicitly send a null packet in order to make sure
>          * it'll sync against the ap (and get out of psm).
>          */
>         if (!(local->hw.conf.flags & IEEE80211_CONF_PS)) {
>                 list_for_each_entry(sdata, &local->interfaces, list) {
>                         if (sdata->vif.type != NL80211_IFTYPE_STATION)
>                                 continue;
>                         if (!sdata->u.mgd.associated)
>                                 continue;
>
>                         ieee80211_send_nullfunc(local, sdata, 0);
>                 }
>         }
>
>
>
> Then again, you're talking about WoWLAN, but then ...
In wowlan, we simply call drv_resume and only if it fails
then we will go through full resume. And without wowlan
connection will not be there so this code will not be hit.
