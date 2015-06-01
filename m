Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59241 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbbFAOk7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 10:40:59 -0400
Message-ID: <1433169656.3505.13.camel@sipsolutions.net> (sfid-20150601_164103_415088_4C61CBCA)
Subject: Re: [PATCH] mac80211: Fix double locking on CSA counter update
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 01 Jun 2015 16:40:56 +0200
In-Reply-To: <556C6AEB.9070407@neratec.com> (sfid-20150601_162345_309420_15E143F0)
References: <1433166856-3285-1-git-send-email-Wojciech.Dubowik@neratec.com>
	 <CAGRGNgW=qy2TuojGt5CDE0sATkKeMTHCtBJnFQOjJ=3pP7Kzzw@mail.gmail.com>
	 <556C6AEB.9070407@neratec.com> (sfid-20150601_162345_309420_15E143F0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-06-01 at 16:23 +0200, Wojciech Dubowik wrote:
> On 01/06/15 16:13, Julian Calaby wrote:
> > Hi Wojciech,
> >
> > On Mon, Jun 1, 2015 at 11:54 PM, Wojciech Dubowik
> > <Wojciech.Dubowik@neratec.com> wrote:
> >> We call rcu locked ieee80211_csa_update_counter from
> >> already locked section. Fix it by decrementing counter
> >> directly instead of calling ieee80211_csa_update_counter.
> > Stupid question: wouldn't it be better to split the work from
> > ieee80211_csa_update_counter() into a separate function without
> > locking and call that instead?
> Yes. It would be better for maintenance. It's just that they will
> have different input parameters
> 
> ieee80211_csa_update_counter(struct ieee80211_vif *
> __ieee80211_csa_update_counter(struct beacon_data *
> 
> as it doesn't make sense to dereference beacon twice.
> 
> I guess it's not a problem?

Seems fine to me.

johannes

