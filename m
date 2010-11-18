Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:46136 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab0KRJ3p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 04:29:45 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 01:29:32 -0800
Date: Thu, 18 Nov 2010 15:07:26 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: module unloading busted ?
Message-ID: <20101118093725.GA3388@vmraj-lnx.users.atheros.com>
References: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTim775JXAkrvVjn-TmwD5B6-MYCRw6ah=rVF8Opk@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 18, 2010 at 12:56:00PM +0530, Luis R. Rodriguez wrote:
> 05:33 < mcgrof> so module unload on ath9k no longer works
> 06:11 < vmraj> mcgrof: module unload is not working for intel cards too
> 06:15 < vmraj> it can be reproduced by rmmod on active connection
> 
> I haven't yet figured out why. Anyone else with other modules experiencing this?
> 
cfg80211_netdev_notifier_call invokes dev_hold on NETDEV_DOWN which increments
Usage count. hence unregister_netdevice fails.

--
Rajkumar
