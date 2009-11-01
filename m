Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2088 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZKAOqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 09:46:47 -0500
Date: Sun, 1 Nov 2009 09:44:24 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>,
	ath9k-devel@lists.ath9k.org
Subject: Re: ath5k AP issues
Message-ID: <20091101144424.GB29825@hash.localnet>
References: <200910291330.26172.mb@bu3sch.de> <200910291406.03422.mb@bu3sch.de> <200910291431.48388.mb@bu3sch.de> <20091031202156.GA29825@hash.localnet> <40f31dec0910312353w32aede90ib5e71545ca744389@mail.gmail.com> <20091101131652.GA30381@hash.localnet> <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0911010541l650513fg31ffcadd12698f0@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 01, 2009 at 03:41:49PM +0200, Nick Kossifidis wrote:
> So beacon-sent gated option doesn't work ?
> Did you try also AR5K_DCU_MISC_ARBLOCK_IGNORE ?

No, but I'll try that today.

> Also according to docs Beacon frames should use queue 9 and CAB should
> use queue 8 (don't know why but docs say that these are the
> appropriate DCUs), beacon-gated triggering might only work if we use
> DCU 9 for beacons (now we are using queue 7 for beacons and queue 6
> for cab).

Yeah, I read the same thing.  The docs say 8 and 9 are highest priority
queues, it also says they both need to be DBA gated, but then on the
other hand it describes beacon-sent gated as precisely what we want,
and that queue 8 is "typically associated with beacon-gated frames."

I originally assumed the queue with AR5K_DCU_MISC_BCN_ENABLE is used
for triggering beacon sent but I'll try renumbering the queues and
see what happens.

Just copying ath9k list in case anyone with the inside scoop from Atheros
wants to chime in. :)  The issue is queue settings for the CAB queue.
Beacon sent gating seems like a better option than using time throttled
DBA gating (with ready time for the next beacon interval).  Ath9k is using
the latter, the former seems not to work at least in ath5k, or we're doing
it wrong.

-- 
Bob Copeland %% www.bobcopeland.com

