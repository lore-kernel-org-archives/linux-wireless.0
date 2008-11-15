Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4062 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbYKOAeu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 19:34:50 -0500
Date: Fri, 14 Nov 2008 19:31:31 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: don't assume driver has been attached on registration
Message-ID: <20081115003131.GA10702@hash.localnet> (sfid-20081115_013455_476080_829574A8)
References: <1226702662-29694-1-git-send-email-lrodriguez@atheros.com> <b6c5339f0811141505u1f8c7c3hd6858ebe21cc10bb@mail.gmail.com> <1226704464.4120.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1226704464.4120.32.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 15, 2008 at 12:14:24AM +0100, Johannes Berg wrote:
> > In the reported case, wiphy_name will be empty string which isn't too
> > helpful for the workqueue name either, though it probably won't crash.
> 
> That can't be right! wiphy_name is assigned right in wiphy_new()!

I know, it doesn't make any sense.  But the posted dmesg clearly shows 
ath5k printing the wiphy_name (after ieee80211_alloc_hw returned not
null): "ath5k_pci xxxx registered as ''".  So, something really odd is
going on.

-- 
Bob Copeland %% www.bobcopeland.com

