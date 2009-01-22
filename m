Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:51657 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866AbZAVTDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 14:03:18 -0500
Received: by yw-out-2324.google.com with SMTP id 9so2000388ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 11:03:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090122174721.M76206@bobcopeland.com>
References: <1232631861-6028-4-git-send-email-me@bobcopeland.com>
	 <40f31dec0901220936n27736162vade7e7c53e35a490@mail.gmail.com>
	 <20090122174721.M76206@bobcopeland.com>
Date: Thu, 22 Jan 2009 21:03:17 +0200
Message-ID: <40f31dec0901221103t10c433f4h7eea23b98a69cd70@mail.gmail.com> (sfid-20090122_200323_210323_EBEBB597)
Subject: Re: [PATCH 3/6] ath5k: continue reset sequence if gain calibration
	fails
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/1/22 Bob Copeland <me@bobcopeland.com>:
>
> Point is taken, although if gain calibration does fail, can we do anything
> about it other than log an error?  Looping forever in reset() is probably
> not a good idea.
>

We can check if the bit got cleared on next phy_calibrate and if it
hasn't we can reschedule it or schedule a reset.

> OTOH, I'm pretty sure miscalibrated phy is responsible for all the
> "unsupported jumbo" errors; I hexdumped some of those and they're all
> just noise.
>

Don't we get a phy error interrupt ?  I haven't looked into this ;-(

> (Side note, any reason we call reset() from ath5k_config_interface?
> We're not changing channels, just setting the bssid.)
>

Hmm, i'll check that and come back to you, i think we have to
re-initialize PCU but i'm not sure. Also if it's supposed to set the
bssid on a virtual if, we also have to set bssid mask to allow all
configured bssids for all vifs.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
