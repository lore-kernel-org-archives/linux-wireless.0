Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26865 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYKGIEZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 03:04:25 -0500
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
	vif are configured
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1225967956.3619.199.camel@johannes.berg>
References: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-2-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-3-git-send-email-reinette.chatre@intel.com>
	 <1225314349-11139-4-git-send-email-reinette.chatre@intel.com>
	 <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
	 <20081105000900.GA10671@mail.intel.com>
	 <1225884472.3619.72.camel@johannes.berg>
	 <1225938894.2604.140.camel@debian.sh.intel.com>
	 <1225967956.3619.199.camel@johannes.berg>
Content-Type: text/plain
Date: Fri, 07 Nov 2008 16:04:55 +0800
Message-Id: <1226045096.2604.253.camel@debian.sh.intel.com> (sfid-20081107_090430_532932_29CD551C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-11-06 at 18:39 +0800, Johannes Berg wrote:
> Ok, for one, it seems weird that you're saying you handled
>  * other bss
>  * allmulti
>  * bcn/presp promisc
>  * control
> without doing anything. Does your hw/fw really always pass up control
> frames? I didn't think it does.
> 
> Also, it seems rather odd that you need to reconnect etc. when a monitor
> interface is added, that would destroy AP and mesh modes completely when
> somebody adds a new monitor interface on AP mode to see what's going on.
> 
> Can you really not actually implement the filter flags but have to
> completely reprogram the firmware for monitor mode? What exactly does
> monitor mode do? It seems that at least, the logic in configure_filter
> should mask out the control/allmulti flags when otherbss is not set,
> because right now, if I add a monitor interface that _only_ asks for
> control frames and _not_ other bss frames, it doesn't look like it would
> work.

You are right. We don't need to reprogram the firmware completely to
support these filter flags. Will post a patch to reimplement our
configure_filter handler early next week.

Thanks,
-yi

