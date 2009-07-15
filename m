Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:17948 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbZGOIiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 04:38:07 -0400
Subject: Re: [PATCH v3] cfg80211: rework key operation
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1247055774.24749.0.camel@johannes.local>
References: <1247051586.4755.81.camel@johannes.local>
	 <1247052613.12857.0.camel@johannes.local>
	 <1247055774.24749.0.camel@johannes.local>
Content-Type: text/plain
Date: Wed, 15 Jul 2009 16:38:06 +0800
Message-Id: <1247647086.3695.48.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-08 at 20:22 +0800, Johannes Berg wrote:
> This reworks the key operation in cfg80211, and now only
> allows, from userspace, configuring keys (via nl80211)
> after the connection has been established (in managed
> mode), the IBSS been joined (in IBSS mode), at any time
> (in AP[_VLAN] modes) or never for all the other modes.
> 
> In order to do shared key authentication correctly, it
> is now possible to give a WEP key to the AUTH command.
> To configure static WEP keys, these are given to the
> CONNECT or IBSS_JOIN command directly, for a userspace
> SME it is assumed it will configure it properly after
> the connection has been established.

This breaks wireless-tools for WEP with fullmac cards because "iwconfig
key" doesn't send the AUTH command. Is it expected?

Thanks,
-yi

> Since mac80211 used to check the default key in IBSS
> mode to see whether or not the network is protected,
> it needs an update in that area, as well as an update
> to make use of the WEP key passed to auth() for shared
> key authentication.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

