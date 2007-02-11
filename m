Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:53133 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbXBKAza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 19:55:30 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HG2yr-0008UG-QL
	for linux-wireless@vger.kernel.org; Sat, 10 Feb 2007 19:54:13 -0500
Subject: Re: [ANNOUNCE] d80211 based driver for Intel PRO/Wireless 3945ABG
From: Pavel Roskin <proski@gnu.org>
To: "Hesse, Christian" <mail@earthworm.de>
Cc: James Ketrenos <jketreno@linux.intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <200702101424.00156.mail@earthworm.de>
References: <45CCE3CA.4050904@linux.intel.com>
	 <200702101424.00156.mail@earthworm.de>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 19:55:23 -0500
Message-Id: <1171155323.5573.7.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

[I'm trimming the cc: a little bit]

On Sat, 2007-02-10 at 14:23 +0100, Hesse, Christian wrote:
> On Friday 09 February 2007 22:12, James Ketrenos wrote:
> > We are pleased to announce the availability of a new driver for the
> > Intel PRO/Wireless 3945ABG Network Connection adapter.
> 
> Wow, great news on this rainy saturday! ;-)
> 
> The driver works perfectly, I'm writing this mail via wireless link. However 
> there are two things to note:
> 
> The driver generates two network devices. The second one is for promicious 
> mode? Is there any chance to disable the interface? ifrename renamed the 
> wrong one to wlan0 and I had to tell my system to use eth1 for the wireless 
> connection.

I think one of the devices is wmaster0.  It's better that you just
ignore it.  The effort is already underway to make that interface
hidden.

In the meantime, you can use the "arp" condition in /etc/iftab.
Ethernet is 1 (that includes the original wlan0), IEEE 802.11 is 801
(that's the master devices and devices in monitor mode).  For example:

wifi* arp 801
eth* arp 1

> Second problem is that I can't unload the module. I get the message "FATAL: 
> Module iwlwifi is in use." even if both interfaces are down.

I cannot reproduce this problem.  Please see the output of "lsmod" and
the kernel log for possible oopses.

-- 
Regards,
Pavel Roskin

