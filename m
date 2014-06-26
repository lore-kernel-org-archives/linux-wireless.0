Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55734 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbaFZUGh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2014 16:06:37 -0400
Message-ID: <1403813187.4463.1.camel@jlt4.sipsolutions.net> (sfid-20140626_220640_417744_FDD7427B)
Subject: Re: Can we make ieee80211_iface_combination.limits non-const?
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 26 Jun 2014 22:06:27 +0200
In-Reply-To: <53AC6454.5090605@candelatech.com> (sfid-20140626_202012_477893_089B637F)
References: <53AC6454.5090605@candelatech.com>
	 (sfid-20140626_202012_477893_089B637F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-06-26 at 11:20 -0700, Ben Greear wrote:
> Depending on firmware loaded (and/or module options), a different
> number of vdev interfaces may be supported.
> 
> Can we remove the const from the "struct ieee80211_iface_limit *limits"
> member of ieee80211_iface_combination?

No, it would break drivers who actually have a static const for the
pointer target.

You don't have to assign something that's const, but you also can't be
changing it on the fly after wiphy registration anyway.

johannes

