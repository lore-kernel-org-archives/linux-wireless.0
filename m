Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab0EXIFs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 04:05:48 -0400
Subject: Re: [PATCH] Silence debug prints when using adhoc mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100523162240.GZ19669@nalle>
References: <20100523162240.GZ19669@nalle>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 May 2010 10:05:45 +0200
Message-ID: <1274688345.3743.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-23 at 19:22 +0300, Mikko Rapeli wrote:
> This is flooded to syslog quite a few times when connecting to another
> Linux box in adhoc mode. Syslog files fill up the disk fast:
> 
> $ dmesg | tail -10
> [ 1986.772018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.776149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.780076] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.784020] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.788149] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.792108] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.796070] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.800018] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.804186] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)
> [ 1986.808072] wlan0: No active IBSS STAs - trying to scan for other IBSS networks with same SSID (merge)

Hm. That's not supposed to happen over and over again that quickly, only
every few seconds. I wonder if that's related to the other timer issue
that we saw in ibss.

johannes

