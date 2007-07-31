Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45228 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755093AbXGaVAu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:00:50 -0400
Date: Tue, 31 Jul 2007 23:00:43 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Ulrich Kunitz <kune@deine-taler.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] zd1211rw-mac80211: debug output for mac80211 ops
Message-ID: <20070731230043.2cd80e2d@logostar.upir.cz>
In-Reply-To: <20070730225205.GA17252@deine-taler.de>
References: <20070730023128.99E927B409F@zog.reactivated.net>
	<200707292021.37845.flamingice@sourmilk.net>
	<20070730145125.GC6586@tuxdriver.com>
	<20070730225205.GA17252@deine-taler.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 31 Jul 2007 00:52:05 +0200, Ulrich Kunitz wrote:
> What about add_interface/remove_interfaces and monitor interfaces?

It depends on the IEEE80211_HW_MONITOR_DURING_OPER flag in hw.flags. If you
set the flag in the driver, then monitor interfaces work in the exactly
same way as STA or IBSS interfaces - the add_interface callback is called
(with conf.type equal to IEEE80211_IF_TYPE_MNTR) whenever user brings up a
monitor interface. You are responsible for switching the card to a monitor
mode (e.g. turning off hardware packet filtering).

If your hardware can't support monitor and regular interfaces concurrently,
don't set the IEEE80211_HW_MONITOR_DURING_OPER flag. In this case, the
stack calls add_interface with IEEE80211_IF_TYPE_MNTR in conf.type only
when there is no other interface active. If the user brings up a monitor
interface while he has a regular interface active, the driver is not
notified about that and the monitor interface is emulated by the stack with
a limited capabilities (this is called "soft monitor mode").

> There seems to be difference between "hard" and "soft" monitor
> mode. Currently I'm not sure what the semantics is.

You don't need to care about that in a driver, there is no difference for a
driver as you will never see a soft monitor interface; it's a
mac80211-level thing only.

>From the perspective of a user (and user space), the difference is as
follows:

"Hard monitor mode" is the usual monitor mode, i.e. all incoming frames,
regardless of their source/destination MAC addresses, are received through
the monitor interface.

"Soft monitor mode" is relevant only when the hardware has limited
capabilities for filter settings _and_ you have both regular (e.g. STA) and
monitor interface active (ifconfig up'ed). In such case, you receive only
frames addressed to your MAC address through the monitor interface. This is
still useful e.g. for debugging of network problems as you see management
frames.

> There seems to
> be also calls to add_interface/remote_interface with if_id -1. I
> guess that means something like all interfaces. The expected
> behaviour is not documented for that case. 

As Michael correctly said, don't care about the value, just store it and
hand it back to the stack when the stack wants it.

 Jiri

-- 
Jiri Benc
SUSE Labs
