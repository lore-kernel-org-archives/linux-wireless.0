Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:46326 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758992Ab3EOOMW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:12:22 -0400
Date: Wed, 15 May 2013 15:42:58 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: ath9k_htc: Target is unresponsive
Message-ID: <20130515134258.GA9033@zenon.in.qult.net> (sfid-20130515_161226_309821_857B3691)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

This is an old issue, about which it seems the first posts date back to 2009.
With the latest possible version of the firmware for AR9271 and the latest
possible wireless drivers, the issue is still there.  Whether this is still
the exact same problem every time remains to be checked, but it is annoying
enough to deserve some consideration.

The problem is that the driver can't talk to the device if the following
conditions are met:

 - The system cold boots with the USB dongle inserted or the USB dongle is
   inserted on a running system.

 - The interface is *not* brought up.

 - The system (warm) reboots.

Then the driver complains about the target being unresponsive after uploading
the firmware.  Apparently the only way to make it work again is to unplug and
then plug the USB dongle back, physically.  It seems that if the USB port is
not powered down during reboot (which happens with at least two different
setups that I've tested it with), the device is left in a broken state.

I would gladly help in tracing down this bug if only I knew where to start.

Thanks for any suggestion.

Ignacy

-- 
A person is shit's way of making more shit.
		-- S. Barnett, anthropologist.
