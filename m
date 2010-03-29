Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2411 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0C2CFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 22:05:50 -0400
Date: Sun, 28 Mar 2010 22:02:12 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 10/10] ath5k: Adaptive Noise Immunity
	(ANI) Implementation
Message-ID: <20100329020212.GA27628@hash.localnet>
References: <20100325054603.10697.48915.stgit@tt-desk> <20100325054952.10697.41515.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100325054952.10697.41515.stgit@tt-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 25, 2010 at 02:49:52PM +0900, Bruno Randolf wrote:
> +	} else if (strncmp(buf, "noise-low", 8) == 0) {
> +		ath5k_ani_set_noise_immunity_level(sc->ah, 0);
> +	} else if (strncmp(buf, "noise-high", 9) == 0) {

The number of characters here is off-by-one.

I also tried setting noise-high while in auto mode, but then the ani
debug file still showed the values at 0, is that to be expected?

On my hardware in my location, I don't really notice much of a difference
with/without ANI, but I definitely don't get any MIB storms, so it
gets my thumbs up.  I can post my ani file if you're interested.

-- 
Bob Copeland %% www.bobcopeland.com

