Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:22118 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752073AbYBNKTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 05:19:17 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 14 Feb 2008 19:19:01 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz,
	Ulrich Meis <meis@nets.rwth-aachen.de>
References: <1202209693.4395.29.camel@johannes.berg> <200802121225.02045.bruno@thinktube.com> <1202809923.11481.89.camel@johannes.berg>
In-Reply-To: <1202809923.11481.89.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802141919.01805.bruno@thinktube.com> (sfid-20080214_101919_533123_C18683AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 18:52:03 Johannes Berg wrote:
> > true. i was not aware that the beacon timestamp is taking PHY delays into
> > account and wrongly asumed that the RX timestamp should always be a bit
> > later.
> > (which is also what i saw on my atheros hardware: we usually get the RX
> > timestamp about 60 to 300 usec later than the beacon timestamp, but it's
> > quite likely that we have not calibrated everything 100% correctly.)
>
> Later actually surprises me, are you sure it's not earlier? If
> everything was calibrated perfectly it should be 192 usecs earlier (24*8
> bytes at the most common 1mbit beacon rate).

yes, i'm sure that it's later. our debug printk shows diff= (rx_tsf - 
beacon_tsf) and it's positive.

ulrich meis also confirmed that, but i think his message to the list got lost.

i'm not so surprised about that because the hardware would have to be 
calibrated 100% correctly to compensate for the TX delay as well as the RX 
delay (if both sides use ath5k) and it's really quite likely that we don't do 
that right for ath5k yet.

please see also my previous mail, i think that mactime is not well defined as 
well :(

bruno
