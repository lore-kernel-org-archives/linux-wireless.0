Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:52970 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbXFUVqt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 17:46:49 -0400
Message-ID: <467AE9D8.2030602@warmcat.com>
Date: Thu, 21 Jun 2007 22:12:56 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Sam Leffler <sam@errno.com>
CC: Johannes Berg <johannes@sipsolutions.net>, radiotap@ojctech.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: radiotap for TX
References: <1182375853.3714.103.camel@johannes.berg> <467AE460.1070606@errno.com>
In-Reply-To: <467AE460.1070606@errno.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sam Leffler wrote:

> Note that using a monitor mode interface for transmit is a bad idea.  It
> is likely you will encounter devices that disallow any packet transmit
> when operating in monitor mode.  In practice this can be worked around
> by using a non-monitor operating mode for the device (e.g. adhoc mode
> w/o setting up beacons) but exporting this notion to user mode is bad
> IMO.  In net80211 there is an adhoc-demo mode which is essentially adhoc
> mode which was originally added for functionality found in old lucent
> cards but more recently has been used for building applications that
> want a "raw 802.11 device".

Hi -

In mac80211 you can run multiple network interfaces off the one physical
device, so you can have an associated WPA connection on one network
interface and another logical "monitor mode" network interface up on the
one physical device.  "Monitor mode" in this case can be the results of
a promiscuous hardware RX that is filtered for the Managed mode logical
interface ... this is AIUI.  So in that way "Monitor Mode" no longer
means a single modal device setting, but really the delivery somehow of
packets to a logical network interface that belongs to the physical device.

Injecting down a "monitor mode interface" then only means to use a
logical network interface that locally is configured to "Monitor Mode",
it doesn't have the same definite implication for physical device
configuration as before mac80211.  (Well.. AIUI).  So hopefully this
objection may not apply.

-Andy
