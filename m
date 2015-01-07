Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36214 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752304AbbAGNyD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 08:54:03 -0500
Message-ID: <1420638840.3407.15.camel@sipsolutions.net> (sfid-20150107_145407_476306_9FE1CF74)
Subject: Re: [PATCH] cfg80211: fix deadlock during reg chan check
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 07 Jan 2015 14:54:00 +0100
In-Reply-To: <1419847199-25493-1-git-send-email-arik@wizery.com> (sfid-20141229_110002_459476_3F75B800)
References: <1419847199-25493-1-git-send-email-arik@wizery.com>
	 (sfid-20141229_110002_459476_3F75B800)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-29 at 11:59 +0200, Arik Nemtsov wrote:
> If a P2P GO is active, the cfg80211_reg_can_beacon function will take
> the wdev lock, in its call to cfg80211_go_permissive_chan. But the wdev lock
> is already taken by the parent channel-checking function, causing a
> deadlock.
> Split the checking code into two parts. The first part will check if the
> wdev is active and saves the channel under the wdev lock. The second part
> will check actual channel validity according to type.

Applied to mac80211.git.

johannes

