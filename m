Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40397 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaFDOyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jun 2014 10:54:25 -0400
Received: by mail-ig0-f182.google.com with SMTP id a13so1124945igq.9
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jun 2014 07:54:24 -0700 (PDT)
Date: Wed, 4 Jun 2014 10:53:53 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: remove ignore_plink_timer flag
Message-ID: <20140604145353.GA19299@localhost> (sfid-20140604_165428_548061_7AB0E8F9)
References: <1401888451-9612-1-git-send-email-me@bobcopeland.com>
 <1401890908.6079.32.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401890908.6079.32.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 04, 2014 at 04:08:28PM +0200, Johannes Berg wrote:
> On Wed, 2014-06-04 at 09:27 -0400, Bob Copeland wrote:
> > However, using the mod_timer()/del_timer() return values to
> > detect these cases is broken.  As a result, timers get ignored
> > unnecessarily, and stations can get stuck in the peering state
> > machine.
> > 
> > Instead, we can detect the case by looking at the timer expiration.
> > In the case of del_timer, just ignore the timers in the following
> > (LISTEN/ESTAB) states since they won't have timers anyway.
> 
> I'm not entirely sure about the expiration thing - doesn't seem
> different from the outside flag? But anyway - applied.

Happy to be enlightened -- for what it's worth this is my reasoning:

My understanding of mod_timer() return value is that it just means
the timer was scheduled, not actually running, and the original code
assumed the latter.  So let's say the timer is already scheduled to
happen 5 seconds from now, the old code would do:

lock
/* changing state, timer now reflects a different state timeout */
rv = mod_timer(10 secs from now);
if (rv) /* timer was already scheduled */
   ignore_plink_timer = 1;
unlock

So when the timer runs in 10 seconds it would skip execution even though
the first handler hadn't executed yet.  It got the race case right, but
not the race-free case.

-- 
Bob Copeland %% www.bobcopeland.com
