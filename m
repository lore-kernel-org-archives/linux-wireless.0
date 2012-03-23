Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2CWJUS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 05:20:18 -0400
Message-ID: <1332494416.3506.16.camel@jlt3.sipsolutions.net> (sfid-20120323_102021_826095_222475C2)
Subject: Re: [RFC 11/12] mac80211: split offchannel functions to per-vif
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82?= Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 23 Mar 2012 10:20:16 +0100
In-Reply-To: <4F6C3F32.7040700@tieto.com>
References: <ccb26d54-38f2-478e-95d9-85fa1aea62c2@FIVLA-EXHUB02.eu.tieto.com>
		 (sfid-20120320_154026_591857_E0DB8EEA) <1332492804.3506.7.camel@jlt3.sipsolutions.net>
	 <4F6C3F32.7040700@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-23 at 10:15 +0100, Michał Kazior wrote:
> Johannes Berg wrote:
> > This seems very odd. Why would one vif be off-channel, and the other be
> > on-channel? That makes no sense, off-channel is a global state.
> 
> Should mac80211 care if the device does channel-hopping? What if it's 
> possible for off-channel to be done simultaneously because the device 
> has two radios?

What do you mean by channel hopping? IBSS-like behaviour?

The two radios case is interesting, but is it really relevant right now?
I suspect the first case of it we'll see will be 11ad and then it's two
different bands.

> Maybe off-channel should also be reworked more to support multiple 
> scenarios?

What scenarios do you have in mind?

> > My thinking here right now is that mac80211-based off-channel and
> > scanning will only be supported for devices that don't implement
> > multi-channel, since all others really need to do the channel scheduling
> > themselves.
> 
> Software off-channel isn't used only for scanning, or is it?

It's only used for scanning & P2P-device activities right now, I could
see it being used for FT-OTA (with resource reservation) too in the
future, if needed, but that's about it.

johannes

