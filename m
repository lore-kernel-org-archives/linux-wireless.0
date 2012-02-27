Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49606 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2B0KfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 05:35:04 -0500
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>
In-Reply-To: <1330255537.4401.10.camel@jlt3.sipsolutions.net> (sfid-20120226_122612_633449_A5107FC1)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
	 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
	 (sfid-20120221_142005_568435_B65411B9)  <1330254954.4401.9.camel@jlt3.sipsolutions.net>
	 (sfid-20120226_121611_944331_8D721289)  <1330255537.4401.10.camel@jlt3.sipsolutions.net>
	 (sfid-20120226_122612_633449_A5107FC1)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Feb 2012 11:34:58 +0100
Message-ID: <1330338898.3483.10.camel@jlt3.sipsolutions.net> (sfid-20120227_113508_651607_FA1DAFD6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-02-26 at 12:25 +0100, Johannes Berg wrote:

> > Looking at this in mac80211 (ieee80211_enable_ht) in more detail for
> > other reasons, I believe our current behaviour is wrong in other cases
> > as well, not just the regulatory case.
> > 
> > If the AP is advertising HT40, but 40MHz-intolerant at the same time, I
> > believe we should also configure the channel to HT40, and prohibit using
> > 40 MHz TX for the time in which 40MHz-intolerant is set. Otherwise, when
> > the AP changes the 40MHz-intolerant flag, we may reconfigure our channel
> > too late to receive 40MHz transmissions. Also, some devices don't like
> > having the channel reconfigured while associated and doing so would be
> > particularly messy when we start talking about multi-channel operation.
> > 
> > I think overall better behaviour would be to set up the HT channel
> > already in ieee80211_mgd_auth() according to what the AP advertises,
> 
> Correction: ieee80211_mgd_assoc(), during auth we don't yet know what
> ciphers we'll use etc. so we don't yet know if HT will be disabled.
> However, during auth we also don't care about the channel type, so
> there's no problem for multi-channel.
> 
> > disregarding regulatory information and 40MHz-intolerant bits. While
> > associated, the only possible changes would be
> >  1) changes in HT opmode (protection, non-GF/non-HT sta etc.)
> >  2) 40MHz-intolerant changes (e.g. when such a STA joins)
> > This would affect both the driver and rate control, and for drivers
> > having rate control built-in we need to also tell them directly.


Come to think of it, we could also simply configure the channel to be
the right HT channel during auth, and then still associate as a non-HT
station later. I realise this isn't the best configuration, but given
that this is a corner case (TKIP used on an HT AP!) I think we can live
with that.

Sorry to flood you all with my incoherent ramblings -- anyone have
thoughts about this?

FWIW, in the interest of full disclosure :), part of the reason for this
is that our device hates having the channel reconfigured in the middle
of something, that causes issues with passive channels etc.

More importantly though, I think having to worry about reconfiguring the
channel will also be a big hassle in upcoming multi-channel code.

johannes

