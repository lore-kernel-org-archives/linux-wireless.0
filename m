Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:44518 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751023Ab1HHJAf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 05:00:35 -0400
Date: Mon, 8 Aug 2011 12:00:24 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211_hwsim: Fix RX status reporting for HT
Message-ID: <20110808090024.GA4260@jm.kir.nu> (sfid-20110808_110038_174327_CE5B0DE3)
References: <20110806200700.GA13221@jm.kir.nu>
 <1312792388.4372.6.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1312792388.4372.6.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 08, 2011 at 10:33:08AM +0200, Johannes Berg wrote:
> On Sat, 2011-08-06 at 23:07 +0300, Jouni Malinen wrote:
> > RX_FLAG_HT must be included when reporting MCS rates. Without
> > this, mac80211 ended up dropping any frame sent at MCS index 12
> > or higher and that resulted in oddly random looking errors in
> > mac80211_hwsim tests.
> 
> This "solved" the timing thing you ran into with the unrelated
> suspend/resume patch then I guess?

Yes, it did. This was indeed the reason for semi-random dropping of
EAPOL frames and the randomness part made it difficult to figure out
what on earth was happening.

-- 
Jouni Malinen                                            PGP id EFC895FA
