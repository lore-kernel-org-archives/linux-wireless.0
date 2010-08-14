Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:45982 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab0HNGbV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Aug 2010 02:31:21 -0400
Subject: Re: [PATCH v2] cfg80211: fix race between sysfs and cfg80211
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1281638550.3803.4.camel@jlt3.sipsolutions.net>
References: <1279336415.1941.6.camel@kero>
	 <1279394982.3931.0.camel@jlt3.sipsolutions.net>
	 <1279852170.14136.0.camel@sakura.staff.proxad.net>
	 <1281638499.12446.498.camel@sakura.staff.proxad.net>
	 <1281638550.3803.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sat, 14 Aug 2010 08:31:12 +0200
Message-ID: <1281767472.12446.551.camel@sakura.staff.proxad.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2010-08-12 at 20:42 +0200, Johannes Berg wrote:

> Err, it was merged a long time ago

I'm hitting another race now, it appeared after I disabled
CONFIG_CRYPTO_MANAGER_TESTS (new option in 2.6.35.2).

I have a userspace daemon that listen for new phy event, and create and
configure an AP interface just after it gets the event.


The driver is still inside ieee80211_register_hw(), but the userspace is
able to create the AP interface before the call is over. Once
wiphy_register() is done, no lock seems to prevent this from happening.

ieee80211_init_rate_ctrl_alg() then fails with EBUSY, and
ieee80211_register_hw() starts unregistering the phy.

Is that expected ?

I was able to get past it by taking rtnl lock before wiphy_register()

-- 
Maxime


