Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab2FYPsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 11:48:20 -0400
Message-ID: <1340639295.27437.7.camel@jlt3.sipsolutions.net> (sfid-20120625_174823_715597_EB6EEC82)
Subject: Re: [RFC 15/17] cfg80211: add P2P Device abstraction
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 25 Jun 2012 17:48:15 +0200
In-Reply-To: <CAB3XZEcWE46OHiigB24ezaDA3rRUYoKGtYcmvVxVgMizVK+d8w@mail.gmail.com> (sfid-20120625_172048_566221_C9431BD2)
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
	 <1340117456-10154-16-git-send-email-johannes@sipsolutions.net>
	 <CAB3XZEcWE46OHiigB24ezaDA3rRUYoKGtYcmvVxVgMizVK+d8w@mail.gmail.com>
	 (sfid-20120625_172048_566221_C9431BD2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-06-25 at 18:20 +0300, Eliad Peller wrote:

> > +void cfg80211_unregister_wdev(struct wireless_dev *wdev)

> > +       case NL80211_IFTYPE_P2P_DEVICE:
> > +               if (wdev->p2p_started) {
> > +                       wdev->p2p_started = false;
> > +                       rdev->opencount--;
> > +               }
> any reason not calling stop_p2p_device() here as well?

That would be circular? You're supposed to call this when
stop_p2p_device() gets called, or when you need to delete it for some
other reason, usually device unplug or such.


> > +static int nl80211_start_p2p_device(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
> > +       struct wireless_dev *wdev = info->user_ptr[1];
> > +       int err;
> > +
> > +       if (!rdev->ops->start_p2p_device)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (wdev->iftype != NL80211_IFTYPE_P2P_DEVICE)
> > +               return -EOPNOTSUPP;
> > +
> > +       if (!(rdev->wiphy.interface_modes & BIT(NL80211_IFTYPE_P2P_DEVICE)))
> > +               return -EOPNOTSUPP;
> > +
> nl80211_new_interface() should already check it.

Good point. I'll remove this check.

johannes

