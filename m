Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37818 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbZHUQpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 12:45:17 -0400
Date: Fri, 21 Aug 2009 12:43:35 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
	again
Message-ID: <20090821164335.GB8532@tuxdriver.com>
References: <4A8DC955.9060100@gmail.com> <1250872433.30019.14430.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1250872433.30019.14430.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 09:33:53AM -0700, reinette chatre wrote:
> Hi Gábor,
> 
> On Thu, 2009-08-20 at 15:08 -0700, Gábor Stefanik wrote:
> > Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
> > ("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
> > broke injection of non-broadcast frames to unassociated stations
> > (causing a SYSASSERT for all such injected frames), due to injected
> > frames no longer automatically getting a broadcast station ID assigned,
> > and instead ending up with invalid station IDs.
> > This patch restores the old behavior, fixing the aforementioned
> > regression.
> 
> The patch you are quoting cannot be the culprit here. As that commit
> message indicates we never set NL80211_IFTYPE_MONITOR for the interface
> type, so when that code removed the test for this interface type in
> iwl_get_sta_id it essentially removed dead code.
>  
> >  	/* If this frame is broadcast or management, use broadcast station id */
> > -	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
> > +	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
> > +	    iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
> >  		return priv->hw_params.bcast_sta_id;
> 
> I think my comment ties in with what Johannes said. When we are
> associated (whether in station, adhoc, or AP mode) we want this function
> to return the correct station ID. We also know that an interface can be
> in monitor mode while it is in any of these other modes. When this
> happens we do not want to return the broadcast station id ... we still
> want to return the station id. Your patch changes this behavior and will
> in this case always return the broadcast station id.

Dropping on the basis of this.  Please repost when/if this is resolved.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
