Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:36866 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828Ab2B0Lcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 06:32:35 -0500
Date: Mon, 27 Feb 2012 13:32:12 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Paul Stewart <pstew@chromium.org>, linux-wireless@vger.kernel.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Arik Nemtsov <anamtsov@gmail.com>,
	Eliad Peller <eliad@wizery.com>
Subject: Re: [RFCv2] mac80211: Don't let regulatory make us deaf
Message-ID: <20120227113212.GA4576@w1.fi> (sfid-20120227_123239_180617_CFC1AD77)
References: <20120221060932.8A38C20517@glenhelen.mtv.corp.google.com>
 <20120221131946.AC1AD20578@glenhelen.mtv.corp.google.com>
 <1330254954.4401.9.camel@jlt3.sipsolutions.net>
 <1330255537.4401.10.camel@jlt3.sipsolutions.net>
 <1330338898.3483.10.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1330338898.3483.10.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 11:34:58AM +0100, Johannes Berg wrote:
> Come to think of it, we could also simply configure the channel to be
> the right HT channel during auth, and then still associate as a non-HT
> station later. I realise this isn't the best configuration, but given
> that this is a corner case (TKIP used on an HT AP!) I think we can live
> with that.

In general, it should be fine to enable HT/HT40 configuration for
receive and just make sure we never transmit using parameters not
allowed by regulatory or something like HT+TKIP rules. However, there
could be some hardware/firmware designs that would refuse HT+TKIP at
lower layer, so skipping the channel (re-)configuration could
potentially cause some problems. I'm not aware of any specific example
of this, though, so I can only speculate that such a thing could exist.

> More importantly though, I think having to worry about reconfiguring the
> channel will also be a big hassle in upcoming multi-channel code.

Agreed.

-- 
Jouni Malinen                                            PGP id EFC895FA
