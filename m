Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:56921 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbXLXIxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 03:53:35 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1712273fkz.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Dec 2007 00:53:34 -0800 (PST)
Message-ID: <c85cb4470712240053o7a7cdeb3y1a68cd1cca5361fc@mail.gmail.com> (sfid-20071224_085343_422615_551784EF)
Date: Mon, 24 Dec 2007 10:53:33 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/8 v2] mac80211: A-MPDU Rx adding basic functionality
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1198161675.16241.53.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
	 <11981435612196-git-send-email-ron.rindjunsky@intel.com>
	 <1198161675.16241.53.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> A few minor comments, looks good otherwise.
>
> >       status = WLAN_STATUS_REQUEST_DECLINED;
> >
> > +
>
> spurious newline added, I'd think.

will do

>
> > +     /* prepare reordering buffer */
> > +     tid_agg_rx->reorder_buf =
> > +             kmalloc(buf_size * sizeof(struct sk_buf *), GFP_ATOMIC);
> > +     if (!tid_agg_rx->reorder_buf) {
> > +             printk(KERN_ERR "can not allocate reordering buffer "
> > +                                             "to tid %d\n", tid);
>
> Should that be ratelimited just in case somebody is trying over and over
> again while we're under memory pressure?
>

done

> > +     skb = dev_alloc_skb(sizeof(*mgmt) + local->hw.extra_tx_headroom + 1 +
> > +                                     sizeof(mgmt->u.action.u.delba));
>
> What's "+ 1"?

that's for the category byte. in fact i think that the problem is not
here, but in a wrong allocation size in send_addba_resp that i will
fix.

>
> > +                     printk(KERN_DEBUG "rx BA session requested to stop on "
> > +                             "unactive tid %d\n", tid);
>
> typo: "inactive"

thanks

>
> > +     sta = sta_info_get(local, temp_sta->addr);
> > +
> > +     if (!sta)
> > +             return;
>
> Still have that?
>

i have cleaned it now, thatnks.

> Thanks,
> johannes
>
>
