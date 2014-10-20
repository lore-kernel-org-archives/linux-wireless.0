Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36727 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbaJTKw2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 06:52:28 -0400
Message-ID: <1413802344.10246.20.camel@jlt4.sipsolutions.net> (sfid-20141020_125239_773362_610B7B5C)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: vadim4j@gmail.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Date: Mon, 20 Oct 2014 12:52:24 +0200
In-Reply-To: <128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	 <1411075535.2034.5.camel@jlt4.sipsolutions.net>
	 <20141014121627.GA5115@angus-think.lan>
	 <1413798437.10246.12.camel@jlt4.sipsolutions.net>
	 <128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-20 at 12:46 +0200, Marcel Holtmann wrote:

> Maybe relaxing the check and allow ip link to move a wireless netdev
> into a namespace (and having the wiphy follow) could be allowed if it
> is the only netdev or the original wlan0 that each wiphy creates. I
> really do not know if this is worth it, but for some simpler container
> cases it could be beneficial if RTNL can be used instead of having to
> go through nl80211.

The thought crossed my mind, but

1) it's relatively complex, though by no means impossible
2) it still moves more than you bargained for, since in theory the wiphy
could be
   used to create new interfaces etc.

That said, I'm much more inclined to believe such a patch would be
worthwhile than the original.

johannes

