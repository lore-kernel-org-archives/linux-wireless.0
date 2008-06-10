Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38666 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755230AbYFJQbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 12:31:47 -0400
Date: Tue, 10 Jun 2008 19:31:07 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211_hwsim - simulator of 802.11 radios for mac80211
Message-ID: <20080610163106.GA5675@jm.kir.nu> (sfid-20080610_183151_684251_02D6E2D2)
References: <20080610105058.GA6961@jm.kir.nu> <1213096575.3668.6.camel@johannes.berg> <20080610124724.GB6961@jm.kir.nu> <1213103378.3668.10.camel@johannes.berg> <20080610150227.GA4913@jm.kir.nu> <1213110681.3668.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213110681.3668.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 10, 2008 at 05:11:21PM +0200, Johannes Berg wrote:

> Hmm. I suspect you called rx_irqsafe _after_ the radio was stopped (via
> mac80211's stop callback), and at stop time we also disable the tasklet,
> so something probably goes haywire if you tasklet_schedule a disabled
> tasklet.

Yes, that caused it. I added a new flag based on start/stop for
determining which interface are ready to accept new frames. I was
already doing this based on radio_enabled flag, but apparently that is
left set when setting the interface down.

-- 
Jouni Malinen                                            PGP id EFC895FA
