Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41602 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaLRN4Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 08:56:24 -0500
Message-ID: <1418910981.6134.9.camel@sipsolutions.net> (sfid-20141218_145628_745961_945194E6)
Subject: Re: [PATCH] nl80211: increase the max number of rules in regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Thu, 18 Dec 2014 14:56:21 +0100
In-Reply-To: <1418832044-25582-1-git-send-email-arik@wizery.com> (sfid-20141217_170045_082207_4F64BED6)
References: <1418832044-25582-1-git-send-email-arik@wizery.com>
	 (sfid-20141217_170045_082207_4F64BED6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 18:00 +0200, Arik Nemtsov wrote:
> Some network cards (Intel) produce per-channel regdomains and rely on
> cfg80211 to merge rules as needed. This hits the max rules limit and
> fails.

Maybe we should consider just getting rid of this or bumping it to
something ridiculously large like 1000? Looking at how this is (not)
used, there's no real sense in limiting it. The only possible problem is
the O(n^2) complexity when doing an intersection, but processing a
million combinations is probably not a big deal? In fact, even if that
becomes a problem, we can easily optimise that complexity away by
sorting the rules or so. Then it becomes O(n log n)...

johannes

