Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53564 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab2JLI71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 04:59:27 -0400
Message-ID: <1350032395.10420.1.camel@jlt4.sipsolutions.net> (sfid-20121012_105931_035414_E8B7BEF7)
Subject: Re: [PATCH v4 0/5] add scan flags support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>
Date: Fri, 12 Oct 2012 10:59:55 +0200
In-Reply-To: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
References: <1350014615-14762-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-11 at 21:03 -0700, Bing Zhao wrote:
> This is the v4 series prepared by Amitkumar Karwar.
> 
> 1) "wiphy->features" is used instead of "wiphy->flags" to advertise
>    scan features. (Johannes Berg)
> 2) Added support to disable scan flush if driver requests for it
>    explicitly. (Johannes Berg)
> 3) Used msecs_to_jiffies() to convert time interval into jiffies
>    for comparison (Johannes Berg)

Ok, applied.

I made two small changes (and inserted a patch in the middle to allow
for those changes).

One change is that I inverted the polarity of the "flush" feature flag
so that userspace can check if it's supported without having to worry
about the kernel version.

The other change is a fix in mac80211 to only set the "low prio" support
flag if *software* scan is used, not unconditionally.

Please make sure those still work for you, I haven't tested it.

It might be nice to also have a low-prio/flush flags patch for iw as
well if you find the time.

johannes

