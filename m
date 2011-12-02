Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59214 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab1LBJLn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 04:11:43 -0500
Subject: Re: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com> (sfid-20111202_052910_037002_B91C34E9)
References: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
	 (sfid-20111202_052910_037002_B91C34E9)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 10:11:40 +0100
Message-ID: <1322817100.4162.0.camel@jlt3.sipsolutions.net> (sfid-20111202_101149_648876_D21F6459)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-12-01 at 23:29 -0500, Nikolay Martynov wrote:
> Hi.
> 
>   I have an intel 5300 card running on latest compat-wireless.
>   If I do:
> echo "tx start 8" >
> /sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status

Yikes. I think mac80211 should just reject that since it will never put
traffic into that TID anyway.

johannes

