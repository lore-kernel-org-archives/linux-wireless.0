Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59808 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082AbYJMWz3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2008 18:55:29 -0400
Subject: Re: [RFC/RFT] p54: Fix for big-endian architecture
From: Pavel Roskin <proski@gnu.org>
To: Christian Lamparter <chunkeey@web.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200810140055.34065.chunkeey@web.de>
References: <48EE20FB.4060700@lwfinger.net>
	 <1223936680.10113.7.camel@johannes.berg> <1223937392.27118.2.camel@dv>
	 <200810140055.34065.chunkeey@web.de>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 18:55:26 -0400
Message-Id: <1223938526.27118.6.camel@dv> (sfid-20081014_005533_594184_8696035F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 00:55 +0200, Christian Lamparter wrote:
> > I don't get that on i386.  But the values don't seem to be corrupted
> by
> > byte-swapping.
> >
> Hmm, this should be impossible since:
> "p54: report appropriate rate and band values for 802.11a"
> 5f840304b5f7dff0028407fa9b284aecb85a94aa

I see.  It's recent code, so maybe it wasn't broken yet when I was
testing it on i386.

This code in drivers/net/wireless/p54/p54common.c sets rate_idx:

  rx_status.rate_idx = (dev->conf.channel->band == IEEE80211_BAND_2GHZ ?
  hdr->rate : (hdr->rate - 4)) & 0xf;

printk() shows:

dev->conf.channel->band = 1, hdr->rate = 0, rx_status.rate_idx = 12

-- 
Regards,
Pavel Roskin
