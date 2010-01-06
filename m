Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:59465 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0AFOcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 09:32:08 -0500
Date: Wed, 6 Jan 2010 15:32:02 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix a few work bugs
Message-ID: <20100106143159.GC1735@mail.wantstofly.org>
References: <1262788258.9268.113.camel@johannes.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262788258.9268.113.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 06, 2010 at 03:30:58PM +0100, Johannes Berg wrote:

> Kalle and Lennert reported problems with the new work
> code, and at least Kalle's problem I was able to trace
> to a missing jiffies initialisation.
> 
> I also ran into a problem where occasionally I couldn't
> connect, which seems fixed with kicking the work items
> after scanning.
> 
> Finally, also add some sanity checking code to verify
> that we're not adding work items while an interface is
> down -- that case could lead to something similar to
> what Lennert was seeing.
> 
> There still seems to be a race condition that we're
> trying to figure out separately.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Lennert Buytenhek <buytenh@marvell.com>
