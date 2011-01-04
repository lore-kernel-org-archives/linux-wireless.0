Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42368 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ADKrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 05:47:53 -0500
Subject: Re: Hidden SSID and WLAN powersave
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1294136801.4166.30.camel@wimaxnb.nmp.nokia.com>
References: <1294136801.4166.30.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 11:47:51 +0100
Message-ID: <1294138071.3511.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-04 at 12:26 +0200, Juuso Oikarinen wrote:
> Hi,
> 
> I stumbled upon a PSM issue when a hidden SSID is used. It seems that
> mac80211 is not going to power-save mode with hidden SSID AP's at all.
> 
> As far as I can see the following happens:
> 
> - When generally scanning, the AP is getting a bss entry with a zero
> SSID.
> - When associating, a probe-req is sent to the AP with the SSID, and as
> result a probe-response is received with the hidden SSID in place -> a
> second bss entry is created for the AP, now with the real SSID.
> - After association, mac80211 executes ieee80211_recalc_ps(), but does
> not go to powersave because the beacon-ies are missing.
> - A new beacon is received for the BSSID, but it updates the bss entry
> with the zero SSID, ieee80211_recalc_ps() gets called, but for the
> associated bss entry the beacon-ies are still missing.
> 
> As result, the STA does not ever enter WLAN PSM.
> 
> Anyone stumbled on this issue?

I haven't come across it, but we don't test hidden SSIDs much ...
sounds perfectly logical.

johannes

