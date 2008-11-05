Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbYKEAIS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 19:08:18 -0500
Date: Wed, 5 Nov 2008 08:09:00 +0800
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/7] iwlwifi: fix priv->iw_mode setting when multiple
	vif are configured
Message-ID: <20081105000900.GA10671@mail.intel.com> (sfid-20081105_010824_312647_47FED5AA)
Reply-To: yi.zhu@intel.com
References: <1225314349-11139-1-git-send-email-reinette.chatre@intel.com> <1225314349-11139-2-git-send-email-reinette.chatre@intel.com> <1225314349-11139-3-git-send-email-reinette.chatre@intel.com> <1225314349-11139-4-git-send-email-reinette.chatre@intel.com> <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ae8368d03d2885c4942e2f9876dcaa60.squirrel@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 30, 2008 at 05:18:03PM +0800, Johannes Berg wrote:
> Reinette Chatre wrote:
> > From: Zhu, Yi <yi.zhu@intel.com>
> >
> > mac80211 supports multiple virtual interfaces for a single device. For
> > example, a managed interface (wlan0) and a monitor interface (mon0) can
> > exist at the same time. Thus priv->iw_mode is not sufficient to track
> > the wireless mode any more.
> 
> This example is not correct, mac80211 will only support multiple virtual
> interfaces when the driver allows this via add_interface (which I don't
> think yours does) and it will *never* tell you about monitor interfaces at
> all except by way of configuring the filter differently.

We do support add_interface in iwlagn. But it works correctly only if
the second one is a monitor interface.

> Therefore, all the "is monitor" checks in iwlwifi are pretty pointless
> unless you really want to have differing behaviour between "monitor +
> something" and "just monitor"?

In case of BSS + monitor, we need to tell firmware about the
association status. This differs with pure montior mode.

Thanks,
-yi
