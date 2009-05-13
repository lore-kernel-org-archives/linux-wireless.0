Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21029 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbZEMSOt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 14:14:49 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2009 11:14:51 -0700
Date: Wed, 13 May 2009 11:14:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 3/5] cfg80211: add WoW support
Message-ID: <20090513181458.GB19693@tesla>
References: <1242206461-30793-1-git-send-email-lrodriguez@atheros.com> <1242206461-30793-4-git-send-email-lrodriguez@atheros.com> <1242208515.29288.0.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1242208515.29288.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 13, 2009 at 02:55:15AM -0700, Johannes Berg wrote:
> On Wed, 2009-05-13 at 05:20 -0400, Luis R. Rodriguez wrote:
> 
> > +/**
> > + * enum nl80211_wow_triggers - Wake-on-Wireless-LAN triggers
> > + *
> > + * NL80211_WOW_TRIGGER_MAGIC_PACKET: a wake signal will be sent to the
> > + *     devices if a magic packet is received.
> > + * NL80211_WOW_TRIGGER_BMISS: WoW signal will be sent to the device when
> > + *     a beacon has been missed by the associated AP.
> > + * NL80211_WOW_TRIGGER_LINK_CHANGE: a wake signal will be sent to
> > + *     the device if a link change is detected on the device.
> > + * NL80211_WOW_TRIGGER_USER_PATTERN: a wake sigal will be sent to the
> > + *     device if a user configurable pattern is received by
> > + *     the device.
> > + */
> > +enum nl80211_wow_triggers {
> > +	NL80211_WOW_TRIGGER_MAGIC_PACKET	= 1 << 0,
> > +	NL80211_WOW_TRIGGER_BMISS		= 1 << 1,
> > +	NL80211_WOW_TRIGGER_LINK_CHANGE		= 1 << 2,
> > +	NL80211_WOW_TRIGGER_PATTERN		= 1 << 3,
> > +};
> 
> Seems like you need to have a way to set the pattern and magic packet?

Yeah TDB -- the code for that is a bit complex and I don't understand how
things are being broken down yet. We could just not have the cabability
present until that's properly figured out.

  Luis
