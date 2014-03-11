Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaCKQ3I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 12:29:08 -0400
Message-ID: <1394555345.30155.9.camel@jlt4.sipsolutions.net> (sfid-20140311_172916_767548_95097405)
Subject: Re: [PATCH] mac80211: fix possible NULL dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 11 Mar 2014 18:29:05 +0200
In-Reply-To: <CA+BoTQk19_p8WcUpUbRNTZgStNMfYcSZEUhbEB9G6i0mvYy-=w@mail.gmail.com> (sfid-20140311_142541_678765_EF7494BB)
References: <1394176178-8504-1-git-send-email-michal.kazior@tieto.com>
	 <CA+BoTQkVfgkMR_cvv5dUNkzLd7KrDQ7VMYKucJybpF0aAWpESA@mail.gmail.com>
	 <1394543651.30155.3.camel@jlt4.sipsolutions.net>
	 <CA+BoTQk19_p8WcUpUbRNTZgStNMfYcSZEUhbEB9G6i0mvYy-=w@mail.gmail.com>
	 (sfid-20140311_142541_678765_EF7494BB)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-03-11 at 14:25 +0100, Michal Kazior wrote:

> > Ok. However, I'm not sure that we should ever really run into this? At
> > least with Luca's patches we want to not go through NULL state to start
> > with.
> 
> Current channel reservation patches do a sequence of
> unassign_vif_chanctx() followed by assign_vif_chanctx(). This implies
> you have no chanctx for a split second. All places that aren't
> protected by chanctx_mtx (i.e. RCU) can get NULL chanctx during the
> reassignment.
> 
> One way to trigger that would be to spam-call ieee80211_get_station().
> If you get a NULL chanctx and you have 5GHz only hardware you get NULL
> dereference kernel splat.
> 
> With multi-vif CSA the vulnerability timeframe will increase.

Luca is just fixing his patches to not go through the NULL state and
directly go from the old to the new context, so that will no longer be a
concern.

johannes

