Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33398 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab2BNK47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:56:59 -0500
Subject: Re: [RFC/RFT 0/5] Firmware load change for various wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120213_203726_939695_C63C1EE3)
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
	 (sfid-20120213_203726_939695_C63C1EE3)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 11:56:55 +0100
Message-ID: <1329217015.3941.8.camel@jlt3.sipsolutions.net> (sfid-20120214_115702_731061_CCA4BCB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-13 at 13:37 -0600, Larry Finger wrote:
> These patches change 5 drivers that are now loading firmware from the probe
> routine. As each of them has the possibility of loading more than one
> file, the method of using request_firmware_nowait() has some difficulty,
> as it gets duplicate names in sysfs when the requests are launched in
> parallel.

Why not simply start off with one, and then when that returns
successfully request the other ones?

> When the callback routine is used to launch a second request,
> the structure gets messy, particularly with b43legacy, which loads 4
> firmware files for some hardware. My solution is to create a delayed work
> queue that is started in the probe routine with a delay of one second. The
> routine that is triggered does the normal request_firmware() calls
> and starts mac80211 when the firmware is available.

I suppose this works, but I'd be a little worried that when the driver
is built into the kernel it doesn't help much. I'm asking the udev
people to not answer async loads while in initramfs, but they'd still
give you a negative answer here, and they won't be able to tell the
difference between a synchronous request from a work item (which doesn't
block boot) and a synchronous request from probe (which does block
booting).

johannes

