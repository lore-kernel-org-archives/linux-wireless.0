Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:14972 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047AbZGOPO0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 11:14:26 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2009 08:14:26 -0700
Date: Wed, 15 Jul 2009 08:14:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [PATCH 3/5] cfg80211: add WoW support
Message-ID: <20090715151425.GC5682@mosca>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
 <1247617320-20163-4-git-send-email-lrodriguez@atheros.com>
 <1247658322.2302.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1247658322.2302.1.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 15, 2009 at 04:45:22AM -0700, Johannes Berg wrote:
> On Tue, 2009-07-14 at 20:21 -0400, Luis R. Rodriguez wrote:
> 
> > +	/* Draw up a netlink message to send back */
> > +	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> > +	if (!msg) {
> 
> Need to use DEFAULT_SIZE or something.

Will change it, thanks. I see NLMSG_DEFAULT_SIZE is smaller than
NLMSG_GOODSIZE (it removes the NLMSG_HDRLEN), but no documentation
for either, when should I use either?

> > +	if (!(wiphy->wow_triggers_supported & triggers_requested)) {
> > +		err = -EOPNOTSUPP;
> > +		goto out;
> 
> This seems wrong, should be "requested & supported != requested", I
> think.

The above one won't return -EOPNOTSUPP when you add additional junk, you're
right, better to just inform userspace of that.

> > @@ -4253,6 +4359,16 @@ static struct genl_ops nl80211_ops[] = {
> >  	{
> >  		.cmd = NL80211_CMD_DISCONNECT,
> >  		.doit = nl80211_disconnect,
> > +	},
> > +	{
> > +		.cmd = NL80211_CMD_GET_WOW,
> > +		.doit = nl80211_get_wow,
> > +		.policy = nl80211_policy,
> > +		/* can be retrieved by unprivileged users */
> > +	},
> > +	{
> > +		.cmd = NL80211_CMD_SET_WOW,
> > +		.doit = nl80211_set_wow,
> >  		.policy = nl80211_policy,
> >  		.flags = GENL_ADMIN_PERM,
> >  	},
> 
> This messes up the disconnect command.

Must have been a rebase issue, strange, thanks, will fix up.

  Luis
