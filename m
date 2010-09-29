Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:36839 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab0I2I5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 04:57:13 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Sep 2010 01:57:05 -0700
Date: Wed, 29 Sep 2010 14:26:57 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@Atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
Message-ID: <20100929085657.GD18450@vasanth-laptop>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu> <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com> <20100929052006.GC18450@vasanth-laptop> <AANLkTinKkTgUUGPxY82G1B6taToKeAMOmrJ+tYvzLY52@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <AANLkTinKkTgUUGPxY82G1B6taToKeAMOmrJ+tYvzLY52@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 29, 2010 at 12:54:27PM +0530, Luis R. Rodriguez wrote:
> > (where we just authenticated with another AP)
> 
> Not sure I get this part.

I mean we are trying to tx frames on the channel where we got
newly authenticated to another AP.
> 
> > just before starting association with the new AP.
> 
> Right, but when we are already switched to the new channel, and the
> reason is that when we try to send a frame we never kept track of the
> peer's original channel. Now, I also see the teardown happen right
> before mac80211 tells us its associated to the new AP as well but it
> not sure what cfg80211 thinks at that point. At least the cfg80211
> patch's intention seemed to be to allow association to both, and
> tearing down the association to the other once you completed
> association to the other. I do see, what you describe though too --
> only authentication to the new AP, and right before association, we
> send the teardown. The problem is though that when we send the
> teardown we are already set on the new channel.

Ok. From my understanding, the sequence of operations during roaming
are

1. NL80211_CMD_AUTHENTICATE to an (better) AP from user space
 	- Change to New Ap's channel and send auth req (done by
   	  ieee80211_work_work()).
 	- Notify auth resp to userspace (ieee80211_probe_auth_done())
2. NL80211_CMD_ASSOCIATE to newly authenticated AP from user space
	- Clean up any existing BA session with an AP, if any.
	Here the assumption is, ieee80211_work_work() has already
	configured the device back to it's operating channel (the
	old one) after the authentication is complete with the new
	AP. This should have happened part of 1.
	- Start the association process with the new AP.


Vasanth
