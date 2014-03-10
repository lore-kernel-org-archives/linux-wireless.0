Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:55403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaCJUa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2014 16:30:26 -0400
Message-ID: <1394483382.30155.2.camel@jlt4.sipsolutions.net> (sfid-20140310_213037_409626_2AAE7ADE)
Subject: Re: [PATCH 1/3] mac80211: fix racy usage of chanctx->refcount
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 10 Mar 2014 22:29:42 +0200
In-Reply-To: <CAB3XZEek76hKh_5nqOs66DgFHT9iki17rZD8EqJnccQty4FdeQ@mail.gmail.com> (sfid-20140309_104027_325761_F4E44E1B)
References: <1394191196-6425-1-git-send-email-michal.kazior@tieto.com>
	 <CAB3XZEek76hKh_5nqOs66DgFHT9iki17rZD8EqJnccQty4FdeQ@mail.gmail.com>
	 (sfid-20140309_104027_325761_F4E44E1B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-03-09 at 11:40 +0200, Eliad Peller wrote:

> > @@ -3233,23 +3233,23 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
> >                                        &sdata->vif.bss_conf.chandef))
> >                 return -EINVAL;
> >
> > -       rcu_read_lock();
> > +       mutex_lock(&local->chanctx_mtx);
> >         chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
> this should probably be rcu_dereference_protected now?

Yes, in fact, lockdep ought to warn about this usage now, please enable
it :)

johannes

