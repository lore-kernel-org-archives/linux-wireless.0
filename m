Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38753 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbaGPUYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 16:24:44 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id CCF0621F10
	for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 16:24:42 -0400 (EDT)
Message-ID: <53C6DF7C.8030109@fastmail.fm> (sfid-20140716_222449_125941_82DB7276)
Date: Wed, 16 Jul 2014 21:24:28 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
MIME-Version: 1.0
To: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
CC: inaky@linux.intel.com, Ben Chan <benchan@chromium.org>
Subject: How to replace control code in gdm72xx?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm currently working on bringing the gdm72xx WiMAX driver out of
staging. The driver currently uses two control channels:

1. The SIOCDEVPRIVATE ioctl to send and receive state messages

2. A customly defined netlink protocol for passing messages verbatim to
the device controller

AFAIK both of the above are deprecated, so I considered switching to
the interface defined in wimax.h, which defines a communication protocol
over generic netlink that replaces (2) nicely. However it is not
compatible with (1), as:

* Except from the device status, the gdm72xx driver uses two more types
of messages (connection and OMA status), which is not supported
by wimax.h.

* The gdm driver needs to be able to receive status messages from
userspace, which is not supported by wimax.h either.

I therefore consider using the wimax stack as defined in wimax.h for the
netlink part, but replacing the ioctl with a file under /sys/class/net/wm0/

My questions are whether the above location would be the right place for
that file, and, more importantly, whether this is a generally a valid
approach and not just an ugly workaround.

Thanks,

Michalis
