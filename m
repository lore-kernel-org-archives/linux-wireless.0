Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:45063
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517AbXGSTku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 15:40:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
Date: Thu, 19 Jul 2007 21:39:14 +0200
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	johannes@sipsolutions.net
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com> <20070719191052.GC6603@tuxdriver.com>
In-Reply-To: <20070719191052.GC6603@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200707192139.14930.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 19 July 2007 21:10:52 John W. Linville wrote:
> On Mon, Jun 11, 2007 at 11:38:30AM +0100, andy@warmcat.com wrote:
> > bcm43xx-mac80211 is reporting bogus frequencies and channels back to
> > mac80211 at the moment (eg, actual ch1 (2412MHz) reported as 2424MHz).
> > 
> > Prior to this patch, the hardware rx channel value is reported as
> > starting at 0x18 and rising by 0x0a per channel.  Code in bcm43xx_xmit.c
> > tries to take this value and add 2400 to it to get the rx frequency.
> > It seems the intention is that the hardware reports the (rx freq - 2400),
> > so we want the value starting at 0x0c and rising by 0x05 per channel.
> > 
> > If the value read is shifted one more bit to the right, it will
> > succeed in doing this.  Therefore this patch increases the shifting constant
> > by one and reduces the mask by one lsb.
> > 
> > The rx frequency reported in the radiotap rx and then, eg, tcpdump,
> > is then correct.  I didn't test ch 14 but I guess the hardware is
> > consistent about it.
> > 
> > CC: Larry Finger <larry.finger@lwfinger.net>
> > CC: Michael Buesch <mb@bu3sch.de>
> > Signed-off-by: Andy Green <andy@warmcat.com>
> 
> Larry, Michael, Johannes -- ack/nak?

nak, the issue is more difficult than this.
The point is that firmware changed and we don't know the exact revision, yet.
But it is actually no problem in reality, as the use-it-or-die
firmware doesn't have this problem. So if someone uses another
firmware than the one we suggest, he will probably run into more
problems, as well.
The fix is called: Use the correct firmware.
For now, at least.

Of course, the author of this patch should help us to find
out the exact firmware rev where this change happened. So we
can come up with a real fix.

-- 
Greetings Michael.
