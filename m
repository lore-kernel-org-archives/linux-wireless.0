Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38276 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbbKZRZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 12:25:29 -0500
Message-ID: <1448558726.2167.34.camel@sipsolutions.net> (sfid-20151126_182532_354531_B56E4569)
Subject: Re: [PATCH] mac80211: Parse legacy and HT rate in injected frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Eckelmann <sven@narfation.org>, linux-wireless@vger.kernel.org
Cc: Simon Wunderlich <sw@simonwunderlich.de>
Date: Thu, 26 Nov 2015 18:25:26 +0100
In-Reply-To: <1444746990-17526-1-git-send-email-sven@narfation.org>
References: <1444746990-17526-1-git-send-email-sven@narfation.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-10-13 at 16:36 +0200, Sven Eckelmann wrote:
> 
> The removal of this feature heavily reduced the usefulness of frame
> injection when wanting to simulate specific transmission behavior.
> Having
> rate parsing together with MCS rates and retry support allows a fine
> grained selection of the tx behavior of injected frames for these
> kind of
> tests.

Assuming you have hardware to do it, but that requirement seems fair.

> We have required the support for rate parsing (legacy + HT) for some
> tests.
> It is already known that this may not be the best place to set this
> flag
> (IEEE80211_TX_CTRL_RATE_INJECT) but the main flags field is already
> full.

It seems you could perhaps put that into struct
ieee80211_tx_data::flags? Or is it required somewhere outside the
mac80211 processing?

Otherwise I think the place is fine? What issue do you have with it?

> There is also the problem that powersave could overwrite the rate
> control
> fields - so either we disable powersave queueing or find a different
> solution.

I have no idea what you mean? The flag - as you have it now - should be
preserved, no? Perhaps if you moved the flag into tx_data then it
wouldn't be, and that's a good argument for not moving it?

> But maybe this feature is also not wanted anymore in the mac80211
> driver.

Well, I'm open to adding the code if you need it. Could consider VHT as
well, I guess.

Adding the check to the fast-xmit path seems neither right nor
necessary though, since that shouldn't get invoked for injection to
start with?

johannes
