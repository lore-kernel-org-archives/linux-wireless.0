Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48986 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759153Ab2EQHFg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 03:05:36 -0400
Message-ID: <1337238333.4524.1.camel@jlt3.sipsolutions.net> (sfid-20120517_090548_997634_AEEFC3DA)
Subject: Re: [PATCH 3/3] mwifiex: fix kernel warning in ibss start/join path
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 17 May 2012 09:05:33 +0200
In-Reply-To: <1337228696-22312-3-git-send-email-bzhao@marvell.com> (sfid-20120517_063333_463261_998602DE)
References: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
	 <1337228696-22312-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120517_063333_463261_998602DE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-05-16 at 21:24 -0700, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Since cfg80211_ibss_joined() is called inside ibss join callback
> routine, following kernel warning is hit while starting/joining
> an ibss network.
> 
> "WARNING: at net/wireless/ibss.c:63 cfg80211_ibss_joined+0x35/0xb6
> [cfg80211]()"
> 
> Update "wdev->ssid" and "wdev->ssid_len" in ibss join callback to
> fix this warning.

Guys, no. The documentation for this explicitly says:

 * @ssid: (private) Used by the internal configuration code
 * @ssid_len: (private) Used by the internal configuration code

Don't touch it. I knew I should have hidden these fields from driver
view, but it wasn't easily possible.

If you're using the API wrong then you should fix that instead. In
particular, you should only call cfg80211_ibss_joined() when you
actually know the BSSID of the IBSS you've joined. You can't possibly
know this at this point since you can't even have scanned for peers yet.

johannes

