Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238Ab2EQTw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 15:52:56 -0400
Message-ID: <1337284374.4687.6.camel@jlt3.sipsolutions.net> (sfid-20120517_215259_478701_C6518DF3)
Subject: RE: [PATCH 3/3] mwifiex: fix kernel warning in ibss start/join path
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Thu, 17 May 2012 21:52:54 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A64B448@SC-VEXCH1.marvell.com>
References: <1337228696-22312-1-git-send-email-bzhao@marvell.com>
	 <1337228696-22312-3-git-send-email-bzhao@marvell.com>
	 (sfid-20120517_063333_463261_998602DE) <1337238333.4524.1.camel@jlt3.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F7043083A64B448@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-17 at 11:28 -0700, Bing Zhao wrote:

> > Don't touch it. I knew I should have hidden these fields from driver
> > view, but it wasn't easily possible.
> > 
> > If you're using the API wrong then you should fix that instead. In
> > particular, you should only call cfg80211_ibss_joined() when you
> > actually know the BSSID of the IBSS you've joined. You can't possibly
> > know this at this point since you can't even have scanned for peers yet.
> 
> In .join_ibss handler, mwifiex driver sends a command to firmware to start/join an IBSS network.
> This command is a synchronous call. When the command response comes
> back we have started/joined it successfully, otherwise an error code
> will be returned. However, we are still inside .join_ibss handler at
> this moment. Calling cfg80211_ibss_joined() gives us the warning
> because ssid_len hasn't been set by cfg80211 yet.

Hmm. Interesting, because I would think that could potentially take
quite a while?

It's interesting though because it points out that even if you do call
it asynchronously, there's no guarantee that it actually happens before
the function call returns. Maybe we should just move the assignment in
cfg80211 instead?

johannes

