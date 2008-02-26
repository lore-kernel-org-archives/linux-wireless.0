Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:28069 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756936AbYBZCOF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 21:14:05 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Date: Tue, 26 Feb 2008 11:13:34 +0900
Cc: "Nick Kossifidis" <mickflemm@gmail.com>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
References: <E1JTfTv-0002bm-Qp@hash.localnet>
In-Reply-To: <E1JTfTv-0002bm-Qp@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802261113.34604.bruno@thinktube.com> (sfid-20080226_021411_345802_5D2D87A0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 26 February 2008 00:43:07 Bob Copeland wrote:
> > > Hey, that's a good clue... I just switched over to b-only and it seems
> > > to be much more stable.
>
> ...or not.  I still got some calibration errors last night in b-mode.  Just
> so we're on the same page, I see things in the dmesg like:
>
> ath0: failed to restore operational channel after scan
> ath5k phy0: calibration timeout (2412 MHz)
> ath5k phy0: ath5k_chan_set: unable to reset channel (2412 Mhz)
> ath0: failed to set freq to 2412 MHz for scan
> ath5k phy0: calibration timeout (2417 MHz)
>
> > If i'm correct you should get 4-7Mbit/sec @ 11Mbit. Plz let me know if
> > you have some results, meanwhile i'll try to figure out the i/q
> > calibration algo (we are ok for noise floor calibration i believe).
>
> One thing I noticed from my traces is that the binary driver sets
> bits AR5K_PHY_AGCCTL_NF | AR5K_PHY_AGCCTL_CAL in AR5K_PHY_AGCCTL.
> Then it makes a whole lot of misc register writes, then re-reads
> AR5K_PHY_AGCCTL; in that time only the noise floor bit got cleared
> but _CAL is still high.  Dunno if that means anything to you or not.
>
> e.g:
>
> R: 0x9860 = 0x00009d18 - AR5K_PHY_AGCCTL
> W: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL  <-- set (_CAL | _NF)
> W: 0x1000 = 0x00000001 - AR5K_DCU_QCUMASK_BASE
> W: 0x1004 = 0x00000002 - unknown
> W: 0x1008 = 0x00000004 - unknown
> [... lots more writes to DCU & IMR regs ...]
> W: 0x00a0 = 0x00080965 - AR5K_PIMR
> R: 0x00ac = 0x00000000 - AR5K_SIMR2
> W: 0x00ac = 0x00070000 - AR5K_SIMR2
> R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
> R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
> R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
> R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
> R: 0x9860 = 0x00009d1b - AR5K_PHY_AGCCTL
> R: 0x9860 = 0x00009d1a - AR5K_PHY_AGCCTL  <-- _NF cleared
>
> Maybe a red herring as obviously the current method of doing things
> works for me sometimes...

so when is AR5K_PHY_AGCCTL_CAL getting cleared?

i'm not sure if that is related because the error message you are seeing is 
not due to noise floor calibration timeout but because AR5K_PHY_AGCCTL_CAL is 
not cleared in the time that ath5k expects, but i want to mention it anyways:

the HAL enables noise floor calibration, and reads the result on then next 
calibration interval, then enables calibration again and reads on the next... 
i think that way it makes sure there is always enough time for the noise 
floor calibration to take place in the mean time (the calibration can only 
happen when the channel is otherwise silent).

if i understand correctly, ath5k currenty expects the noise floor calibration 
to finish within 300ms (ath5k_hw_register_timeout) and then we give it 
another 20ms for the noise floor value to settle ( for (i = 20; i > 0; i--) 
mdelay(1); ) that worked well for older chipsets, but also for 5424 this 
results in more noise floor calibration timeouts.

bruno




