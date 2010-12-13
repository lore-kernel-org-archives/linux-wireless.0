Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0LMKUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Dec 2010 05:20:18 -0500
Subject: Re: [PATCH v2 5/7] ath9k_hw: fix PA predistortion training power
 selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, lrodriguez@atheros.com, vasanth@atheros.com
In-Reply-To: <201012131152.50095.chunkeey@googlemail.com>
References: <1292226056-56008-1-git-send-email-nbd@openwrt.org>
	 <1292226056-56008-4-git-send-email-nbd@openwrt.org>
	 <1292226056-56008-5-git-send-email-nbd@openwrt.org>
	 <201012131152.50095.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Dec 2010 11:20:14 +0100
Message-ID: <1292235614.3539.14.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-13 at 11:52 +0100, Christian Lamparter wrote:

> > +	return !!(mask & BIT(0)) + !!(mask & BIT(1)) + !!(mask & BIT(2));
> > +}
> > +
> I think there's a generic library function for that:
> hweight[8|16|32].

but note the !!, which makes this return 0, 1, 2 or 3 only, not the bit
weight.

johannes

