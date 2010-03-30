Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49924 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0C3Cz7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 22:55:59 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 19:55:59 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19377.27899.218290.647143@gargle.gargle.HOWL>
Date: Tue, 30 Mar 2010 08:46:11 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/7] ath9k_htc: Fix TKIP encryption
In-Reply-To: <201003291629.02639.chunkeey@googlemail.com>
References: <19376.33506.672695.950934@gargle.gargle.HOWL>
	<201003291629.02639.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Monday 29 March 2010 12:37:22 Sujith wrote:
> > The FCS has to be stripped before the packet
> > is given to mac80211. Also, remove a redundant
> > assignment of skb length and include the FCS_LEN
> > when checking padding.
> > 
> > Fixing this issue makes TKIP work.
> > 
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > ---
> you don't need to strip the FCS, mac80211 can do that if necessary.
> (Or not, if you want to operate a network sniffer)
> 

I was aware of the flag - but there was some confusion about
whether the target FW strips the FCS or not. And it looks like it doesn't.
I'll send a modified patch, thanks for the review.

Sujith
