Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46343 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2LKPia (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 10:38:30 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1682698bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 07:38:28 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 3/3] p54: zero-out rx_status
Date: Tue, 11 Dec 2012 16:38:15 +0100
Cc: Gabor Juhos <juhosg@openwrt.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <1355234105-12013-1-git-send-email-juhosg@openwrt.org> <1355239503.9819.1.camel@jlt4.sipsolutions.net> <1355239813.9819.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355239813.9819.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201212111638.16033.chunkeey@googlemail.com> (sfid-20121211_163833_592177_D603C2B0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 11, 2012 04:30:13 PM Johannes Berg wrote:
> On Tue, 2012-12-11 at 16:25 +0100, Johannes Berg wrote:
> 
> > > If this issue just popped up now, I suspect that 
> > > something else is silently corrupting our SKBs 
> > > [or can anybody see how rt2x00 hit this issue?]
> 
> Oh, ok I assumed that rt2x00 RX SKBs are cleanly allocated, but now that
> I trace the code further I see that while the SKBs are on the queue
> inside rt2x00 they have something called "struct skb_frame_desc" on the
> skb->cb, so this is what's causing the rt2x00 issue. This should be
> mentioned in the rt2x00 commit, and all other drivers should be fine.
Ah, you are right. I assumed that rt2x00_queue stuff was only important
for TX. But it seems rt2x00 pci devices use them as well for RX.

Regards,
	Chr
