Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:53500 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112AbZHBQ20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 12:28:26 -0400
Subject: Re: [PATCH 1/1] rfkill: add the GPS radio type
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1249199143.2007.2.camel@johannes.local>
References: <1249169809-11853-1-git-send-email-tomas.winkler@intel.com>
	 <1249171448.3491.32.camel@localhost.localdomain>
	 <1ba2fa240908012249s348a2412wca21de44f9b8cb71@mail.gmail.com>
	 <1249199143.2007.2.camel@johannes.local>
Content-Type: text/plain
Date: Sun, 02 Aug 2009 09:28:23 -0700
Message-Id: <1249230503.3491.43.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > we don't have a GPS subsystem, but even without it, I think this is a
> > > good thing to have.
> > 
> > GPS devices are usually serial devices.
> 
> Yeah, this is interesting -- do we want something like /dev/urfkill
> (cf. /dev/uinput), so that gpsd or whatever is controlling the GPS (same
> applies for 3G) can be controlled with rfkill?

on one hand I think urfkill might be needed, on the other hand I think
we should not do it at all. Currently I would think it is better to
force the RFKILL integration in the kernel so that we have proper
subsystem integration, or platform RFKILL switches or in cases like GPS
and WWAN/3G it will be driver integration. For 3G we already have the
hso.ko driver which has a killswitch and we just need to fix the other
ones. I am actually looking into it, if this is possible without an AT
parser inside the kernel.

So the GPS world is evolving right now and that everybody implements
them as kernel-tty-passthrough pseudo driver and then a binary only
daemon and then gpsd/gypsy on top of it will only survive for certain
amount of time. The binary component will not get wide acceptance. And
even if the binary only userspace component stays, we might still need a
proper GPS subsystem since using TTY as pure transport is holding us
back. Could be that AF_GPS would have been a way better choice. This
will sort itself out over time.

Regards

Marcel


