Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43282 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1ADLGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 06:06:01 -0500
Subject: Re: Hidden SSID and WLAN powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1294138841.4166.38.camel@wimaxnb.nmp.nokia.com>
References: <1294136801.4166.30.camel@wimaxnb.nmp.nokia.com>
	 <1294138071.3511.0.camel@jlt3.sipsolutions.net>
	 <1294138841.4166.38.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 12:05:59 +0100
Message-ID: <1294139159.3511.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-04 at 13:00 +0200, Juuso Oikarinen wrote:

> > > As result, the STA does not ever enter WLAN PSM.
> > > 
> > > Anyone stumbled on this issue?
> > 
> > I haven't come across it, but we don't test hidden SSIDs much ...
> > sounds perfectly logical.
> 
> I would fix this, but I'm afraid I don't know enough about the mac80211
> to make a valid decision on how to go about that.
> 
> For PSM, this is an issue about the TIM IE, or more specifically the
> DTIM period. AFAIK, all the bss entries with the same BSSID should share
> the same DTIM period - I think this is valid for other cases with
> multiple SSIDs on one BSSID too.
> 
> 
> Any suggestions on how to approach this issue?

I'd probably see if you can update all the matching BSS structs with the
received beacon IEs.

johannes

