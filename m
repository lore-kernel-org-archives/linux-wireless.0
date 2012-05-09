Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab2EIL7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 07:59:42 -0400
Message-ID: <1336564773.4323.19.camel@jlt3.sipsolutions.net> (sfid-20120509_135945_511489_2776DA96)
Subject: Re: rt28xx AP-mode problem with commit
 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63 "mac80211: manage AP netdev
 carrier state"
From: Johannes Berg <johannes@sipsolutions.net>
To: Tobias Diedrich <ranma+openwrt@tdiedrich.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	linux-wireless@vger.kernel.org
Date: Wed, 09 May 2012 13:59:33 +0200
In-Reply-To: <20120509105719.GA24457@yumi.tdiedrich.de> (sfid-20120509_125732_300096_BB4CA746)
References: <20120509105719.GA24457@yumi.tdiedrich.de>
	 (sfid-20120509_125732_300096_BB4CA746)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-09 at 12:57 +0200, Tobias Diedrich wrote:

> I've bisected a problem with running rt3052-based APs on recent
> OpenWRT down to this commit: 3edaf3e61fda3aa9ff8d38445bf92f2bec23bf63
> "mac80211: manage AP netdev carrier state"
> 
> If I revert this commit (and also fix the max_power issue), AP-mode
> works fine, but if I leave it in, association to the AP times out.
> 
> (The AP-side hostapd claims WPA authentication was successful, but
> the client never connects)
> 
> (Note: I haven't gotten around to testing a non-rt28xx based AP yet,
> so I'm only assuming this affects only rt28xx, maybe it does affect
> other chipsets as well)

Works fine here, but I don't see how that patch could affect rt2x00
only.

You're going to have to give us more details about the failure, like the
version of hostapd at least. The output of "ip monitor" would also be
helpful.

johannes

