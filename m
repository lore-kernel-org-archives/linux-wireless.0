Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:42039
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbXIFO3D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 10:29:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 03/21] mac80211: revamp interface and filter configuration
Date: Thu, 6 Sep 2007 16:28:22 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Zhu Yi <yi.zhu@intel.com>, Tomas Winkler <tomasw@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	rt2400-devel@lists.sourceforge.net,
	Li YanBo <dreamfly281@gmail.com>
References: <20070905234209.108005000@sipsolutions.net> <20070905234622.671760000@sipsolutions.net>
In-Reply-To: <20070905234622.671760000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709061628.23222.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 September 2007, Johannes Berg wrote:
> Drivers are currently supposed to keep track of monitor
> interfaces if they allow so-called "hard" monitor, and
> they are also supposed to keep track of multicast etc.
> 
> This patch changes that, replaces the set_multicast_list()
> callback with a new configure_filter() callback that takes
> filter flags (FIF_*) instead of interface flags (IFF_*).
> For a driver, this means it should open the filter as much
> as necessary to get all frames requested by the filter flags.
> Accordingly, the filter flags are named "positively", e.g.
> FIF_ALLMULTI.
> 
> Multicast filtering is a bit special, which is why drivers
> that do not require FIF_ALLMULTI for multicast address filters
> (i.e. they actually have filters for multicast addresses)
> need to set the new IEEE80211_HW_MULTICAST_FILTER flag and
> call the get_mc_item() function passed to the configure_filter
> callback.
> 
> At the same time, drivers are no longer notified about
> monitor interfaces at all, this means they now need to
> implement the start() and stop() callbacks and the new
> change_filter_flags() callback. Also, the start()/stop()
> ordering changed, start() is now called *before* any
> add_interface() as it really should be, and stop() after
> any remove_interface().
> 
> The patch also changes the behaviour of setting the bssid
> to multicast for scanning when IEEE80211_HW_NO_PROBE_FILTERING
> is set; the IEEE80211_HW_NO_PROBE_FILTERING flag is removed
> and the filter flag FIF_BCN_PRBRESP_PROMISC introduced.
> This is a lot more efficient for hardware like b43 that
> supports it and other hardware can still set the BSSID
> to all-ones.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: Larry Finger <larry.finger@lwfinger.net>
> Cc: Michael Wu <flamingice@sourmilk.net>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: Tomas Winkler <tomasw@gmail.com>
> Cc: Michael Buesch <mb@bu3sch.de>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: Ivo van Doorn <ivdoorn@gmail.com>
> Cc: rt2400-devel@lists.sourceforge.net
> Cc: Li YanBo <dreamfly281@gmail.com>


The b43 changes are
Signed-off-by: Michael Buesch <mb@bu3sch.de>
