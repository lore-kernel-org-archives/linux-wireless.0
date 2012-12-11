Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36770 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753782Ab2LKRTY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 12:19:24 -0500
Message-ID: <50C76B1C.5070309@openwrt.org> (sfid-20121211_181927_735103_589ABF60)
Date: Tue, 11 Dec 2012 18:19:24 +0100
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>  <1355234105-12013-3-git-send-email-juhosg@openwrt.org>  <201212111608.43293.chunkeey@googlemail.com>  (sfid-20121211_160907_576808_50E80D43) <1355239503.9819.1.camel@jlt4.sipsolutions.net>  (sfid-20121211_162447_361019_EEF95137) <1355239813.9819.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355239813.9819.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012.12.11. 16:30 keltezéssel, Johannes Berg írta:
> On Tue, 2012-12-11 at 16:25 +0100, Johannes Berg wrote:
> 
>>> If this issue just popped up now, I suspect that 
>>> something else is silently corrupting our SKBs 
>>> [or can anybody see how rt2x00 hit this issue?]
> 
> Oh, ok I assumed that rt2x00 RX SKBs are cleanly allocated, but now that
> I trace the code further I see that while the SKBs are on the queue
> inside rt2x00 they have something called "struct skb_frame_desc" on the
> skb->cb, so this is what's causing the rt2x00 issue. This should be
> mentioned in the rt2x00 commit, and all other drivers should be fine.

Ok, I will update the commit message and will resend the rt2x00 patch only.
Thank you for the review!

-Gabor
