Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56064 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758188Ab3HIOcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Aug 2013 10:32:46 -0400
Date: Fri, 9 Aug 2013 10:32:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: Sujith Manoharan <sujith@msujith.org>
cc: Christian Lamparter <chunkeey@googlemail.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>,
	USB list <linux-usb@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>
Subject: ath9k_htc firmware problem [was: Re: FUSB200 xhci issue]
In-Reply-To: <20996.22876.834304.94010@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.44L0.1308091020170.1405-100000@iolanthe.rowland.org> (sfid-20130809_163252_863251_3F6EE851)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 9 Aug 2013, Sujith Manoharan wrote:

> Christian Lamparter wrote:
> > So, if we call usb_reset_device there and the driver is unbound
> > and later rebound. the next ath9k_htc .probe will start again and
> > again and again not knowing that it is already initialized 
> > (and we have a loop).
> 
> The HW/FW is buggy and this workaround is required:
> http://marc.info/?l=linux-usb&m=127960864905646&w=2

I see the problem.  The device loses its firmware when it gets reset or
its port is disabled.  This is really a very serious bug.  For one
thing, it means the device cannot support runtime PM.  (Not unless the
driver caches a copy of the firmware and reloads it every time the
device resumes.)  IMO a bug like this should disqualify the device from
being allowed to wear the USB logo.

One way around the problem might be for the firmware-loading thread to
issue a usb_set_configuration call to switch to config 0 (i.e., to
unconfigure the device), then patch the host's copy of the descriptor,
and then switch back to the original configuration.

This _will_ unbind and rebind the driver, so it definitely will need a
way to tell whether the firmware has already been loaded.

Alan Stern

