Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51308 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab2BZLQG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Feb 2012 06:16:06 -0500
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com> (sfid-20120221_142005_568435_B65411B9)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	 (sfid-20120221_142005_568435_B65411B9)
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 26 Feb 2012 12:15:54 +0100
Message-ID: <1330254954.4401.9.camel@jlt3.sipsolutions.net> (sfid-20120226_121611_944331_8D721289)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-20 at 21:25 -0800, Paul Stewart wrote:
> When regulatory information changes our HT behavior (e.g,
> when we get a country code from the AP we have just associated
> with), we should use this information to change the power with
> which we transmit, and what channels we transmit.  Sometimes
> the channel parameters we derive from regulatory information
> contradicts the parameters we used in association.  For example,
> we could have associated specifying HT40, but the regulatory
> rules we apply may forbid HT40 operation.
> 
> In the situation above, we should reconfigure ourselves to
> transmit in HT20 only, however it makes no sense for us to
> disable receive in HT40, since if we associated with these
> parameters, the AP has every reason to expect we can and
> will receive packets this way.

Looking at this in mac80211 (ieee80211_enable_ht) in more detail for
other reasons, I believe our current behaviour is wrong in other cases
as well, not just the regulatory case.

If the AP is advertising HT40, but 40MHz-intolerant at the same time, I
believe we should also configure the channel to HT40, and prohibit using
40 MHz TX for the time in which 40MHz-intolerant is set. Otherwise, when
the AP changes the 40MHz-intolerant flag, we may reconfigure our channel
too late to receive 40MHz transmissions. Also, some devices don't like
having the channel reconfigured while associated and doing so would be
particularly messy when we start talking about multi-channel operation.

I think overall better behaviour would be to set up the HT channel
already in ieee80211_mgd_auth() according to what the AP advertises,
disregarding regulatory information and 40MHz-intolerant bits. While
associated, the only possible changes would be
 1) changes in HT opmode (protection, non-GF/non-HT sta etc.)
 2) 40MHz-intolerant changes (e.g. when such a STA joins)
This would affect both the driver and rate control, and for drivers
having rate control built-in we need to also tell them directly.

Thoughts?

johannes

