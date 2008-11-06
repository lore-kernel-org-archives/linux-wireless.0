Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57877 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbYKFCeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Nov 2008 21:34:17 -0500
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
	vif are configured
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1225884472.3619.72.camel@johannes.berg>
References: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
	 <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
	 <20081105000900.GA10671@mail.intel.com>
	 <1225884472.3619.72.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 10:34:54 +0800
Message-Id: <1225938894.2604.140.camel@debian.sh.intel.com> (sfid-20081106_033422_328679_146DFCAD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 19:27 +0800, Johannes Berg wrote:
> > > This example is not correct, mac80211 will only support multiple virtual
> > > interfaces when the driver allows this via add_interface (which I don't
> > > think yours does) and it will *never* tell you about monitor interfaces at
> > > all except by way of configuring the filter differently.
> > 
> > We do support add_interface in iwlagn. But it works correctly only if
> > the second one is a monitor interface.
> 
> But like I said, add_interface is _never_ called with _MONITOR.

I'm confused. We do hook up in the configure_filter handler to set up
the monitor. I assume you did read our code in iwl-agn.c. No?

> > > Therefore, all the "is monitor" checks in iwlwifi are pretty pointless
> > > unless you really want to have differing behaviour between "monitor +
> > > something" and "just monitor"?
> > 
> > In case of BSS + monitor, we need to tell firmware about the
> > association status. This differs with pure montior mode.
> 
> You can only distinguish those by the filter flags, and should probably
> base the firmware knowledge on that. We want to be able to pull up
> "plain" monitor interfaces w/o any special flags that show things
> exactly as they'd go to mac80211 if the monitor interface was not
> present. I suspect you should look at the FIF_OTHER_BSS flag?

We do handle FIF_OTHER_BSS in configure_filter. Please take a look at it
and let me know if anything is wrong.

Thanks,
-yi

