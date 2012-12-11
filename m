Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45074 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab2LKP34 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 10:29:56 -0500
Message-ID: <1355239813.9819.3.camel@jlt4.sipsolutions.net> (sfid-20121211_162959_777671_01EE7ACD)
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Date: Tue, 11 Dec 2012 16:30:13 +0100
In-Reply-To: <1355239503.9819.1.camel@jlt4.sipsolutions.net> (sfid-20121211_162447_361019_EEF95137)
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org>
	 <1355234105-12013-3-git-send-email-juhosg@openwrt.org>
	 <201212111608.43293.chunkeey@googlemail.com>
	 (sfid-20121211_160907_576808_50E80D43) <1355239503.9819.1.camel@jlt4.sipsolutions.net>
	 (sfid-20121211_162447_361019_EEF95137)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-12-11 at 16:25 +0100, Johannes Berg wrote:

> > If this issue just popped up now, I suspect that 
> > something else is silently corrupting our SKBs 
> > [or can anybody see how rt2x00 hit this issue?]

Oh, ok I assumed that rt2x00 RX SKBs are cleanly allocated, but now that
I trace the code further I see that while the SKBs are on the queue
inside rt2x00 they have something called "struct skb_frame_desc" on the
skb->cb, so this is what's causing the rt2x00 issue. This should be
mentioned in the rt2x00 commit, and all other drivers should be fine.

johannes

