Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:38154 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567Ab0GSX3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 19:29:12 -0400
Message-ID: <4C44DFBB.6070604@davizone.at>
Date: Tue, 20 Jul 2010 01:28:59 +0200
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
References: <4C449C67.6010004@davizone.at> <1279571235.30478.5.camel@jlt3.sipsolutions.net> <AANLkTimxBt7dPcZrmAihWq9UKs77qS0cnAxQXIY_55ci@mail.gmail.com>
In-Reply-To: <AANLkTimxBt7dPcZrmAihWq9UKs77qS0cnAxQXIY_55ci@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2010-07-19 23:06, schrieb Gábor Stefanik:
> (BTW, I say that a GIWFREQ on a monitor interface should always return
> the channel the PHY is tuned to at the moment when it is issued. Most
> tools seem to expect this behavior.)

I agree, that would be the expected behaviour.

I am not very familar with the entire wireless subsystem yet, but wouldn't that
imply a interface change in cfg80211 and mac80211 to add an "get_channel" function?

Because if the card is hopping channels (e.g. because of 2 station interfaces on
different channels), only the driver itself can tell what's really the current
channel.

Nevertheless a default implementation for this new "get_channel" can be written
at mac80211 level (or even cfg80211?), which tries to find the current channel
by looking at all virtual interfaces, so only mac80211 drivers which allow
multiple channels (and non-mac80211 drivers) need to implement it.

Regards,
David
