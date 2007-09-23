Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:64608 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754233AbXIWPru (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2007 11:47:50 -0400
Date: Sun, 23 Sep 2007 17:47:49 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Michael Buesch <mb@bu3sch.de>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: zd1211 config operation problem
Message-ID: <20070923154749.GB23532@deine-taler.de>
References: <200709231648.17107.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200709231648.17107.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:

> The zd1211 driver has a bug in the ieee80211 config callback.
> It currently unconditionally calls the set_channel() function,
> whether the device is running or not. This causes a failed
> bus access, if we set some config while the device is down.
> The driver must check if the device is running before setting
> any config on it (usb->initialized?).
> I tried to fix this, but I failed to find the correct condition
> to check for.

Thank you for highlighting this. My MAC address patch introduced a
flag mac->open, which could be useful here. We would need to
store the channel and set it, when the device is opened. One could
ask why the MAC stack is not handling this.

> I'm also wondering why we only set the channel in the config
> callback. Is the rest all unsupported by the device, like
> setting of TX power and so on?

We don't know how to do it; we are missing good documentation
about the hardware registers. The different RFs will also be a
factor.

-- 
Uli Kunitz
