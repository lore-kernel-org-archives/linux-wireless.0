Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47846 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757675AbaKTPRE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 10:17:04 -0500
Message-ID: <1416496620.8557.4.camel@sipsolutions.net> (sfid-20141120_161712_138678_0FB0F963)
Subject: Re: [PATCH v2 1/4] cfg80211: leave invalid channels on regdomain
 change
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 20 Nov 2014 16:17:00 +0100
In-Reply-To: <1415895219-19848-1-git-send-email-arik@wizery.com> (sfid-20141113_171404_076764_CE8901A9)
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
	 (sfid-20141113_171404_076764_CE8901A9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-11-13 at 18:13 +0200, Arik Nemtsov wrote:
> When the regulatory settings change, some channels might become invalid.
> Disconnect interfaces acting on these channels, after giving userspace
> code a grace period to leave them.

So as we discussed, I think you should add a note here that the flag
only works for some interface types, and prohibit setting the flag when
unsupported ones are supported. Then you can also remove the message and
just put in a WARN_ON(1) or something since you can't really get to that
code path.

IMHO that's a reasonable trade-off between generalisation and not doing
all the work now especially since you can't validate it over Intel hw
for other interface types - if anyone else needs/wants the flag then
they can add those interface types and change the conditions.

johannes

