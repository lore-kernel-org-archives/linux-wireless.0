Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:30301 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbXIDCbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2007 22:31:51 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <20070831205524.GA11128@tuxdriver.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070831205524.GA11128@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 10:25:46 +0800
Message-Id: <1188872746.13078.411.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-08-31 at 16:55 -0400, John W. Linville wrote:
> A few comments below -- many of them are nits or somewhat minor.
> I think the ieee80211_rate.h one needs to be resolved for sure.  Also,
> splitting iwl-base.c is definitely worth considering -- building two
> object from one source is a bit ugly.
> 
> Please respond to the questions/comments, and indicate if/when you
> will split iwl-base.c.

Will split it in the next version as well as addressing all your
comments below.

> Also, let's figure-out what really needs to
> be exportd to drivers from ieee80211_rate.h and get that done.

Since they are device specific rate scale algorithm, I don't think they
will help to increase performance for other devices. So make them stay
together with the driver is a better choice (vs. with mac80211). If so,
the rate scale interface has to be abstracted from internal mac80211.
The current dependencies are as below:

iwl3945-rs -> rate_control_ops (ieee80211_rate.h)
rate_control_ops -> sta_info (sta_info.h)
rate_control_ops -> ieee80211_local (ieee80211_i.h)
ieee80211_local -> ieee80211_key (ieee80211_key.h)

If we want to avoid a big restructure of the mac80211 headers, the
easiest way is to move four header files from net/mac80211 to
include/net/ and rename them with mac80211_ prefix (especially for
sta_info.h). This way, for any mac80211 based wireless drivers want to
create their own rate scale algorithm, they can smiply include
<net/mac80211_rate.h> and implement all the callback functions.
Comments?

If you all agree with this change, especially the mac80211 folks, I'll
come up with a patch for it.

Thanks,
-yi
