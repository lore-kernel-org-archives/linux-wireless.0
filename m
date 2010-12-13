Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:57638 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0LMKwB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:52:01 -0500
Received: by fxm18 with SMTP id 18so6080562fxm.2
        for <linux-wireless@vger.kernel.org>; Mon, 13 Dec 2010 02:52:00 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2 5/7] ath9k_hw: fix PA predistortion training power selection
Date: Mon, 13 Dec 2010 12:28:48 +0100
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, lrodriguez@atheros.com, vasanth@atheros.com
References: <1292226056-56008-1-git-send-email-nbd@openwrt.org> <201012131152.50095.chunkeey@googlemail.com> <1292235614.3539.14.camel@jlt3.sipsolutions.net>
In-Reply-To: <1292235614.3539.14.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201012131228.49202.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 December 2010 11:20:14 Johannes Berg wrote:
> On Mon, 2010-12-13 at 11:52 +0100, Christian Lamparter wrote:
> 
> > > +	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
> > > +}
> > > +
> > I think there's a generic library function for that:
> > hweight[8|16|32].
> 
> but note the !!, which makes this return 0, 1, 2 or 3 only, not the bit
> weight.
> 
what?

the "Hamming weight/Population count" returns the
number of symbols that are different from the zero-symbol.

e.g.: The Hamming weight of 0x800000000000000000000000000000000
is just "1".

Furthermore, if tx_chainmask contains now more than just the available
tx_chains, then they can always mask the hweight* input with: 
AR9300_ANT_CHAIN_MASK (for 3x3) or
AR9300_ANT_COMMON_MASK (for future 4x4)

Regards,
	Chr
