Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab1D0L2C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 07:28:02 -0400
Subject: Re: [PATCH 1/2] mac80211: Adding HW flag
 IEEE80211_HW_CRYPTO_ENABLED
From: Johannes Berg <johannes@sipsolutions.net>
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>
In-Reply-To: <20110427110303.GA18370@hertz.marvell.com>
References: <20110415045321.GA11504@hertz.marvell.com>
	 <1302850527.3572.2.camel@jlt3.sipsolutions.net>
	 <20110415084005.GC11576@hertz.marvell.com>
	 <1302857554.3572.14.camel@jlt3.sipsolutions.net>
	 <20110415105140.GD11576@hertz.marvell.com>
	 <1302865304.3572.15.camel@jlt3.sipsolutions.net>
	 <20110421121513.GC27527@hertz.marvell.com>
	 <1303389236.3597.8.camel@jlt3.sipsolutions.net>
	 <20110421124624.GA29211@hertz.marvell.com>
	 <1303390788.3597.10.camel@jlt3.sipsolutions.net>
	 <20110427110303.GA18370@hertz.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 13:27:56 +0200
Message-ID: <1303903676.3542.2.camel@jlt3.sipsolutions.net> (sfid-20110427_132807_124359_F3C8890A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-27 at 16:33 +0530, Yogesh Ashok Powar wrote:
> On Thu, Apr 21, 2011 at 05:59:48AM -0700, Johannes Berg wrote:
> > Well, it kinda goes like this:
> > 
> > key added           -> need tailroom code
> > key put into HW     -> no longer need tailroom code
> > key removed from HW -> need tailroom code again
> > key deleted         -> no longer need tailroom code
> > 
> Following patch takes care of these four states. Kindly review.

Looks fine, but still I think it might get out of sync when HW restart
happens?

johannes


