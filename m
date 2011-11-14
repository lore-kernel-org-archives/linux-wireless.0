Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45058 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1KNP0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 10:26:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.77)
	(envelope-from <johannes@sipsolutions.net>)
	id 1RPyQb-0000mM-TW
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 16:26:34 +0100
Subject: Re: off- & multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1320844134.3845.61.camel@jlt3.sipsolutions.net> (sfid-20111109_140902_212963_943EDBDE)
References: <1320844134.3845.61.camel@jlt3.sipsolutions.net>
	 (sfid-20111109_140902_212963_943EDBDE)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 16:25:44 +0100
Message-ID: <1321284344.10264.6.camel@jlt3.sipsolutions.net> (sfid-20111114_162638_341634_74878855)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I spent a bit more time thinking about this, and am growing more and
more unhappy with the current state of mac80211. Why? For example the
fact that we've been adding workarounds left & right for a while, just
two recent examples:
* my tx_sync
* dummy AP station

At the same time, we haven't really defined the operation sequences we
have (or want to have) and a lot of the operations are getting hard to
understand, e.g. bss_info_changed() with all its different parameters.
Take
https://github.com/TI-OpenLink/wl12xx/commit/ed280a5d3b3141a6de8836993e851469cb4a8982 for example, we never even defined in what order stations should be added and thus never checked it either.

Similarly, devices are starting to differ more and more. It's not longer
the clear separation between full-MAC (cfg80211 driver) and soft-MAC
(mac80211 driver) -- even "soft-MAC" devices are acquiring features like
rate control (wl12xx, mwl8k, ath9k_htc, iwlwifi somewhat), probe
response offload (wl12xx) and various other offloads. (And realistically
that separation was never really quite as black & white)

I'm slowly coming to the conclusion that we need to give drivers more
structured information and move further away mac80211 fully controlling
all operations. Especially as we go into multi-channel use, this becomes
virtually impossible. Some of what I'm saying/thinking now is obviously
influenced by our (Intel's) hardware/firmware design, but I'm trying not
to get too entrenched in that.


One of the major points for me is roaming -- our older devices aren't
really able to deal with authenticating before breaking the connection,
and this is requiring a lot of workarounds in the drivers and I think it
also causes a few bugs. OTOH, wpa_supplicant expects to be able to auth
before it disconnects and we explicitly maintain multiple
authentications in cfg80211 -- maybe the latter was a mistake (yes,
mine, but I guess I have to learn)?

With our newer devices we could send the authentication in a
remain-on-channel phase, and I think for TI the situation is similar,
but with older devices the simple channel switching to auth with a new
AP and then switching back is definitely a source of some issues, e.g.
not draining aggregation queues properly since aggregation state is lost
in the device when we do this. Yes -- this can probably be worked around
in the driver, but is it worth it?

The biggest issue here is that we need wpa_s to do the authentication
handshake, especially with things like FT (OTA) or SAE.

I'm unsure how to handle this -- thoughts anyone?

johannes 

