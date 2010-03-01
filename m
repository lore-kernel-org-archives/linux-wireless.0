Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42299 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab0CAUPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 15:15:47 -0500
Date: Mon, 1 Mar 2010 15:12:14 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: Drapko Nitzhonot <drapkos@gmail.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	stable@kernel.org
Subject: Re: Status of http://patchwork.kernel.org/patch/56785/
Message-ID: <20100301201214.GG2961@tuxdriver.com>
References: <753864a31002271218r7fce0601l51f78efdf2576f75@mail.gmail.com> <201002272124.31863.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201002272124.31863.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 27, 2010 at 09:24:31PM +0100, Michael Buesch wrote:
> On Saturday 27 February 2010 21:18:39 Drapko Nitzhonot wrote:
> > Hi,
> > I've been using this patch for over one month and it resolves my
> > problem with ath5k in AP mode.
> > Before patch, I got "ath5k phy0: no further txbuf available, dropping
> > packet" and I had to restart hostapd
> > to make it to work again.
> > 
> > Does anybody knows if this patch will be finally apply to kernel?
> 
> I think it is upstream through wireless-testing.
> However, to say it once again, this is a -stable candidate.
> (And while we are at it, that ath5k_dont_use_external_sleep_clock_in_AP_mode.patch
> also is a stable candidate).
> 
> An AP running 2.6.32 is unusable without those two patches.
> However, it's rock stable as soon as those are applied.

commit a951ae2176b982574ffa197455db6c89359fd5eb
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Jan 20 23:51:04 2010 -0500

    ath5k: fix setup for CAB queue
    
    The beacon sent gating doesn't seem to work with any combination
    of flags.  Thus, buffered frames tend to stay buffered forever,
    using up tx descriptors.
    
    Instead, use the DBA gating and hold transmission of the buffered
    frames until 80% of the beacon interval has elapsed using the ready
    time.  This fixes the following error in AP mode:
    
       ath5k phy0: no further txbuf available, dropping packet
    
    Add a comment to acknowledge that this isn't the best solution.
    
    Signed-off-by: Bob Copeland <me@bobcopeland.com>
    Acked-by: Nick Kossifidis <mickflemm@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

commit 5d6ce628f986d1a3c523cbb0a5a52095c48cc332
Author: Bob Copeland <me@bobcopeland.com>
Date:   Wed Jan 20 23:51:03 2010 -0500

    ath5k: dont use external sleep clock in AP mode
    
    When using the external sleep clock in AP mode, the
    TSF increments too quickly, causing beacon interval
    to be much lower than it is supposed to be, resulting
    in lots of beacon-not-ready interrupts.
    
    This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.
    
    Signed-off-by: Bob Copeland <me@bobcopeland.com>
    Acked-by: Nick Kossifidis <mickflemm@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
