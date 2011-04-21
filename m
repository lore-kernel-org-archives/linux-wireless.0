Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34856 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab1DUM7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 08:59:54 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110421124624.GA29211@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
	 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
	 <20110415105140.GD11576@hertz.marvell.com>
	 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
	 <20110421121513.GC27527@hertz.marvell.com>
	 <1303389236.3597.8.camel@jlt3.sipsolutions.net>
	 <20110421124624.GA29211@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Apr 2011 14:59:48 +0200
Message-ID: <1303390788.3597.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-04-21 at 18:16 +0530, Yogesh Ashok Powar wrote:

> I thought about this initially, but then realized that this will not
> handle the scenario where we disable the key which needs tailroom space
> reservation?  Once the last key, that needs tailroom reservation, is
> disabled, we can skip the tailroom code again?

Well, it kinda goes like this:

key added           -> need tailroom code
key put into HW     -> no longer need tailroom code
key removed from HW -> need tailroom code again
key deleted         -> no longer need tailroom code

johannes

