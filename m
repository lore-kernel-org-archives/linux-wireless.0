Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:19781 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab2FNTbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 15:31:10 -0400
Date: Thu, 14 Jun 2012 12:31:04 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	Arend van Spriel <arend@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <me@bobcopeland.com>,
	<mickflemm@gmail.com>
Subject: Re: [RFC 0/3] wireless: add CONFIG_CFG80211_EXPERT
Message-ID: <20120614193104.GD32257@tux> (sfid-20120614_213114_722184_940B5C72)
References: <1339203070-17979-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1339228530.4539.0.camel@jlt3.sipsolutions.net>
 <4FD3A936.8070600@broadcom.com>
 <1339399952.4520.13.camel@jlt3.sipsolutions.net>
 <4FD60369.80108@qca.qualcomm.com>
 <1339425944.4520.27.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339425944.4520.27.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2012 at 04:45:44PM +0200, Johannes Berg wrote:
> On Mon, 2012-06-11 at 17:40 +0300, Kalle Valo wrote:
> 
> > > I still don't see the need. What would you put under it in
> > > brcm[sf]mac? I certainly wouldn't see any reason to put anything
> > > under it in our driver since it's much simpler to .
> > 
> > Looks like something is missing here?
> 
> Sorry, yeah,  Iwas going to say it's simpler to put something under the
> driver's Kconfig.
> 
> > > Also, the argument about distros doesn't really work that way, if
> > > there are users interested in something then the distros will
> > > certainly enable this (CFG80211_EXPERT) option to get something
> > > hidden behind it.
> > 
> > I would compare this with NL80211_TESTMODE, we don't want distributions
> > to enable that either. Of course nothing prevents distros to enable
> > CFG80211_EXPERT but we need to be active to make sure it's not enabled
> > (ie. check the distro configs and file bugs etc).
> 
> Right, but that's actually a feature. I see little value in a pretty
> much meaningless "EXPERT wireless" Kconfig symbol that only groups
> others. If, as Arend suggested, it actually has some meaning, then it
> may make more sense.

This option should really be used by OEM/ODM that have assured proper
certification or scientists using a shielded room. Distros should be strongly
adviced not to use this as their users tend to be unaware or the distribution
ODM / OEM may not have done the necessary work to ensure proper regulatory
certification. Perhaps we can clarify that there is a heavier onus on
regulatory certification if these options are enabled. Linux distributions may
be eager to please their users, but I would expect them to have common sense as
well. We would just have to educate them about this option.

As for a name, I thought about it for a while and given that we have different
"wireless" technologies -- bluetooth, NFC, naming this CONFIG_WIRELESS_EXPERT
seemed odd, and given that our 802.11 framework is under cfg80211 naming it
CONFIG_CFG80211_EXPERT seemed appropriate. But even if its under cfg80211
perhaps something more explicit about the implications may be better, how
about CONFIG_CFG80211_MAY_BREAK_CERTIFICATION ?

  Luis
