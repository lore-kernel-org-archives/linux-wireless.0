Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2341 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389AbZAVS2J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 13:28:09 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 3/6] ath5k: continue reset sequence if gain calibration fails
Date: Thu, 22 Jan 2009 13:28:01 -0500
Message-Id: <20090122174721.M76206@bobcopeland.com> (sfid-20090122_192813_436841_2A745BD0)
In-Reply-To: <40f31dec0901220936n27736162vade7e7c53e35a490@mail.gmail.com>
References: <1232631861-6028-4-git-send-email-me@bobcopeland.com> <40f31dec0901220936n27736162vade7e7c53e35a490@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Jan 2009 19:36:45 +0200, Nick Kossifidis wrote
> Again i've already fixed that on my local branch (i said i'll update
> reset code and i did, i just have to make some tests first), it's what
> both HALs do. Notice that if offset calibration has not completed, i/q
> calibration can't work (according to patent doc) and  noise floor
> calibration always fails on some chips.

Fair enough, sorry for stepping on your toes :(  This one can be dropped
too.

Point is taken, although if gain calibration does fail, can we do anything
about it other than log an error?  Looping forever in reset() is probably
not a good idea.

OTOH, I'm pretty sure miscalibrated phy is responsible for all the 
"unsupported jumbo" errors; I hexdumped some of those and they're all 
just noise.

(Side note, any reason we call reset() from ath5k_config_interface?
We're not changing channels, just setting the bssid.)

-- 
Bob Copeland %% www.bobcopeland.com

