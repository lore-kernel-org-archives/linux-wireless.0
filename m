Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250Ab0HPJG4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 05:06:56 -0400
Subject: Re: [PATCH v2] cfg80211: fix race between sysfs and cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: mbizon@freebox.fr
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1281767472.12446.551.camel@sakura.staff.proxad.net>
References: <1279336415.1941.6.camel@kero>
	 <1279394982.3931.0.camel@jlt3.sipsolutions.net>
	 <1279852170.14136.0.camel@sakura.staff.proxad.net>
	 <1281638499.12446.498.camel@sakura.staff.proxad.net>
	 <1281638550.3803.4.camel@jlt3.sipsolutions.net>
	 <1281767472.12446.551.camel@sakura.staff.proxad.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 11:06:54 +0200
Message-ID: <1281949614.3683.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-08-14 at 08:31 +0200, Maxime Bizon wrote:

> The driver is still inside ieee80211_register_hw(), but the userspace is
> able to create the AP interface before the call is over. Once
> wiphy_register() is done, no lock seems to prevent this from happening.
> 
> ieee80211_init_rate_ctrl_alg() then fails with EBUSY, and
> ieee80211_register_hw() starts unregistering the phy.
> 
> Is that expected ?

Oops. No, not really, but I think the problem is that we do
wiphy_register far too early. I think we should see if we can reorder
the code in register_hw(). It won't be perfect wrt. debugfs, but I don't
think that is a problem.

johannes

