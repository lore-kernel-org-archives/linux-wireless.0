Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:43229 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149AbZHUJrc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 05:47:32 -0400
Date: Fri, 21 Aug 2009 11:47:32 +0200
From: Andreas Mohr <andi@lisas.de>
To: ath5k-devel@lists.ath5k.org
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Johannes Stezenbach <js@sig21.net>
Subject: ath5k: ath5k_pci_probe(): weirdo code
Message-ID: <20090821094732.GA970@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello all,

that 2GHz/5GHz radio information code in ath5k_pci_probe() in 2.6.31-rc6 source
seems VERY weird.
ah_radio_5ghz_revision/ah_radio_2ghz_revision conditional evaluation seems
completely bonkered in several places, unless something is escaping on
me.
Then also at this place, why is there no
else
{
  WARN_ONCE(...); // Huh. Unknown/unhandled/impossible revision combo
}
branch at the end? (or something less incinerating)
I've had my few lessons about defensive programming...
(and applying such stuff liberally in this entire driver wouldn't hurt either)


The

        if (!sc->ah->ah_single_chip) {
                /* Single chip radio (!RF5111) */

part seemed weird logic, too, but I then thought that this code section
is perhaps _intended_ to be skipped in this case, to simply not log anything
for single-chip radios
(but the comment above would be very insufficient/confusing if that is
the case, and if the entire weird section is _actually_ correct as it stands
then even lots more rectifying comments about this strange evaluation
being correct are missing).

Could anyone enlighten me?
So far it looks like a large part of this code is buggy, but I could be
wrong.



BTW, I'm currently on 2.6.31-rc6 on Aspire One, with even more ath5k problems
than before, connection is dying every couple minutes, extended to every
couple dozen minutes if I force rate 1M
(but it looks like "[Bug #13948] ath5k broken after suspend-to-ram"
http://lkml.org/lkml/2009/8/19/468 is hopefully covering these issues already).
And I do have CONFIG..._PS (powersave) enabled by default...
And I do make liberal use of suspend-to-ram, as should everyone.

Thanks,

Andreas Mohr
