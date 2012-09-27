Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2I0JNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 05:13:07 -0400
Message-ID: <1348737219.10353.6.camel@jlt4.sipsolutions.net> (sfid-20120927_111311_807200_8F5233B3)
Subject: Re: [PATCH 0/3] add scan flags support
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@chromium.org>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, eliad <eliad@wizery.com>,
	coelho <coelho@ti.com>
Date: Thu, 27 Sep 2012 11:13:39 +0200
In-Reply-To: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com> (sfid-20120926_185956_215056_52A41944)
References: <20120926165952.766801E10D3@sleffler.sfo.corp.google.com>
	 (sfid-20120926_185956_215056_52A41944)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-25 at 15:49 -0700, Sam Leffler wrote:
> These add per-scan request controls for optional behaviours we've found
> useful (they've been in Chrome OS for a long time).  A patch for iw will
> follow separately and the mods for wpa_supplicant are in our repo and
> I'll push them to Jouni if these are accepted.
> 
> Sam Leffler (3):
>   {nl,cfg}80211: add a flags word to scan requests
>   mac80211: add support for tx to abort scan requests
>   cfg80211: add support for flushing old scan results

I like the flushing one, but I'm not so sure about the TX abort thing.
How do you suggest to handle that when scanning is offloaded to the
driver and/or firmware? Especially given that multi-channel is going to
require a firmware implementation, I'm not sure how to achieve good
behaviour across the different implementations.

Maybe it'd be worthwhile to go for a more generic approach, marking
scans as "low priority" or "high priority" or similar, and then
implementing such behaviour based on such settings? Our device for
example has a notion of "background scan" vs. "forced scan", which
behave differently in the firmware, and it would be useful to be able to
use these different behaviours. However, I can't say that "TX abort"
would be a guaranteed scan behaviour for a "background scan".

johannes

