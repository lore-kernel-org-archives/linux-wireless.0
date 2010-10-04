Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45790 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0JDSA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 14:00:56 -0400
Received: by bwz11 with SMTP id 11so3820925bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 11:00:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: lockdep warning in ieee80211 rx path
Date: Mon, 4 Oct 2010 20:00:44 +0200
Cc: Ming Lei <tom.leiming@gmail.com>, linux-wireless@vger.kernel.org
References: <AANLkTin5KfmQLYxLWdhTcO-AM0t83dVq=LFCG0UGysaw@mail.gmail.com> <201009142251.53021.chunkeey@googlemail.com> <4CAA144C.7040906@candelatech.com>
In-Reply-To: <4CAA144C.7040906@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010042000.44518.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 04 October 2010 19:52:12 Ben Greear wrote:
> On 09/14/2010 01:51 PM, Christian Lamparter wrote:
> > On Sunday 05 September 2010 11:32:26 Ming Lei wrote:
> >> Seems the warning does not affect use of wireless,  false positive?
> >
> > No, it's a bug... but please read&  test the attached patch.
> 
> This is not yet in wireless-testing.  Should it be?
have you heard anything from Ming Lei about this subject?
Or have you reproduced the bug too?

> > ---
> > [PATCH] mac80211: hoist sta->lock from reorder release timer
> >
> > The patch "mac80211: AMPDU rx reorder timeout timer" clashes
> > with "mac80211: use netif_receive_skb in ieee80211_rx callpath"
> >
> > The timer itself is part of the station's private struct and
> > it gets killed whenever the station is removed. Therefore
> > the extra sta->lock protection (that can interferes with the
> > tx path) is not necessary.
> >
> > Reported-by: Ming Lei<tom.leiming@gmail.com>
> > Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> > ---
> > diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> > index 58eab9e..309ed70 100644
> > --- a/net/mac80211/agg-rx.c
> > +++ b/net/mac80211/agg-rx.c
> > @@ -129,9 +129,7 @@ static void sta_rx_agg_reorder_timer_expired(unsigned long data)
> >   			timer_to_tid[0]);
> >
> >   	rcu_read_lock();
> > -	spin_lock(&sta->lock);
> >   	ieee80211_release_reorder_timeout(sta, *ptid);
> > -	spin_unlock(&sta->lock);
> >   	rcu_read_unlock();
> >   }
> >
> > --

