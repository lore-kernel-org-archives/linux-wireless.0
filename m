Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3247 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZBEPwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 10:52:11 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 5/5] ath5k: Update reset code
Date: Thu, 5 Feb 2009 10:51:52 -0500
Message-Id: <20090205154532.M30551@bobcopeland.com> (sfid-20090205_165217_741001_72A27536)
In-Reply-To: <20090204215706.GA5651@makis>
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 4 Feb 2009 23:57:06 +0200, Nick Kossifidis wrote
> * Update reset and sync with HALs
>  * Clean up eeprom settings and tweaking of initvals and put them on
separate functions
>  * Set/Restore 32KHz ref clk operation
>  * Add some more documentation
>  TODO: Spur mitigation, tpc, half/quarter rate, compression etc
> 
>  v2: Address comments from Bob and Felix and fix RSSI threshold bug
>  introduced on the first version of the patch
> 
>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

This works much better, except I still get some hard hangs 
occasionally.  Doesn't appear to be bmiss storm this time.  I did it 
with a VT up and didn't get an oops; I guess I'll try a serial console
or some printks.

I could trigger it via a few suspend-resume cycles, so I guess it's the
reset from ath5k_init().  Did you still have any problems with the 2425?

-- 
Bob Copeland %% www.bobcopeland.com


