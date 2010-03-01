Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:51496 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab0CAWCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 17:02:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Status of http://patchwork.kernel.org/patch/56785/
Date: Mon, 1 Mar 2010 23:01:50 +0100
Cc: Drapko Nitzhonot <drapkos@gmail.com>,
	linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	stable@kernel.org
References: <753864a31002271218r7fce0601l51f78efdf2576f75@mail.gmail.com> <201002272124.31863.mb@bu3sch.de> <20100301201214.GG2961@tuxdriver.com>
In-Reply-To: <20100301201214.GG2961@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201003012301.51478.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 01 March 2010 21:12:14 John W. Linville wrote:
> > An AP running 2.6.32 is unusable without those two patches.
> > However, it's rock stable as soon as those are applied.
> 
> commit a951ae2176b982574ffa197455db6c89359fd5eb
> Author: Bob Copeland <me@bobcopeland.com>
> Date:   Wed Jan 20 23:51:04 2010 -0500
> 
>     ath5k: fix setup for CAB queue
>     
>     The beacon sent gating doesn't seem to work with any combination
>     of flags.  Thus, buffered frames tend to stay buffered forever,
>     using up tx descriptors.
>     
>     Instead, use the DBA gating and hold transmission of the buffered
>     frames until 80% of the beacon interval has elapsed using the ready
>     time.  This fixes the following error in AP mode:
>     
>        ath5k phy0: no further txbuf available, dropping packet
>     
>     Add a comment to acknowledge that this isn't the best solution.
>     
>     Signed-off-by: Bob Copeland <me@bobcopeland.com>
>     Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> commit 5d6ce628f986d1a3c523cbb0a5a52095c48cc332
> Author: Bob Copeland <me@bobcopeland.com>
> Date:   Wed Jan 20 23:51:03 2010 -0500
> 
>     ath5k: dont use external sleep clock in AP mode
>     
>     When using the external sleep clock in AP mode, the
>     TSF increments too quickly, causing beacon interval
>     to be much lower than it is supposed to be, resulting
>     in lots of beacon-not-ready interrupts.
>     
>     This fixes http://bugzilla.kernel.org/show_bug.cgi?id=14802.
>     
>     Signed-off-by: Bob Copeland <me@bobcopeland.com>
>     Acked-by: Nick Kossifidis <mickflemm@gmail.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 

Ok, so indeed, there was no CC to stable. I think these are critical patches
that should go into the stable tree.

-- 
Greetings, Michael.
