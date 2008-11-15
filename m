Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36697 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYKOPBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Nov 2008 10:01:10 -0500
Date: Sat, 15 Nov 2008 09:56:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] Agere PCMCIA sometimes takes very long time to
	associate with 9.48 FW
Message-ID: <20081115145655.GB31553@tuxdriver.com> (sfid-20081115_160133_400342_0BDD161B)
References: <200810191436.13298.arvidjaar@mail.ru> <491349BC.8090606@gmail.com> <49134F66.4020608@gmail.com> <200811151115.48750.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200811151115.48750.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 11:15:47AM +0300, Andrey Borzenkov wrote:

> - we should not be doing it in ->open. It is technically legal to set
> wireless parameters before "icfonfig up" and we lose all of them. I will
> try next week with similar patch in orinoco_stop().

That seems wrong...

> - I am still not even sure we should do it at all. What is sematic of
> ifconfig up/down w.r.t. wireless parameters? I.e. is "ifconfig down"
> expected to clean all device state and start from scratch?

No.  Unfortunately, it is mostly a matter of opinion as to what
wireless extensions expects.

FWIW, some drivers (particularly mac80211-based ones) require the
device to be 'down' in order to change the mode (i.e. "managed",
"ad-hoc", etc).  Further, some drivers (particularly mac80211-based
ones) use the setting of the SSID as a trigger for an association.
So for example, bringing-up a mac80211-based device needs to look
something like this:

	ifconfig wlan0 down
	iwconfig wlan0 mode Managed
	ifconfig wlan0 up
	iwconfig wlan0 essid SSID

Beyond that, taking the device down would probably cause a loss of
association.  So later marking it up would be insufficient without
also (re-)setting the SSID.  But, e.g. channel settings should remain
in effect.

Hopefully I haven't confused the issue -- I'll stop now. :-)

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
