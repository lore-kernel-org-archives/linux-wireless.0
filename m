Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59674 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab1DTK72 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2011 06:59:28 -0400
Subject: Re: [RFC] mac80211: Assign locally managed MAC address for each vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303296542-18260-1-git-send-email-rmanoharan@atheros.com>
References: <1303296542-18260-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Apr 2011 12:59:27 +0200
Message-ID: <1303297167.3619.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-20 at 16:19 +0530, Rajkumar Manoharan wrote:
> If the chip does not have set of hw mac addresses for each vif,
> let's generate a locally managed mac address for the secondary
> vifs. By doing this, we can avoid setting hw ether address
> before bringing up the interface. The actual hw mac address
> is set to the first vif.

Won't that wreak havoc with udev device naming?

Also, in what cases do you need to assign manually? wpa_s should be able
to assign them now, at least for p2p.

And another point to consider: there are a number of cases where you
need the same address, like VLAN for example.

Not sure, I guess I'm not convinced this is really needed.

johannes

