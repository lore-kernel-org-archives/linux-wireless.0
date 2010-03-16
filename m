Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41254 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0CQAyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Mar 2010 20:54:01 -0400
Subject: Re: [RFC PATCHv2 0/2] mac80211: cfg80211: Roam trigger support
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1268657751-1042-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 14:52:29 -0700
Message-ID: <1268776349.8918.9.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-15 at 14:55 +0200, Juuso Oikarinen wrote:
> To implement good performance WLAN roaming, it is not sufficient to start
> scanning for other available AP's only after the currently serving association
> is lost.
> 
> The entity controlling the roaming will need to get indication of a
> deteriorating WLAN connection in order to start preparing for roaming already
> before the serving association is lost. This way, it can roam to a better AP
> perhaps even before the serving association becomes too bad in quality.
> 
> These patches propose an implementation facilitating this using a simple RSSI
> threshold and hysteresis approach.
> 
> These patches add a nl80211 interface for simply configuring a rssi threshold
> and hysteresis value to facilitate very basic connection quality monitoring.
> 
> For the triggering, these patches currently rely on HW support, host based
> triggering is not implemented, but could be added later if needed.

I'm curious. How does the HW/firmware do this?

In my testing on some hw, the beacon RSSI fluctuated wildly, so you'd
have to set the hysteresis pretty high.

johannes

