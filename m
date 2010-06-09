Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0FIHhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 03:37:00 -0400
Subject: Re: [RFC 3/3] mac80211: Store basic rates for bss when joining
 ibss network
From: Johannes Berg <johannes@sipsolutions.net>
To: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1276058714.495.35.camel@paavo-desktop>
References: <1276000459-1121-1-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-2-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-3-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276000459-1121-4-git-send-email-ext-teemu.3.paasikivi@nokia.com>
	 <1276001318.3706.130.camel@jlt3.sipsolutions.net>
	 <1276058714.495.35.camel@paavo-desktop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 09:36:56 +0200
Message-ID: <1276069016.3727.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 07:45 +0300, Teemu Paasikivi wrote:

> > However this kinda confuses me.
> > 
> > We had a long-standing TODO item on our list at
> > http://wireless.kernel.org/en/developers/todo-list
> > 
> > "when leaving an IBSS and we were the only member, remove it from
> > cfg80211's BSS list"
> > 
> > Maybe that would help here too?
> > 
> 
> Yes, I think that would propably solve that issue where IBSS was
> recreated and requested basic rates are changed.

Want to take a look at it? It shouldn't be too hard -- just call
cfg80211_unlink_bss() somewhere where we still have the BSS pointer.
Actually we don't keep it as you saw with the update, so need to find it
first and then unlink it.

> > However I don't understand the scenario anyway. If you create an IBSS,
> > you start beaconing and tell cfg80211 about it with a frame that
> > includes the supported and basic rates. Then you leave, but the BSS
> > stays around in cfg80211 for 15 seconds. If you re-join within those 15
> > seconds, the scan results will pick up the old IBSS that no longer
> > exists, and we "join" it rather than creating it.
> > 
> > However -- joining it will take the basic rates from it. So wouldn't you
> > get the old basic rates which is fine? What do you mean by "left unset"?
> > 
> 
> By "left unset" I mean that in the sniffer logs there's no rates marked
> as basic rates in the beacons. No old ones or new ones.

Ok that's what I thought. But ... are they marked in our TX beacons when
we _first_ created the IBSS?

> > What happens if you join an IBSS that already exists?
> > 
> 
> It works, but I haven't captured what's in the air. That's one reason
> why I sent these patches as RFC.

I don't really see how the two scenarios differ, so that's odd...

johannes

