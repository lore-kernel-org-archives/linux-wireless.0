Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51917 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838Ab2DCMeo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 08:34:44 -0400
Message-ID: <1333456480.3574.16.camel@jlt3.sipsolutions.net> (sfid-20120403_143448_051237_7869D770)
Subject: Re: [PATCH 1/2] mac80211: add explicit monitor interface if needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 03 Apr 2012 14:34:40 +0200
In-Reply-To: <CAB3XZEfmBT724sP_3=pmBQixy1eW_x7V9_jsJi0cmWHJvogfVg@mail.gmail.com> (sfid-20120403_142254_537328_9F55F074)
References: <20120403082416.559209159@sipsolutions.net>
	 <1333441758.3574.3.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfmBT724sP_3=pmBQixy1eW_x7V9_jsJi0cmWHJvogfVg@mail.gmail.com>
	 (sfid-20120403_142254_537328_9F55F074)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 15:22 +0300, Eliad Peller wrote:

> > @@ -266,6 +319,12 @@ static int ieee80211_do_open(struct net_
> >                        break;
> >                }
> >
> > +               if (local->monitors == 0 && local->open_count == 0) {
> > +                       res = ieee80211_add_virtual_monitor(local);
> > +                       if (res)
> > +                               return res;
> 
> you probably have to goto instead (to clean up properly - drv_stop etc.).

Hm, good catch, this is a bit confusing. I'll do that, and then post
another patch to clean up the error paths a bit.

johannes

