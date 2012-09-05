Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2IENm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 09:42:27 -0400
Message-ID: <1346852578.4364.13.camel@jlt4.sipsolutions.net> (sfid-20120905_154231_147031_DC12DE6D)
Subject: Re: [RFC V2 2/2] cfg80211/nl80211: Enable drivers to implement mac
 address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 05 Sep 2012 15:42:58 +0200
In-Reply-To: <1346824110-26382-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346824110-26382-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1346824110-26382-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-09-05 at 11:18 +0530, Vasanthakumar Thiagarajan wrote:

> + * @NL80211_ATTR_MAC_ACL_MAX: u16 attribute to advertise the maximum
> + *	number of mac addresses that a device can support for MAC
> + *	access control.

Why not use u32? I know we won't use more than u16 most likely, but u32
takes just as much space in netlink messages ...


> Drivers
> + *	which advertise the support for mac address based access control have to
> + *	implement this callback.

You might consider checking this in register_wiphy?


So about the race condition ... shouldn't the initial MAC list be given
in the start_ap() call, so that the AP can start up with a proper ACL
already in place, rather than starting up & then modifying later?

johannes

