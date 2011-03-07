Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55836 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab1CGOaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 09:30:16 -0500
Subject: Re: WARN_ON in ieee80211_scan_completed_finish triggered
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Ben Greear <greearb@candelatech.com>
In-Reply-To: <20110307142241.GB9571@redhat.com>
References: <1299443142.1292.6.camel@marge>
	 <1299491485.3790.2.camel@jlt3.sipsolutions.net>
	 <1299498147.5665.3.camel@marge>
	 <1299499400.3790.8.camel@jlt3.sipsolutions.net>
	 <1299503693.6739.1.camel@jlt3.sipsolutions.net>
	 <20110307142241.GB9571@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Mar 2011 15:30:11 +0100
Message-ID: <1299508211.6739.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-03-07 at 15:22 +0100, Stanislaw Gruszka wrote:
> On Mon, Mar 07, 2011 at 02:14:53PM +0100, Johannes Berg wrote:
> >  	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
> >  
> >  	WARN_ON(local->scanning & (SCAN_SW_SCANNING | SCAN_HW_SCANNING));

> Not needed, just zeroed local->scanning.

Yeah, I realised that a few minutes ago too, thanks.

> > @@ -332,7 +321,6 @@ static void __ieee80211_scan_completed_f
> >  	}
> >  
> >  	ieee80211_recalc_idle(local);
> > -	mutex_unlock(&local->mtx);
> >  
> >  	ieee80211_mlme_notify_scan_completed(local);
> >  	ieee80211_ibss_notify_scan_completed(local);
> I'm a bit worried about calling these with mutex.

Yeah so was I, but I audited them and they should be fine. mesh and mlme
only do some rcu-based list iteration and start timers/workqueue items,
and ibss does the same but grabs local->iflist_mtx -- however we don't
hold that here and it's always taken after local->mtx. Thus it should be
ok, right?

johannes

