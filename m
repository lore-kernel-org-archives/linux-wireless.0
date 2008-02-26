Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:57610 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYBZEjZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 23:39:25 -0500
Date: Mon, 25 Feb 2008 23:39:02 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: bruno randolf <bruno@thinktube.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	jirislaby@gmail.com, mcgrof@gmail.com
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Message-ID: <20080226043902.GA11185@hash.localnet> (sfid-20080226_043932_511191_1A237F24)
References: <E1JTfTv-0002bm-Qp@hash.localnet> <200802261113.34604.bruno@thinktube.com> <40f31dec0802251957o3b5b542vb5bf591fa2e73599@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0802251957o3b5b542vb5bf591fa2e73599@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2008 at 05:57:22AM +0200, Nick Kossifidis wrote:
> Bob try removing this and see what happens (in terms of
> performance/stability)...
> 
> 	if (ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
> 			AR5K_PHY_AGCCTL_CAL, 0, false)) {
> 		ATH5K_ERR(ah->ah_sc, "calibration timeout (%uMHz)\n",
> 			channel->center_freq);
> 		return -EAGAIN;
> 	}

It doesn't really have an effect, because even without this, the noise
floor calibration fails anyway.  I suspect by the time it gets in this
state the device is just hung generally.

So, I can't sustain a connection long enough to do iperf.  I got numbers
from madwifi though :)

Seems when it gets a big hunk of data the device barfs.  When I'm doing
something like ssh or just browsing a little, it's annoying but still
useable because most of the time it'll disassociate with the AP for a
few seconds, reassociate, and it's working again.

-- 
Bob Copeland %% www.bobcopeland.com 

