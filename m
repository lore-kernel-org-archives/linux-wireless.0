Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757096Ab3BMO5Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:57:16 -0500
Message-ID: <1360767428.8868.18.camel@jlt4.sipsolutions.net> (sfid-20130213_155719_952378_9527D82B)
Subject: Re: [PATCH] nl80211: Don't add empty bands or disabled channels in
 NL80211_CMD_GET_WIPHY
From: Johannes Berg <johannes@sipsolutions.net>
To: Dennis H Jensen <dennis.h.jensen@siemens.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Wed, 13 Feb 2013 15:57:08 +0100
In-Reply-To: <1360688424-11514-1-git-send-email-dennis.h.jensen@siemens.com>
References: <1360688424-11514-1-git-send-email-dennis.h.jensen@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-12 at 18:00 +0100, Dennis H Jensen wrote:
> This patch resolves issues where the driver reports too many channels
> for them all to fit in one netlink message, as long as some are
> disabled, and makes it possible to use non-standard channels and
> customized regulatory databases.

I don't think this is a good idea -- the state of a channel being
"disabled" can change due to regulatory database, so it's useful to know
which channels are actually registered and disabled via regulatory and
which aren't even present at all.

Since you must be hacking the drivers anyway, you could just not
register those channels you're not using, right?

Maybe there'd be a way to allocate larger messages, but I suppose the
right fix would be to split up the dump in a way that it can support
arbitrarily many channels, which will also require userspace changes
though (and has to be done in a backward compatible way.)

johannes

