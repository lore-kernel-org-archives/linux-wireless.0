Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57035 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab0FIJgY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 05:36:24 -0400
Subject: Re: [PATCHv3] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>
In-Reply-To: <1276074538.5277.33049.camel@wimaxnb.nmp.nokia.com>
References: <1276066224-17880-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276068754.3727.0.camel@jlt3.sipsolutions.net>
	 <1276073421.5277.33026.camel@wimaxnb.nmp.nokia.com>
	 <1276073670.3727.12.camel@jlt3.sipsolutions.net>
	 <1276074538.5277.33049.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 11:36:16 +0200
Message-ID: <1276076176.3727.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 12:08 +0300, Juuso Oikarinen wrote:
> > However I'm a bit worried that making this workqueue change will allow
> > the filter reconfigure to cross with suspend, which might mean it could
> > execute after the device is suspended?
> 
> Ah yes. That's an obvious side-effect. I wonder if it would be solved by
> flushing this particular work along with the mac80211 wq in the suspend
> call, or would the implications then just move further?

But that's under rtnl.

> Apart from the above, I'm out of ideas. If this is getting too complex,
> I'll need to revert back to the patch that does not take into account
> the promisc mode.

probably the best choice for now at least

johannes

