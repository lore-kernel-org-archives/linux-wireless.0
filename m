Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36653 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3CRUbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 16:31:41 -0400
Message-ID: <1363638685.8260.32.camel@jlt4.sipsolutions.net> (sfid-20130318_213144_864362_3B86D5DF)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 18 Mar 2013 21:31:25 +0100
In-Reply-To: <1958495.JVcc1yGep9@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <2799886.P5v870j3h2@lx-vladimir>
	 <1363372823.8656.41.camel@jlt4.sipsolutions.net>
	 <1958495.JVcc1yGep9@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-03-17 at 10:56 +0200, Vladimir Kondratiev wrote:

> > Why not just indicate the command presence rather than a feature flag?
> 
> I also thought this way, it was my impression you was asking for feature flag
> earlier:
> --cut--
> > You're also entirely missing feature advertising, so userspace can only
> > guess whether it's supported or not ...
> --cut--

Ah, well, I was asking that you advertise the feature, not necessarily
through a feature flag :-)

We advertise lots of features by having the CMD() thing in nl80211.c,
though I think we may have to change that now due to the the wiphy size
limit mess.

If mac80211 drivers support this we may need a wiphy flag that
influences the command presence though.

> For "progressive" P2P scan - do you mean normal scan or find phase? For normal
> scan, nothing changes and one can use any scan optimisations. For find phase -
> spec don't let you do so, it pretty much mandates what and when to do.

I was under the impression that wpa_s allowed "progressive" (i.e. one
non-social channel per iteration) even in find? I could be wrong though,
maybe only in search.

> > Is there really much value in indications, rather than having it start
> > right away? Similarly, in particular if sending probe responses is
> > offloaded, is there really any reason for userspace to care? OTOH, we
> > also send an indication when a scan starts, so maybe it's useful that
> > way. Just seems that the code requesting this would assume that if it
> > didn't get an error, it will be started, and not really care about when
> > it really started operating.
> 
> There are 2 points:
> 1) timing. For hardware, it may take time to really start find phase.
> For card I am working on now, 60G one, it tooks some 150ms.
> I suppose, upper layers may be confused with this delay.
> 2) hardware may decide to end find phase on its own, in this case 'end'
> notification is a must; it seems more consistent to provide both 'start'
> and 'end'.

Ok, fair enough. I guess we need to mandate that (unless the command
returned an error) userspace will at least get the "end" notification,
even if it never starts, so that it can safely wait for the end and
maybe ignore the start if it wants to. That does seem to be the case
already anyway.

> OK, will do it. Split this to 2 functions,
> cfg80211_p2p_find_notify_start() and cfg80211_p2p_find_notify_end(),
> yes?
> 
> Open question: can supplicant be interested in more details, like when
> 'search' started, and when 'listen' started for particular channel?

I doubt it.

> > >  /**

> > Also, this is probably *additional* IEs, i.e. supported rates etc. are
> > expected to be created by the driver?
> 
> In params for start_ap, it is called 'extra' IE's;
> I will call it the same here for consistency.

Ok, but can you also document what the driver should add? Supported
rates, HT info, ... presumably?

> > > +	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
> > > +				nl80211_scan_mcgrp.id, GFP_KERNEL);
> > 
> > indentation
> I double checked, identation seems OK. Checkpatch also fine.

Probably got messed up in email then.

> For trace.h, whole file uses one-tab identation after TRACE_EVENT
> or DEFINE_EVENT; yes it is not what checkpatch likes.
> But, should I follow the file style or properly indent my additions
> in non-consistent with the rest of file style?
> I left it with the same identation as the rest of file.

Please leave it consistent.

> +/**
> + * cfg80211_p2p_find_notify_end - report p2p find state ended
> + * @wdev: the wireless device reporting the event
> + * @gfp: allocation flags
> + *
> + * p2p find state may be ended either unsolicited or in response to
> + * @ops->p2p_stop_find

I think that @ might confuse the parser? I guess we'll find out when we
run it :-)

johannes

