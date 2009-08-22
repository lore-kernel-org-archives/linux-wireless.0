Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1998 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbZHVNgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 09:36:46 -0400
Date: Sat, 22 Aug 2009 09:35:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Andreas Mohr <andi@lisas.de>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Johannes Stezenbach <js@sig21.net>
Subject: Re: ath5k: ath5k_pci_probe(): weirdo code
Message-ID: <20090822133557.GB6762@hash.localnet>
References: <20090821094732.GA970@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090821094732.GA970@rhlx01.hs-esslingen.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 21, 2009 at 11:47:32AM +0200, Andreas Mohr wrote:
> Hello all,
> 
> that 2GHz/5GHz radio information code in ath5k_pci_probe() in 2.6.31-rc6
> source seems VERY weird.

The code looks horribly confusing, it should be moved into attach.c
and reworked a lot probably.  It looks correct though - it is fixing up
settings for (really old) multiple radio chip devices, where we can't
tell by the radio revision alone if it is multiband or not.

ah_radio_{2,5}ghz_revision is what is in the appropriate registers in
the card, but e.g. the revision in the 5ghz radio register may actually
refer to the 2ghz radio on some 802.11B-only devices, depending on what
is in the eeprom.

> Then also at this place, why is there no
> else
> {
>   WARN_ONCE(...); // Huh. Unknown/unhandled/impossible revision combo

Should be caught already in attach.c, but yeah, another warning wouldn't
hurt.

>         if (!sc->ah->ah_single_chip) {
>                 /* Single chip radio (!RF5111) */
> 
> part seemed weird logic, too, but I then thought that this code section
> is perhaps _intended_ to be skipped in this case, to simply not log anything
> for single-chip radios

The comment belongs to the subsequent if() test, where it should probably
live to be clearer.  All recent devices (including yours) are now single
chip so this code wouldn't run on your device.

> BTW, I'm currently on 2.6.31-rc6 on Aspire One, with even more ath5k problems
> than before, connection is dying every couple minutes, extended to every
> couple dozen minutes if I force rate 1M

Can you supply /debug/ieee80211/phy0/stations/<...>/rc_stats?

> (but it looks like "[Bug #13948] ath5k broken after suspend-to-ram"
> http://lkml.org/lkml/2009/8/19/468 is hopefully covering these issues already).

Can you verify that the patch mentioned in the bug report works?
We need to queue that for 2.6.31.

> And I do have CONFIG..._PS (powersave) enabled by default...
> And I do make liberal use of suspend-to-ram, as should everyone.

As do I.  I don't have a 2425 though, and there are quite some variations
between each HW revision.

-- 
Bob Copeland %% www.bobcopeland.com

