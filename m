Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab0EZUnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 16:43:32 -0400
Subject: Re: [RFC] mac80211: sample survey implementation for mac80211
 &amp; hwsim
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org,
	Holger Schurig <holgerschurig@gmail.com>
In-Reply-To: <loom.20100422T100127-458@post.gmane.org>
References: <201004191023.57987.holgerschurig@gmail.com>
	 <loom.20100422T100127-458@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 May 2010 22:43:32 +0200
Message-ID: <1274906612.3658.58.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Holger,

> > +static int ieee80211_dump_survey(struct wiphy *wiphy, struct net_device *dev,
> > +				 int idx, struct survey_info *survey)
> > +{
> > +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> > +
> > +	if (!local->ops->get_survey)
> > +		return -EOPNOTSUPP;
> 
> The check for the function is duplicated in drv_get_survey. I think the
> wrapper should be called unconditionally.

Please address this comment and add tracing. Your patch was merged, so
that needs to be an add-on patch.

johannes

