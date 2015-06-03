Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44505 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760126AbbFCNFY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 09:05:24 -0400
Message-ID: <1433336717.2274.13.camel@sipsolutions.net> (sfid-20150603_150640_950701_72CA8BAD)
Subject: Re: [PATCH] cfg80211: modify lower retry limit to 0
From: Johannes Berg <johannes@sipsolutions.net>
To: Robert Hodaszi <robert.hodaszi@digi.com>
Cc: davem@davemloft.net, royujjal@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 03 Jun 2015 15:05:17 +0200
In-Reply-To: <1433335560-17985-1-git-send-email-robert.hodaszi@digi.com> (sfid-20150603_145244_934464_B91AF765)
References: <1433335560-17985-1-git-send-email-robert.hodaszi@digi.com>
	 (sfid-20150603_145244_934464_B91AF765)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 14:46 +0200, Robert Hodaszi wrote:
> From: Robert Hodaszi <robert.hodaszi@digi.com>
> 
> To disable the transmit retries on RT28xx driver, the retry limit should
> be set to 0. The current lower limit (1) prevents it.

So actually - we have the same limit in nl80211... we should change both
at the same time.

However, I'm withdrawing my earlier comment. The dot11ShortRetryLimit
and dot11LongRetryLimit counters (which correspond to this) are defined
to have a range 1..255, and semantically are actually the number of
permissible transmission *attempts* (see their definition in
802.11-2012).

As a consequence, I'd say the driver is doing things wrong here and this
part is actually correct.

You could argue that this is userspace API that must never change,
but ... dunno. If you feel strongly about this I guess we could accept 0
and translate it to 1 in cfg80211 to get the correct semantics, but
you'd still have the driver bug then. I don't think we should accept 0
and pass it to the driver, since it need not expect such a value based
on the 802.11 spec.

johannes

