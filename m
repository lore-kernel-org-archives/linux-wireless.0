Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:26290 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947Ab0CSKCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 06:02:35 -0400
Subject: Re: [PATCH 1/1] mac80211: Add support connection monitor in
 hardware
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Holger Schurig <holgerschurig@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <201003191051.09596.holgerschurig@gmail.com>
References: <1268975693-4329-1-git-send-email-juuso.oikarinen@nokia.com>
	 <201003191051.09596.holgerschurig@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Mar 2010 11:59:22 +0200
Message-ID: <1268992762.10120.728.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think you are mixing up the two sets of patches which I'm working on,
which seem to have ended up with confusingly similar names. Sorry about
that.

The connection quality monitoring stuff is configurable via nl80211.
This feature, the connection monitoring in hardware, is only configured
via the mac80211 flag IEEE80211_HW_CONNECTION_MONITOR, so no netlink
configuration here.

The main difference in functionality between hw and host connection
monitoring is, I think, power consumption - the host cpu needs to work
less if the hardware is handling this.

-Juuso

On Fri, 2010-03-19 at 10:51 +0100, ext Holger Schurig wrote:
> > The wl1271 has a feature which handles the connection monitor logic
> > in hardware, basically sending periodically nullfunc frames and reporting
> > to the host if AP is lost, after attempting to recover by sending
> > probe-requests to the AP.
> 
> Hmm, do you really need to make it configurable?
>
> * works the wl1271 firmware better with this set?
> * or better when unset?
> * or is it a "depends on" type answer?
> 
> As far as I understood you, it works better if the firmware detects the 
> connection loss and when mac80211 doesn't interfere. If this understanding is 
> true, then configuring this via nl80211 seems to be the wrong thing. Instead, 
> you should tell mac80211 about your wishes when registering your driver 
> against mac80211.



