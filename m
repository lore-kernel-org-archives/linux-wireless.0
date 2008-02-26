Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65233 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764634AbYBZXCx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 18:02:53 -0500
Subject: Re: ath5k WARNING: at ieee80211_rate.h:149
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, linux-wireless@vger.kernel.org
In-Reply-To: <20080226193326.GC3013@tuxdriver.com>
References: <m38x17sk2g.fsf@maximus.localdomain>
	 <20080226193326.GC3013@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 18:02:51 -0500
Message-Id: <1204066971.19041.16.camel@dv> (sfid-20080226_230257_443610_4C3DA3D0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-26 at 14:33 -0500, John W. Linville wrote:
> On Tue, Feb 26, 2008 at 06:29:11PM +0100, Krzysztof Halasa wrote:
> > Is this normal as well?
> > 
> > phy0: Selected rate control algorithm 'pid'
> > ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
> > phy0: Adding new IBSS station XXX (dev=wlan0)
> > ------------[ cut here ]------------
> > WARNING: at net/mac80211/ieee80211_rate.h:149 rate_control_pid_rate_init+0x6c/0x7c()
> > Modules linked in: ixp4xx_eth ixp4xx_hss ixp4xx_qmgr ixp4xx_npe ath5k
> > [<c00c1b3c>] (dump_stack+0x0/0x14) from [<c00d463c>] (warn_on_slowpath+0x4c/0x60)
> > [<c00d45f0>] (warn_on_slowpath+0x0/0x60) from [<c032a50c>] (rate_control_pid_rate_init+0x6c/0x7c)
> >  r6:c689e800 r5:c7cace18 r4:c68ab000
> > [<c032a4a0>] (rate_control_pid_rate_init+0x0/0x7c) from [<c031e56c>] (ieee80211_ibss_add_sta+0xb0/0x114)
> >  r5:c7cac160 r4:c68ab000
> 
> <snip>
> 
> Looks like you are hitting the WARN_ON in rate_lowest_index (called
> from rate_control_pid_rate_init).  Perhaps your supported band
> information is not being setup correctly?  Possibly an endian problem?
> Just speculating, really...

There are indeed endian issues reported by sparse in the IBSS code.
I've just submitted a patch.  Not sure if they are relevant to the
issue, but I think it's worth trying.

-- 
Regards,
Pavel Roskin
