Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46277 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab2C3GjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 02:39:17 -0400
Message-ID: <1333089555.3908.0.camel@jlt3.sipsolutions.net> (sfid-20120330_083937_807379_7F4DEADD)
Subject: Re: [RFC 1/2] mac80211: add explicit monitor interface if needed
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 30 Mar 2012 08:39:15 +0200
In-Reply-To: <CAB3XZEdx6=58pyiEFWAiLGvtJ9eSTacyKD3Y-jKaR-7iDrF3zg@mail.gmail.com> (sfid-20120329_220943_880343_818A1AF7)
References: <20120328091346.442543219@sipsolutions.net>
	 <20120328091811.108837459@sipsolutions.net>
	 <CAB3XZEdx6=58pyiEFWAiLGvtJ9eSTacyKD3Y-jKaR-7iDrF3zg@mail.gmail.com>
	 (sfid-20120329_220943_880343_818A1AF7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-03-29 at 22:09 +0200, Eliad Peller wrote:

> > +       if (WARN_ON(!sdata))
> > +               return;
> > +
> ...
> 
> > @@ -280,6 +339,8 @@ static int ieee80211_do_open(struct net_
> >                break;
> >        default:
> >                if (coming_up) {
> > +                       ieee80211_del_virtual_monitor(local);
> > +
> 
> i think this will always trigger the warning?

Yeah, somehow I didn't see this in my first round of testing. I
distinctly remember thinking "I need to remove the warning then" but
clearly never did :-)

> > -       if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> > -                   sdata->vif.type == NL80211_IFTYPE_MONITOR))
> > +       if (WARN_ON(sdata->vif.type == NL80211_IFTYPE_AP_VLAN))
> >                return -EINVAL;
> >
> maybe check for IEEE80211_HW_WANT_MONITOR_VIF instead?

Good point, should do that.

johannes

