Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3879 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935370AbZJOTsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 15:48:51 -0400
Date: Thu, 15 Oct 2009 15:45:30 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath5k: use noise calibration from madwifi hal
Message-ID: <20091015194530.GA32509@hash.localnet>
References: <1255544190-30020-1-git-send-email-me@bobcopeland.com> <40f31dec0910142357w6e395640uf9690498d0c3854e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0910142357w6e395640uf9690498d0c3854e@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 15, 2009 at 09:57:45AM +0300, Nick Kossifidis wrote:
> a) Please leave some comments to let people know that when nf
> calibration runs antennas are detached (it measures the noise produced
> from the card itself),  that if we enable nf calibration before agc
> calibration it always fails + the link to Atheros patent.

Sure, I'll add that back.  I read the patent but I'm not sure it applies
100%, it also talks at the end about keeping the rx antennas connected
and measuring the noise in the environment instead of just the thermal
noise.  I guess one way to know for sure is to hit it with noise and
look at the resulting values.

> b) What about thresh62 ? Do we also need to update/rewrite this value
> (we got it from EEPROM and write it on the register during reset) ?

Yeah, I looked at that, madwifi/legacy-hal also set it
(just the EEPROM value for the threshold bits) before doing the false
detect backoff stuff.

> Acked-by: Nick Kossifidis <mickflemm@gmail.com>

Thanks for the review!

-- 
Bob Copeland %% www.bobcopeland.com

