Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4336 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbYBZUCU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 15:02:20 -0500
Date: Tue, 26 Feb 2008 14:33:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k WARNING: at ieee80211_rate.h:149
Message-ID: <20080226193326.GC3013@tuxdriver.com> (sfid-20080226_200224_247767_DFCC306F)
References: <m38x17sk2g.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <m38x17sk2g.fsf@maximus.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2008 at 06:29:11PM +0100, Krzysztof Halasa wrote:
> Is this normal as well?
> 
> phy0: Selected rate control algorithm 'pid'
> ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> phy0: Adding new IBSS station XXX (dev=wlan0)
> ------------[ cut here ]------------
> WARNING: at net/mac80211/ieee80211_rate.h:149 rate_control_pid_rate_init+0x6c/0x7c()
> Modules linked in: ixp4xx_eth ixp4xx_hss ixp4xx_qmgr ixp4xx_npe ath5k
> [<c00c1b3c>] (dump_stack+0x0/0x14) from [<c00d463c>] (warn_on_slowpath+0x4c/0x60)
> [<c00d45f0>] (warn_on_slowpath+0x0/0x60) from [<c032a50c>] (rate_control_pid_rate_init+0x6c/0x7c)
>  r6:c689e800 r5:c7cace18 r4:c68ab000
> [<c032a4a0>] (rate_control_pid_rate_init+0x0/0x7c) from [<c031e56c>] (ieee80211_ibss_add_sta+0xb0/0x114)
>  r5:c7cac160 r4:c68ab000

<snip>

Looks like you are hitting the WARN_ON in rate_lowest_index (called
from rate_control_pid_rate_init).  Perhaps your supported band
information is not being setup correctly?  Possibly an endian problem?
Just speculating, really...

John
-- 
John W. Linville
linville@tuxdriver.com
