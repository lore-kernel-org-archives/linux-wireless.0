Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:38869 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbYBZDv5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 22:51:57 -0500
Date: Mon, 25 Feb 2008 22:51:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: bruno randolf <bruno@thinktube.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080226035136.GA11064@hash.localnet> (sfid-20080226_035203_664932_D764BDB0)
References: <E1JTfTv-0002bm-Qp@hash.localnet> <200802261113.34604.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
In-Reply-To: <200802261113.34604.bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 26, 2008 at 11:13:34AM +0900, bruno randolf wrote:
> so when is AR5K_PHY_AGCCTL_CAL getting cleared?

Actually in my trace I didn't see it resetting on its own.  The only
reads with _CAL == 0 happen right after a write that clears it.  
(See attached from grep "^[RW].*AGCCTL").  It would be nice if my
mmio trace had timing info...

On the other hand, it must happen or else ath5k_hw_reset would never
work on the 5424.

> the HAL enables noise floor calibration, and reads the result on then next 
> calibration interval, then enables calibration again and reads on the next... 
> i think that way it makes sure there is always enough time for the noise 
> floor calibration to take place in the mean time (the calibration can only 
> happen when the channel is otherwise silent).

Good to know.  I guess calibration timeouts could also be symptomatic of
general problems as well.  Incidentally, in my current session I've
disabled G mode from the capabilities set.  All is not well though, I'll
get a run of:

ath0: invalid Michael MIC in data frame from 00:1a:70:da:a9:cb
ath0: invalid Michael MIC in data frame from 00:1a:70:da:a9:cb
ath0: invalid Michael MIC in data frame from 00:1a:70:da:a9:cb
ath0: deauthenticate(reason=14)

(then it reassociates)

> another 20ms for the noise floor value to settle ( for (i = 20; i > 0; i--) 
> mdelay(1); ) that worked well for older chipsets, but also for 5424 this 
> results in more noise floor calibration timeouts.

Sounds plausible, though I didn't have a lot of success bumping up the
timeout there.  But then, I have no idea what I'm doing so I'll test any 
patches :)

-- 
Bob Copeland %% www.bobcopeland.com 

--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="agc.txt"

W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL                ................1..111.1...11... (ath_hal_reset)
W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL                ................1..111.1...11.11 (ath_hal_reset)
R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL                ................1..111.1...11.1. (ath_hal_reset)
W: 0x9860 = 0x00009d10 - AR5K_PHY_AGCCTL                ................1..111.1...1.... (ath_hal_reset)
R: 0x9860 = 0x00009d10 - AR5K_PHY_AGCCTL                ................1..111.1...1.... (ath_hal_reset)
W: 0x9860 = 0x00009d13 - AR5K_PHY_AGCCTL                ................1..111.1...1..11 (ath_hal_reset)
R: 0x9860 = 0x00009d12 - AR5K_PHY_AGCCTL                ................1..111.1...1..1. (ath_hal_reset)
W: 0x9860 = 0x00009d10 - AR5K_PHY_AGCCTL                ................1..111.1...1.... (ath_hal_reset)
R: 0x9860 = 0x00009d10 - AR5K_PHY_AGCCTL                ................1..111.1...1.... (ath_hal_reset)
W: 0x9860 = 0x00009d13 - AR5K_PHY_AGCCTL                ................1..111.1...1..11 (ath_hal_reset)
R: 0x9860 = 0x00009d12 - AR5K_PHY_AGCCTL                ................1..111.1...1..1. (ath_hal_reset)

--7JfCtLOvnd9MIVvH--

