Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:64286 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1ADLBG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 06:01:06 -0500
Subject: Re: Hidden SSID and WLAN powersave
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1294138071.3511.0.camel@jlt3.sipsolutions.net>
References: <1294136801.4166.30.camel@wimaxnb.nmp.nokia.com>
	 <1294138071.3511.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 13:00:41 +0200
Message-ID: <1294138841.4166.38.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-04 at 11:47 +0100, ext Johannes Berg wrote:
> On Tue, 2011-01-04 at 12:26 +0200, Juuso Oikarinen wrote:
> > Hi,
> > 
> > I stumbled upon a PSM issue when a hidden SSID is used. It seems that
> > mac80211 is not going to power-save mode with hidden SSID AP's at all.
> > 
> > As far as I can see the following happens:
> > 
> > - When generally scanning, the AP is getting a bss entry with a zero
> > SSID.
> > - When associating, a probe-req is sent to the AP with the SSID, and as
> > result a probe-response is received with the hidden SSID in place -> a
> > second bss entry is created for the AP, now with the real SSID.
> > - After association, mac80211 executes ieee80211_recalc_ps(), but does
> > not go to powersave because the beacon-ies are missing.
> > - A new beacon is received for the BSSID, but it updates the bss entry
> > with the zero SSID, ieee80211_recalc_ps() gets called, but for the
> > associated bss entry the beacon-ies are still missing.
> > 
> > As result, the STA does not ever enter WLAN PSM.
> > 
> > Anyone stumbled on this issue?
> 
> I haven't come across it, but we don't test hidden SSIDs much ...
> sounds perfectly logical.

I would fix this, but I'm afraid I don't know enough about the mac80211
to make a valid decision on how to go about that.

For PSM, this is an issue about the TIM IE, or more specifically the
DTIM period. AFAIK, all the bss entries with the same BSSID should share
the same DTIM period - I think this is valid for other cases with
multiple SSIDs on one BSSID too.


Any suggestions on how to approach this issue?

-Juuso



