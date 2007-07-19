Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4640 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764986AbXGSTd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 15:33:59 -0400
Date: Thu, 19 Jul 2007 15:10:52 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: andy@warmcat.com
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <larry.finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, johannes@sipsolutions.net
Subject: Re: [PATCH 2/2] bcm43xx-mac80211: Fix reported rx frequency and channel
Message-ID: <20070719191052.GC6603@tuxdriver.com>
References: <20070611103828.961999956@warmcat.com> <20070611103914.577674038@warmcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070611103914.577674038@warmcat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 11, 2007 at 11:38:30AM +0100, andy@warmcat.com wrote:
> bcm43xx-mac80211 is reporting bogus frequencies and channels back to
> mac80211 at the moment (eg, actual ch1 (2412MHz) reported as 2424MHz).
> 
> Prior to this patch, the hardware rx channel value is reported as
> starting at 0x18 and rising by 0x0a per channel.  Code in bcm43xx_xmit.c
> tries to take this value and add 2400 to it to get the rx frequency.
> It seems the intention is that the hardware reports the (rx freq - 2400),
> so we want the value starting at 0x0c and rising by 0x05 per channel.
> 
> If the value read is shifted one more bit to the right, it will
> succeed in doing this.  Therefore this patch increases the shifting constant
> by one and reduces the mask by one lsb.
> 
> The rx frequency reported in the radiotap rx and then, eg, tcpdump,
> is then correct.  I didn't test ch 14 but I guess the hardware is
> consistent about it.
> 
> CC: Larry Finger <larry.finger@lwfinger.net>
> CC: Michael Buesch <mb@bu3sch.de>
> Signed-off-by: Andy Green <andy@warmcat.com>

Larry, Michael, Johannes -- ack/nak?

John
-- 
John W. Linville
linville@tuxdriver.com
