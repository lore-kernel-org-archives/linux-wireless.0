Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56118 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1IHOmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Sep 2011 10:42:25 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4E68D3BF.5090201@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
	 <1315464556.3948.0.camel@jlt3.sipsolutions.net>  <4E688321.7090704@ti.com>
	 <1315474047.7091.1.camel@jlt3.sipsolutions.net>  <4E68D3BF.5090201@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 08 Sep 2011 16:42:21 +0200
Message-ID: <1315492941.16729.12.camel@jlt3.sipsolutions.net> (sfid-20110908_164231_944396_5180F949)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-08 at 17:39 +0300, Victor Goldenshtein wrote:

> > No, I don't think you can advertise wiphy.flags since those flags are
> > internal -- you'll have to map single wiphy flags to single capability
> > flags which are also defined in nl80211.h.
> >
> > I'd call it "NL80211_ATTR_CAPABILITIES" to sidestep the issue of it
> > being a driver of HW or whatever capability.

> Sorry, I'm not sure that I'm entirely understand, you mean to create 
> *nested* "NL80211_ATTR_CAPABILITIES" attribute which will contain all 
> new capability flags, mapped from wiphy.flags? and to do it within 
> existing nl80211_send_wiphy() function?

No, I mean just add a U32 NL80211_ATTR_CAPABILITIES and put new flags
there, like this in nl80211.h:

enum nl80211_device_capabilities {
	NL80211_DEV_CAPA_XXX	= (1<<0);
etc...
};

Just don't use wiphy.flags directly since that's internal flags.

johannes

