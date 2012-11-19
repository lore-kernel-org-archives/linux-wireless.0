Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2KSPKS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 10:10:18 -0500
Message-ID: <1353337847.18299.24.camel@jlt4.sipsolutions.net> (sfid-20121119_161021_862820_DC84D717)
Subject: Re: [RFC] mac80211: Add debugfs callbacks for station
 addition/removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 19 Nov 2012 16:10:47 +0100
In-Reply-To: <20650.18783.6821.78205@gargle.gargle.HOWL>
References: <1353304116-7124-1-git-send-email-sujith@msujith.org>
	 <1353334496.18299.5.camel@jlt4.sipsolutions.net>
	 <20650.18783.6821.78205@gargle.gargle.HOWL>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-11-19 at 20:29 +0530, Sujith Manoharan wrote:
> 
> BTW, here are few warnings that I saw when doing a suspend/resume cycle:
> 
> linux-test kernel: WARNING: at /home/sujith/dev/wireless-testing/net/mac80211/chan.c:379 ieee80211_vif_release_channel+0x36/0x70 [mac80211]()
> linux-test kernel: Hardware name: LIFEBOOK AH531
> linux-test kernel: Pid: 4139, comm: pm-suspend Tainted: G        W  O 3.7.0-rc5-wl-debug #31
> linux-test kernel: Call Trace:
> linux-test kernel:  [<ffffffff8105697f>] warn_slowpath_common+0x7f/0xc0
> linux-test kernel:  [<ffffffff810569da>] warn_slowpath_null+0x1a/0x20
> linux-test kernel:  [<ffffffffa056e566>] ieee80211_vif_release_channel+0x36/0x70 [mac80211]
> linux-test kernel:  [<ffffffffa059a3ca>] __ieee80211_suspend+0x45a/0xd10 [mac80211]

Oops. I should fix this.

> linux-test kernel: WARNING: at /home/sujith/dev/wireless-testing/net/mac80211/ieee80211_i.h:1503 ieee80211_send_nullfunc+0xfe/0x130 [mac80211]()
> linux-test kernel: Hardware name: LIFEBOOK AH531
> linux-test kernel: Pid: 4139, comm: pm-suspend Tainted: G        W  O 3.7.0-rc5-wl-debug #31
> linux-test kernel: Call Trace:
> linux-test kernel:  [<ffffffff8105697f>] warn_slowpath_common+0x7f/0xc0
> linux-test kernel:  [<ffffffff810569da>] warn_slowpath_null+0x1a/0x20
> linux-test kernel:  [<ffffffffa058501e>] ieee80211_send_nullfunc+0xfe/0x130 [mac80211]

This is already fixed, but the fix is in wireless while the WARN was
only introduced in -next, so we need to have some patience.

johannes

