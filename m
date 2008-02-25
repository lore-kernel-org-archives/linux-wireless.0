Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:34131 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYBYPn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 10:43:29 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <E1JTfTv-0002bm-Qp@hash.localnet> (sfid-20080225_154333_414150_E7A69E60)
Date: Mon, 25 Feb 2008 10:43:07 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Hey, that's a good clue... I just switched over to b-only and it seems to
> >  be much more stable.

...or not.  I still got some calibration errors last night in b-mode.  Just
so we're on the same page, I see things in the dmesg like:

ath0: failed to restore operational channel after scan
ath5k phy0: calibration timeout (2412 MHz)
ath5k phy0: ath5k_chan_set: unable to reset channel (2412 Mhz)
ath0: failed to set freq to 2412 MHz for scan
ath5k phy0: calibration timeout (2417 MHz)

> If i'm correct you should get 4-7Mbit/sec @ 11Mbit. Plz let me know if
> you have some results, meanwhile i'll try to figure out the i/q
> calibration algo (we are ok for noise floor calibration i believe).

One thing I noticed from my traces is that the binary driver sets
bits AR5K_PHY_AGCCTL_NF | AR5K_PHY_AGCCTL_CAL in AR5K_PHY_AGCCTL.
Then it makes a whole lot of misc register writes, then re-reads
AR5K_PHY_AGCCTL; in that time only the noise floor bit got cleared
but _CAL is still high.  Dunno if that means anything to you or not.

e.g:

R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL  <-- set (_CAL | _NF)
W: 0x1000 = 0x00000001 - AR5K_DCU_QCUMASK_BASE
W: 0x1004 = 0x00000002 - unknown
W: 0x1008 = 0x00000004 - unknown
[... lots more writes to DCU & IMR regs ...]
W: 0x00a0 = 0x00080965 - AR5K_PIMR
R: 0x00ac = 0x00000000 - AR5K_SIMR2
W: 0x00ac = 0x00070000 - AR5K_SIMR2
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL  <-- _NF cleared

Maybe a red herring as obviously the current method of doing things
works for me sometimes...

-- 
Bob Copeland %% www.bobcopeland.com


