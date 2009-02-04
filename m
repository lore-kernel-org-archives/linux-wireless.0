Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2275 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606AbZBDEwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 23:52:33 -0500
Date: Tue, 3 Feb 2009 23:52:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
Message-ID: <20090204045208.GA8086@hash.localnet> (sfid-20090204_055237_031796_1750DE85)
References: <20090131023147.GE3342@makis> <20090203161317.M71923@bobcopeland.com> <40f31dec0902030828v453fdeafh9d47a156c07f6c9d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0902030828v453fdeafh9d47a156c07f6c9d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 03, 2009 at 06:28:47PM +0200, Nick Kossifidis wrote:
> Nice catch ;-)
> 
> Another difference i remembered is that we now don't set the TPC
> register to 3f (until we fix the whole tx power stuff). I'll try to
> reproduce this with my ar2425 as it turns it also has problems.

And the winning hunk is:

        if (ah->ah_version != AR5K_AR5210) {
                ath5k_hw_reg_write(ah, 0xffffffff, AR5K_PISR);
-               /* If we later allow tuning for this, store into sc structure */
-               data = AR5K_TUNE_RSSI_THRES |
-                       AR5K_TUNE_BMISS_THRES << AR5K_RSSI_THR_BMISS_S;
-               ath5k_hw_reg_write(ah, data, AR5K_RSSI_THR);
        }

(hmm, bmiss threshold, should've seen that before...)  

With that reverted from the rest of the patchset, I no longer get the
interrupt storm.  I do seem to get an occasional lockup at association
time, but I haven't caught an oops for that yet.  It could be unrelated.

-- 
Bob Copeland %% www.bobcopeland.com

