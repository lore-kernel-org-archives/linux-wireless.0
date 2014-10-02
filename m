Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54287 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJBROb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2014 13:14:31 -0400
Message-ID: <542D87F6.8090306@candelatech.com> (sfid-20141002_191434_817557_589FB847)
Date: Thu, 02 Oct 2014 10:14:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Support for bitrate-mask in wpa_supplicant?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

>From what I can tell, wpa_supplicant does not have a way to set
the tx-bitrate-mask, except for some code
to disable 802.11b rates (which I think will in turn (re)enable all
of the other rates that may have previously been disabled.

So, would it be worthwhile to add support to supplicant to at
least configure the legacy rates using the NL80211_CMD_SET_TX_BITRATE_MASK
netlink message?

I am also interested in adding a set of masks to that command that would
specify to the kernel exactly which rate(s) to configure.  That way, it
would be a lot easier to just configure the legacy rates without messing up any
of the other configuration, for instance.

Any opinions on this?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

