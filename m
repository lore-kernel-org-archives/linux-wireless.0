Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55313 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2ADLGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 06:06:06 -0500
Subject: Re: [PATCH] mac80211: station state transition error handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAB3XZEfABhPBjD4sL369ziK8gRhuvWjHYRzM=Fxp0t=q_Ekzcg@mail.gmail.com> (sfid-20120104_120105_033366_BAA46512)
References: <1325672933.3339.17.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfABhPBjD4sL369ziK8gRhuvWjHYRzM=Fxp0t=q_Ekzcg@mail.gmail.com>
	 (sfid-20120104_120105_033366_BAA46512)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 12:06:01 +0100
Message-ID: <1325675161.3339.29.camel@jlt3.sipsolutions.net> (sfid-20120104_120610_814254_FF91E83B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-04 at 13:00 +0200, Eliad Peller wrote:

> > +       if (err) {
> > +               printk(KERN_DEBUG
> > +                      "%s: failed to move station %pM to desired state\n",
> > +                      sdata->name, sta->sta.addr);
> > +               sta_info_destroy_addr(sdata, sta->sta.addr);
> > +               mutex_unlock(&sdata->local->sta_mtx);
> > +               return false;
> > +       }
> >
> sta_info_destroy_addr takes the mutex by itself, so i guess you should
> either release it before or call __sta_info_destroy directly?

Ouch, thanks. I guess the latter makes more sense, will send a v2.

johannes

