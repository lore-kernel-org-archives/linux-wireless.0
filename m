Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0JEInI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 04:43:08 -0400
Subject: Re: deadlock on sdata->u.mgd.mtx between worker thread an 'ip'?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4CAAB75A.3050309@candelatech.com>
References: <4CAAB75A.3050309@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 10:43:06 +0200
Message-ID: <1286268186.3641.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-04 at 22:27 -0700, Ben Greear wrote:

> I think the deadlock might be between kworker and ip, on the
> sdata->u.mgd.mtx v/s iflist_mtx lock.  It seems both processes
> have ifmgd->mtx held, and worker is trying to grab it again but
> blocks.
> 
> I think maybe the ip process has locked a different sdata than
> 'forsdata', so that is why this nested lock attempt by the worker thread
> to all of the !forsdata objects blocks?
> 
> void ieee80211_recalc_smps(struct ieee80211_local *local,
> 			   struct ieee80211_sub_if_data *forsdata)
> ...
> 		if (sdata != forsdata) {
> 			/*
> 			 * This nested is ok -- we are holding the iflist_mtx
> 			 * so can't get here twice or so. But it's required
> 			 * since normally we acquire it first and then the
> 			 * iflist_mtx.
> 			 */
> 			mutex_lock_nested(&sdata->u.mgd.mtx, SINGLE_DEPTH_NESTING);
> 			count += check_mgd_smps(&sdata->u.mgd, &smps_mode);
> 			mutex_unlock(&sdata->u.mgd.mtx);
> 		} else

I just debugged the same based on your other mail ...

johannes

