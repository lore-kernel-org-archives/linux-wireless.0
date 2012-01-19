Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757038Ab2ASRoD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jan 2012 12:44:03 -0500
Subject: Re: [RFC] rtlwifi: Convert to asynchronous firmware load
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, kay.sievers@vrfy.org,
	torvalds@linux-foundation.org, linux-wireless@vger.kernel.org
In-Reply-To: <4f18547e.Wk+PvRcReqCTbnIk%Larry.Finger@lwfinger.net> (sfid-20120119_183607_855723_7E85CDF5)
References: <4f18547e.Wk+PvRcReqCTbnIk%Larry.Finger@lwfinger.net>
	 (sfid-20120119_183607_855723_7E85CDF5)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Jan 2012 18:43:50 +0100
Message-ID: <1326995030.3631.7.camel@jlt3.sipsolutions.net> (sfid-20120119_184412_339487_A777471E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-01-19 at 11:35 -0600, Larry Finger wrote:

> This patch converts all rtlwifi-based drivers to use the asynchronous firmware
> loading mechanism. A completion queue entry is inititialized and the firmware
> load is started with the device initialization. The firmware-loaded callback routine
> issues a complete() call. The routine that uploads firmware to the device calls
> wait_for_completion_interruptible_timeout() with a 5 sec timeout.
> 
> The current patch is working, but as this is my first usage of the completion
> mechanism, I would like an expert to look it over. In particular, is it
> sufficient and prudent to issue a complete() call when the driver is unloaded
> so as to not leave a queue entry when the underlying struct is destroyed?

I don't think this makes a lot of sense. You're already registering with
mac80211, and then you wait inside start -- but that would be holding
the RTNL etc.

The way we do this in iwlwifi (and some others) makes more sense I
think: we only register with mac80211 after we actually load firmware,
i.e. in your rtl_fw_cb() you'd continue with ieee80211_register_hw() etc
instead of doing it in pci_probe(). If you never get firmware, you
obviously don't do that -- you unbind instead by calling
device_release_driver().

Doing that not only saves you the complexity of the completion but also
the potential deadlock (until timeout) when the tool that uploads the
firmware needs to acquire the rtnl for some reason and ifup is waiting
for the firmware.

johannes

