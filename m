Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:27050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbZHUQdx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 12:33:53 -0400
Subject: Re: [PATCH] iwlwifi: Make injection of non-broadcast frames work
 again
From: reinette chatre <reinette.chatre@intel.com>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Rafael Laufer <rlaufer@cs.ucla.edu>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A8DC955.9060100@gmail.com>
References: <4A8DC955.9060100@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Aug 2009 09:33:53 -0700
Message-Id: <1250872433.30019.14430.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gábor,

On Thu, 2009-08-20 at 15:08 -0700, Gábor Stefanik wrote:
> Commit 1ccb84d87d04df3c76cd4352fe69786d8c7cf016 by Wey-Yi Guy
> ("iwlwifi: clean up unused NL80211_IFTYPE_MONITOR for Monitor mode")
> broke injection of non-broadcast frames to unassociated stations
> (causing a SYSASSERT for all such injected frames), due to injected
> frames no longer automatically getting a broadcast station ID assigned,
> and instead ending up with invalid station IDs.
> This patch restores the old behavior, fixing the aforementioned
> regression.

The patch you are quoting cannot be the culprit here. As that commit
message indicates we never set NL80211_IFTYPE_MONITOR for the interface
type, so when that code removed the test for this interface type in
iwl_get_sta_id it essentially removed dead code.
 
>  	/* If this frame is broadcast or management, use broadcast station id */
> -	if (!ieee80211_is_data(fc) ||  is_multicast_ether_addr(hdr->addr1))
> +	if (!ieee80211_is_data(fc) || is_multicast_ether_addr(hdr->addr1) ||
> +	    iwl_is_monitor_mode(priv)) /* Injected frames need broadcast too */
>  		return priv->hw_params.bcast_sta_id;

I think my comment ties in with what Johannes said. When we are
associated (whether in station, adhoc, or AP mode) we want this function
to return the correct station ID. We also know that an interface can be
in monitor mode while it is in any of these other modes. When this
happens we do not want to return the broadcast station id ... we still
want to return the station id. Your patch changes this behavior and will
in this case always return the broadcast station id.

Reinette




