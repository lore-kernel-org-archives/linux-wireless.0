Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757124Ab0I0Syb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 14:54:31 -0400
Subject: Re: [RFC] mac80211: fix release_reorder_timeout in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: wireless <linux-wireless@vger.kernel.org>, Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
References: <1285266471.3770.384.camel@jlt3.sipsolutions.net>
	 <AANLkTi=3GraBb9hTrieCNvCB0o3PXGORkW1b7F2PceK3@mail.gmail.com>
	 <1285611630.4043.26.camel@jlt3.sipsolutions.net>
	 <AANLkTin+1-_RA8fY8B5-omQi3kMJ3U0iw8Kdg=FC2rnP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Sep 2010 20:54:29 +0200
Message-ID: <1285613669.4043.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-09-27 at 11:49 -0700, Luis R. Rodriguez wrote:

> >> I don't get what we are doing with these frames today, are you saying
> >> we pegged some of these frames into the reorder buffer when starting a
> >> sw scan, or that we were dropping them?

> yeah, I was thinking about the release reorder buffer and its
> respective timeout, I thought that's what the subject of this patch
> was about.

So I got confused by your question ...

We put them into the reorder buffer, but if we get a reorder timeout
while scanning we'll drop the frames which isn't necessary.

johannes

