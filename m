Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54905 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbZIAUbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 16:31:47 -0400
Subject: Re: Ath5k and proprietary extensions
From: Pavel Roskin <proski@gnu.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, ic.felix@gmail.com,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
References: <40f31dec0908282151t245912f0ye79684d4a519f3c9@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Sep 2009 16:31:41 -0400
Message-Id: <1251837101.14862.32.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-08-29 at 07:51 +0300, Nick Kossifidis wrote:

> a) X.R.: eXtended Range is a set of proprietary rates and some extra
> techniques (various hw tweaks etc) to enable long distance, low
> bandwidth links.

I'm not interested because it's ugly and we don't have a good reference
implementation.  Besides, there must be a reason why it's not in the
FreeBSD HAL.  Either it's patented or Atheros was ashamed to expose that
code.

> b) OFDM-only g settings for AR5211: AR5211 chips have support for
> draft-g (eg. no dynamic CCK/OFDM modulation, only OFDM). I don't know
> if we want to support it or not, removing the settings will save us
> some space and since it's a draft g implementation i don't think there
> are many compatible APs out there. Is there any possibility to support
> draft-g on mac80211/cfg80211 ? If not we can just drop it else it's
> just some extra data, no big deal.

If there is a simple way to support it, let's do it.  I think having
"pure G" may be a good idea in some situations, regardless of the
hardware limitations.  But that's something that should be done in
mac80211.

I would keep the initialization code for now.

That said, AR5210 and AR5211 are so rare, that we might consider
splitting them into separate drivers that would not be actively
maintained.

> c) Half/quarter rate channels (10/5MHz width) and turbo mode (double
> rate - 40MHz width): Hw can transmit with different channel width
> allowing us to operate on half, quarter or double rate (also called
> turbo mode).

It would be nice to be able to receive on wide and narrow channels, at
least in the monitor mode.  Generally, "be liberal in what you accept,
and conservative in what you send".

We'll need some API to set the bandwidth and radiotap flags to
communicate the bandwidth to the recipient.

> d) Fast frames: Hw can tx/rx jumbo frames of 3kbytes+ so fast frame
> aggregation is a way to make use of that hw feature by sending 2
> frames together (for more infos check out super ag white paper).

Likewise, it would be nice to receive them.

> e) Compression: Hw can do on-chip compression/decompression using
> standard Lempel Ziv algorithm per tx queue, MadWiFi implements this
> and uses a vendor IE to let others know that it supports this feature
> (same IE is used for all capabilities, fast frames, XR etc).

Same thing here, as long as we can reuse the existing kernel code for
decompression.

-- 
Regards,
Pavel Roskin
