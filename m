Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0KRSx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 13:53:56 -0500
Subject: Re: module unloading busted ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20101118093725.GA3388@vmraj-lnx.users.atheros.com>
References: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
	 <20101118093725.GA3388@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Nov 2010 10:55:15 -0800
Message-ID: <1290106515.3801.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-11-18 at 15:07 +0530, Rajkumar Manoharan wrote:
> On Thu, Nov 18, 2010 at 12:56:00PM +0530, Luis R. Rodriguez wrote:
> > 05:33 < mcgrof> so module unload on ath9k no longer works
> > 06:11 < vmraj> mcgrof: module unload is not working for intel cards too
> > 06:15 < vmraj> it can be reproduced by rmmod on active connection
> > 
> > I haven't yet figured out why. Anyone else with other modules experiencing this?
> > 
> cfg80211_netdev_notifier_call invokes dev_hold on NETDEV_DOWN which increments
> Usage count. hence unregister_netdevice fails.

The cleanup_work should fix that up -- but I can see this being a corner
case that the network stack no longer likes us for ...

johannes

