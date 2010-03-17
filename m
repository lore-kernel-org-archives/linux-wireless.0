Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42981 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab0CQNar (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Mar 2010 09:30:47 -0400
Date: Wed, 17 Mar 2010 09:22:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCHv3 0/2] mac80211: cfg80211: Roam trigger support
Message-ID: <20100317132236.GC2990@tuxdriver.com>
References: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1268830877-5162-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 17, 2010 at 03:01:15PM +0200, Juuso Oikarinen wrote:
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
> 
> These patches have been tested with the wl1271 driver.
> 
> Thanks in advance for your comments and suggestions.
> 
> Juuso Oikarinen (2):
>   cfg80211: Add connection quality monitoring support to nl80211
>   mac80211: Add support for connection quality monitoring

Any idea what other hardware (besides libertas) supports this concept?
Do you anticipate adding a host-based implementation to mac80211?

Is RSSI really a useful enough indicator for this function?
Will applications actually use it?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
