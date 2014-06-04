Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34734 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753374AbaFDOIh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 10:08:37 -0400
Message-ID: <1401890908.6079.32.camel@jlt4.sipsolutions.net> (sfid-20140604_160840_359749_0728FE84)
Subject: Re: [PATCH] mac80211: remove ignore_plink_timer flag
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 04 Jun 2014 16:08:28 +0200
In-Reply-To: <1401888451-9612-1-git-send-email-me@bobcopeland.com> (sfid-20140604_152812_599798_BB7E8B6B)
References: <1401888451-9612-1-git-send-email-me@bobcopeland.com>
	 (sfid-20140604_152812_599798_BB7E8B6B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-06-04 at 09:27 -0400, Bob Copeland wrote:
> The mesh_plink code is doing some interesting things with the
> ignore_plink_timer flag.  It seems the original intent was to
> handle this race:
> 
> cpu 0                           cpu 1
> -----                           -----
>                                 start timer handler for state X
> acquire sta_lock
> change state from X to Y
> mod_timer() / del_timer()
> release sta_lock
>                                 acquire sta_lock
>                                 execute state Y timer too soon
> 
> However, using the mod_timer()/del_timer() return values to
> detect these cases is broken.  As a result, timers get ignored
> unnecessarily, and stations can get stuck in the peering state
> machine.
> 
> Instead, we can detect the case by looking at the timer expiration.
> In the case of del_timer, just ignore the timers in the following
> (LISTEN/ESTAB) states since they won't have timers anyway.

I'm not entirely sure about the expiration thing - doesn't seem
different from the outside flag? But anyway - applied.

johannes

