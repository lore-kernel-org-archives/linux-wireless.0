Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:45668 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbXKWIWV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2007 03:22:21 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IvTno-0005ki-AN
	for linux-wireless@vger.kernel.org; Fri, 23 Nov 2007 03:22:20 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Pavel Roskin <proski@gnu.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200711230906.10441.hs4233@mail.mn-solutions.de>
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <20071122132635.GA3372@tuxdriver.com> <1195777405.11966.12.camel@dv>
	 <200711230906.10441.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Fri, 23 Nov 2007 03:22:17 -0500
Message-Id: <1195806137.12961.9.camel@dv> (sfid-20071123_082224_150114_915D34B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-11-23 at 09:06 +0100, Holger Schurig wrote:

> I actually think that while it's not associated, it should 
> periodically try to associcate with what's currently defined 
> (e.g. ESSID, fixed AP mac, key settings etc).

What you are asking for is roaming in the kernel.  Orinoco relies on
roaming in the firmware.  MadWifi implemented it in the kernel code, but
it's a heavily over-engineered piece of software and shouldn't be an
example for the kernel drivers.

wpa_supplicant gives you roaming in the userspace.  There are some other
roaming agents available.  Having similar code in the kernel is
debatable, but please realize that you are asking for a feature, not
reporting a bug.

wpa_supplicant may be what you need to solve your roaming problems,
although it doesn't play well with Fedora scripts, and I don't know if
any distro gets networking right.

-- 
Regards,
Pavel Roskin

