Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45088 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbbKWPPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 10:15:15 -0500
Message-ID: <1448291710.5792.10.camel@sipsolutions.net> (sfid-20151123_161519_552768_7EC89FA8)
Subject: Re: [RFC v5 4/5] mac80211: use Kconfig counters to elide
 unnecessary code
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Marek <mmarek@suse.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Nov 2015 16:15:10 +0100
In-Reply-To: <56532B67.5080508@suse.com>
References: <1447365652-23716-1-git-send-email-johannes@sipsolutions.net>
	 <1447365652-23716-5-git-send-email-johannes@sipsolutions.net>
	 <5653283C.8050207@suse.com> <1448290682.5792.6.camel@sipsolutions.net>
	 <56532B67.5080508@suse.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 16:06 +0100, Michal Marek wrote:
> 
> > Indeed, the runtime check will catch both of these.
> 
> Will it catch the former case? The driver built out of has not way to
> select or increment any of the CONFIG_MAC80211_* options.

Correct, but ieee80211_hwflags_check() will verify that the flags are
compatible with the compilation settings, regardless of the respective
source. Note that our preferred way of working out-of-tree is backports
anyway and that ships with mac80211 and cfg80211 due to the relatively
tight coupling between all the pieces.

In any case - consider first compiling mac80211 with a driver that does
"count CONFIG_HWFLAG_XYZ", and no other drivers. This means
that hwflags_state[XYZ] will end up as 1. So once the other (out-of-
tree) driver is registered, it'll pass hw->flags with the bit of XYZ
not set. This would cause a warning and refusal to register
in ieee80211_hwflags_check().

johannes
