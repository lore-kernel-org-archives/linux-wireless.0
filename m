Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:50925 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbXHOCmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 22:42:38 -0400
Date: Tue, 14 Aug 2007 19:41:35 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] hostapd: remove PRISM2_PARAM_NEXT_MODE
Message-ID: <20070815024135.GF1415@jm.kir.nu>
References: <20070814093254.021041000@sipsolutions.net> <20070814093410.322846000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070814093410.322846000@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2007 at 11:32:58AM +0200, Johannes Berg wrote:
> 802.11 A is easily distinguishable based on frequency, and the difference
> between 802.11B/G isn't really done well in mac80211 with most 802.11G
> drivers supporting only 802.11G channels and no B channels

Agreed on 802.11a vs. b/g as long as frequency is used for configuration
(as is the case here; channel numbers would not have been unique).
Dropping the b vs. g is somewhat unfortunate, though.

> What reason is there anyway for distinguishing between an 802.11G and an
> 802.11B channel? Regulatory? In that case, well, needs lots of work.

The original reason for adding that was that some hardware designs have
separate modes for 802.11b and 802.11g and there may be cases where the
802.11b mode would be preferred. I'm not sure about all the differences
in hardware, but I would assume this could include power use (save power
by being able to use slower internal frequency since there is less
things to do and by disabling some functionality) and maybe in some
cases just the fact of disabling all non-802.11b extensions.

Furthermore, frequency may not be unique in future with additional PHY
changes. Having option of setting both a "mode" and frequency is a pair
is a good way of making sure the design is more future proof in this
area.

-- 
Jouni Malinen                                            PGP id EFC895FA
