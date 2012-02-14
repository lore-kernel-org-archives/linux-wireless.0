Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab2BNQh0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 11:37:26 -0500
Subject: Re: [RFC/RFT 0/5] Firmware load change for various wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <4F3A8D30.3040804@lwfinger.net> (sfid-20120214_173532_491396_64EB4078)
References: <1329161826-11135-1-git-send-email-Larry.Finger@lwfinger.net>
	 (sfid-20120213_203726_939695_C63C1EE3) <1329217015.3941.8.camel@jlt3.sipsolutions.net>
	 <4F3A8D30.3040804@lwfinger.net> (sfid-20120214_173532_491396_64EB4078)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 17:37:20 +0100
Message-ID: <1329237440.3941.15.camel@jlt3.sipsolutions.net> (sfid-20120214_173729_299175_E82A5C9C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-14 at 10:34 -0600, Larry Finger wrote:

> >> When the callback routine is used to launch a second request,
> >> the structure gets messy, particularly with b43legacy, which loads 4
> >> firmware files for some hardware. My solution is to create a delayed work
> >> queue that is started in the probe routine with a delay of one second. The
> >> routine that is triggered does the normal request_firmware() calls
> >> and starts mac80211 when the firmware is available.
> >
> > I suppose this works, but I'd be a little worried that when the driver
> > is built into the kernel it doesn't help much. I'm asking the udev
> > people to not answer async loads while in initramfs, but they'd still
> > give you a negative answer here, and they won't be able to tell the
> > difference between a synchronous request from a work item (which doesn't
> > block boot) and a synchronous request from probe (which does block
> > booting).
> 
> I asked a variant of this question on LKML and the driverdevel ML, but got no 
> answer.
> 
> Unless I get a definitive answer, I'll have to go back to the chain loading, no 
> matter how messy.

I'm not even sure they've done *anything* until now, so I'm not sure it
matters. I believe the behavioural change that prompted these changes
will actually make it easier to implement the delay in a matter that
covers both this and async loading, so you may well be safe, I haven't
really understood the full details of the change that prompted all this.

johannes

