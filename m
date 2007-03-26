Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40054
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXCZUkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 16:40:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] zd1211rw-mac80211: Fix for monitor mode bug
Date: Mon, 26 Mar 2007 22:39:06 +0200
Cc: Andy Green <andy@warmcat.com>, Jiri Benc <jbenc@suse.cz>,
	Daniel Drake <dsd@gentoo.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
References: <20070325231817.9C5887B409F@zog.reactivated.net> <200703261328.28156.mb@bu3sch.de> <1174908666.1536.15.camel@johannes.berg>
In-Reply-To: <1174908666.1536.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703262239.07013.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 March 2007 13:31, Johannes Berg wrote:
> On Mon, 2007-03-26 at 13:28 +0200, Michael Buesch wrote:
> 
> > We currently have two module parameters in bcm43xx-mac80211 for this:
> > 
> > static int modparam_mon_keep_bad;
> > module_param_named(mon_keep_bad, modparam_mon_keep_bad, int, 0444);
> > MODULE_PARM_DESC(mon_keep_bad, "Keep bad frames in monitor mode");
> > 
> > static int modparam_mon_keep_badplcp;
> > module_param_named(mon_keep_badplcp, modparam_mon_keep_bad, int, 0444);
> > MODULE_PARM_DESC(mon_keep_badplcp, "Keep frames with bad PLCP in monitor mode");
> 
> Out of curiosity, doesn't that break things when you have both a monitor
> and a non-monitor interface [1]? Or do you just disable it then?
> 
> johannes
> 
> [1] I think that mac80211 assumes CRC checks have passed, no?

Well, yeah. It does of course. If you have a STA and a MON interface,
the STA also receives the packs with bad CRCs. But that's how
mac80211 designed the virt-interface stuff.
Same goes for promisc. If you have a STA and a MON you can't have
the STA in non-promisc mode, so you also receive promisc packets on
the STA. That's how it's supposed to be. (I think mac80211 filters
them in the STA code somewhere).

The modparams actually are just a temporary hack and were never meant
to stay there. I wanted to have the knob in cfg80211, sooner or later.
So when the knob is there, mac80211 should take care that the STA
doesn't receive the bad packets.

-- 
Greetings Michael.
