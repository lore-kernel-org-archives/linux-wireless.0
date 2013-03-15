Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56929 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3CPM5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 08:57:10 -0400
Message-ID: <1363362667.8656.31.camel@jlt4.sipsolutions.net> (sfid-20130316_135716_839833_CECA7D1B)
Subject: Re: [RFC] P2P find offload
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1628850.y8u4o7KRXH@lx-vladimir>
References: <3408094.SIuA27EmQ5@lx-vladimir>
	 <7076584.7eoLUXqF3A@lx-vladimir>
	 <1362650938.8694.21.camel@jlt4.sipsolutions.net>
	 <1628850.y8u4o7KRXH@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Mar 2013 16:51:07 +0100
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 16:10 +0200, Vladimir Kondratiev wrote:

> > > +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> > > +	if (!msg)
> > > +		return -ENOMEM;
> > > +
> > > +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> > > +			     NL80211_CMD_START_P2P_FIND);
> > 
> > Err? What's the value of sending a reply back here? It would seem maybe
> > appropriate to send one when it *actually* started, but you haven't
> > implemented that.
> > 
> > > +	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
> > > +			     NL80211_CMD_STOP_P2P_FIND);
> > 
> > same here ...
> Yes, agree. I'll add indications, like ROC do.

Is there really much value in indications, rather than having it start
right away? Similarly, in particular if sending probe responses is
offloaded, is there really any reason for userspace to care? OTOH, we
also send an indication when a scan starts, so maybe it's useful that
way. Just seems that the code requesting this would assume that if it
didn't get an error, it will be started, and not really care about when
it *really* started operating.

johannes

