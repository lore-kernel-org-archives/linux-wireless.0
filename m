Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50367 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab0LFIRh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 03:17:37 -0500
Subject: Re: [PATCH 2/3] nl80211: Export available antennas
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20101206034535.11462.70791.stgit@localhost6.localdomain6>
References: <20101206034529.11462.48097.stgit@localhost6.localdomain6>
	 <20101206034535.11462.70791.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Dec 2010 09:17:33 +0100
Message-ID: <1291623453.3506.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-12-06 at 12:45 +0900, Bruno Randolf wrote:

> +		NLA_PUT_U32(msg, NL80211_ATTR_WIPHY_ANTENNA_AVAIL,
> +			    dev->wiphy.available_antennas);

I think you should not advertise this unless it's non-zero, and unless
also the set/get callbacks are available.

Similarly, I think you shouldn't advertise the set/get CMDs when the
available antennas aren't set.

Finally, you should check for nl80211 that the given tx/rx masks fall
into the available antennas mask.

johannes

