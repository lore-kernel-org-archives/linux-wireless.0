Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0FIIyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 04:54:38 -0400
Subject: Re: [PATCHv3] mac80211: Fix circular locking dependency in ARP
 filter handling
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"reinette.chatre@intel.com" <reinette.chatre@intel.com>
In-Reply-To: <1276073421.5277.33026.camel@wimaxnb.nmp.nokia.com>
References: <1276066224-17880-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1276068754.3727.0.camel@jlt3.sipsolutions.net>
	 <1276073421.5277.33026.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Jun 2010 10:54:30 +0200
Message-ID: <1276073670.3727.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-06-09 at 11:50 +0300, Juuso Oikarinen wrote:
> On Wed, 2010-06-09 at 09:32 +0200, ext Johannes Berg wrote:
> > On Wed, 2010-06-09 at 09:50 +0300, Juuso Oikarinen wrote:
> > 
> > > v3: - queue reconfig filter work to kernel default wq instead of mac80211 wq
> > 
> > I think it would make more sense to use a different lock instead, like
> > the iflist mutex?
> 
> Yeah had that originally, but apparently the iflist mutex is acquired
> *after* the mgd mutex in some places of the code, especially all around
> mlme.c, and here I would have to acquire them in reverse order. So I
> changed to the rtnl lock.

Ah, right.

However I'm a bit worried that making this workqueue change will allow
the filter reconfigure to cross with suspend, which might mean it could
execute after the device is suspended?

johannes

