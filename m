Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36692 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbaAUPGN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 10:06:13 -0500
Message-ID: <1390316761.6199.27.camel@jlt4.sipsolutions.net> (sfid-20140121_160616_227518_C24FF281)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 21 Jan 2014 16:06:01 +0100
In-Reply-To: <1390227670-19030-6-git-send-email-michal.kazior@tieto.com> (sfid-20140120_152543_208232_A074CFFE)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140120_152543_208232_A074CFFE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-20 at 15:21 +0100, Michal Kazior wrote:
> The patch improves channel switch related locking
> (STA, IBSS, AP, mesh).
> 
> Now read access to sdata->vif.csa_active is
> protected by wdev.mtx and local->mtx so holding
> either is enough for read access but both are
> required for write access. Keep in mind sdata lock
> must be taken before local->mtx. Taking them in
> reverse order creates a deadlock situation.
> 
> The only exception is ieee80211_beacon_get_tim()
> but it's safe to leave it as is and it doesn't
> influence mac80211 state in any way.
> 
> The patch adds a few lockdep assertions along for
> easier code/locking maintenance.
---
> This also prepares for multi-interface CSA.

There's only one or two lines for that preparation as far as I can tell,
but I think you should separate it (or maybe make that part of another
patch)... or did I miss something?

I mean this:

> +       sdata->csa_chandef = params.chandef;

doesn't seem to belong here.


It would also be good to explain why you're doing this?

johannes

