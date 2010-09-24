Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35336 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab0IXWZs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 18:25:48 -0400
Subject: Re: [wireless] wireless:  Keep phy name consistent across module
 reloads.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <4C9D2487.5040202@candelatech.com>
References: <1285113431-25526-1-git-send-email-greearb@candelatech.com>
	 <1285362170.11036.1.camel@jlt3.sipsolutions.net>
	 <4C9D13AC.4080308@candelatech.com>
	 <1285363135.11036.7.camel@jlt3.sipsolutions.net>
	 <4C9D1760.3040103@candelatech.com>
	 <1285363861.11036.8.camel@jlt3.sipsolutions.net>
	 <4C9D2487.5040202@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 00:25:44 +0200
Message-ID: <1285367144.11036.11.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-09-24 at 15:21 -0700, Ben Greear wrote:

> Here's a patch for consideration.  It's on top of my other patch,
> but I can re-do it against a tree with that reverted if you prefer.

You also want to remove the restriction on renaming to phy%d now.

> +	if (unlikely(!wiphy_idx_valid(rdev->wiphy_idx)))
> +		goto too_many_devs;
> +
>   	/* 64k wiphy devices is enough for anyone! */
>   	for (i = 0; i < 0xFFFF; i++) {

why limit yourself to this? You're guaranteed to find a free index if
you don't, so error handling could be easier?

johannes

