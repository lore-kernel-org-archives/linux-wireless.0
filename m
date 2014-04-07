Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from the.earth.li ([46.43.34.31]:43238 "EHLO the.earth.li"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbaDGBF0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Apr 2014 21:05:26 -0400
Date: Mon, 7 Apr 2014 01:36:48 +0100
From: Jonathan McDowell <noodles@earth.li>
To: linux-wireless@vger.kernel.org,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: Intel 7260 not working in 802.11n mode
Message-ID: <20140407003648.GA19740@earth.li> (sfid-20140407_030559_667802_2137A372)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I have an Intel 7260 that fails to associate correctly in 802.11n mode.
Unfortunately I don't have any access to the AP in question, but I
believe it is an ASUS based device. This is on the 5GHz band; there is
some odd configuration with the router that results in the driver
refusing to associate on the 2.4GHz setup with the following error:

[  507.495986] iwlwifi 0000:02:00.0: AP 30:00:da:b1:da:d0 beacon interval is 7, refusing due to firmware bug!

On the 5GHz band the driver attempts to associate, but never seems to
actually fully associate to the point of getting an IP. If I pass the
11n_disable=1 parameter to the driver then things work fine.

I've put a debug log of the failure to associate (kernel 3.14 but this
has happened with all the version I've tried) up at:

http://the.earth.li/~noodles/iwlwifi-fail.log

If there is more information I should be providing please let me know.
I'm sure it's related to the AP in question as I've had successful 11n
associations with other setups, but it's annoying to have to explicitly
disable 11n when in this location and then not in others.

J.

-- 
"evilwm - we sold our souls to the window manager" --
http://www.6809.org.uk/evilwm/
