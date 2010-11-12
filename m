Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56942 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753062Ab0KLCgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 21:36:54 -0500
Subject: Re: ath5k/mac80211:  Reproducible deadlock with 64-stations.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Tejun Heo <tj@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CDC8EED.60602@candelatech.com>
References: <4CDB2488.4040802@candelatech.com>
	 <1289437356.3748.25.camel@jlt3.sipsolutions.net>
	 <4CDBB716.7020802@kernel.org> <4CDC2016.8020200@candelatech.com>
	 <4CDC8EED.60602@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Nov 2010 18:37:07 -0800
Message-ID: <1289529427.3695.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-11 at 16:48 -0800, Ben Greear wrote:
> I have a potential scenario:
> 
> The ieee80211_do_stop logic is called under RTNL, and it
> then calls flush_work().
> 
> What if the worker thread is currently blocked on something like
> wireless_nlevent_process which tries to acquire rtnl?
> 
> Wouldn't that cause a deadlock?

Only if Tejun's deadlock avoidance doesn't work -- we used to have a
separate kernel thread for mac80211 work including sdata->work which
never acquired the RTNL. Also, we have lockdep annotations for exactly
this kind of thing ("events" and "(linkwatch_work).work" in your held
locks output) that should catch this.

johannes

