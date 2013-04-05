Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161279Ab3DEMgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 08:36:10 -0400
Message-ID: <1365165364.8515.24.camel@jlt4.sipsolutions.net> (sfid-20130405_143615_200263_E24E5C07)
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 05 Apr 2013 14:36:04 +0200
In-Reply-To: <20130405121629.GB29188@pandem0nium>
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1364993200.8351.35.camel@jlt4.sipsolutions.net>
	 <515D8259.1030208@neratec.com> <20130404182219.GA24704@pandem0nium>
	 <1365160971.8515.23.camel@jlt4.sipsolutions.net>
	 <20130405121629.GB29188@pandem0nium>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-04-05 at 14:16 +0200, Simon Wunderlich wrote:
> On Fri, Apr 05, 2013 at 01:22:51PM +0200, Johannes Berg wrote:
> > On Thu, 2013-04-04 at 20:22 +0200, Simon Wunderlich wrote:
> > 
> > > As far as I see, the problem happens when changing from a DFS to a non-DFS
> > > channel. local->hw.conf.radar_enabled is true from the last (DFS) channel,
> > > but the channel gets released when stopping the AP, and the channel context
> > > is freed. 
> > 
> > At this point, why doesn't it disable hw.conf.radar_enabled? I really
> > think it should?
> 
> As far as I see release_channel() -> unassign_vif_chanctx() -> ieee80211_recalc_radar_chanctx()
> is called while the interface with radar enabled is still present, and therefore it is assumed
> that the radar enable is still required.
> 
> We could reset local->hw.conf.radar_enabled ieee80211_free_chanctx() though, but IMHO the cleaner
> way would be to properly initialize it when the the channel is used next time through
> vif_use_channel().

I disagree, it would leave the hardware in a weird state -- idle but
having to detect radars??

johannes

