Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52268
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757603AbZJKKjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Oct 2009 06:39:11 -0400
Date: Sun, 11 Oct 2009 03:39:07 -0700 (PDT)
Message-Id: <20091011.033907.35699436.davem@davemloft.net>
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, kalle.valo@iki.fi,
	hidave.darkstar@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: fix ieee80211_rx() context
From: David Miller <davem@davemloft.net>
In-Reply-To: <1255256361.4095.56.camel@johannes.local>
References: <1255256361.4095.56.camel@johannes.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 11 Oct 2009 12:19:21 +0200

> Due to the way it interacts with the networking
> stack and other parts of mac80211, ieee80211_rx()
> must be called with disabled softirqs.
> 
> Michael, the former maintainer of this driver,
> has refused to fix the problem this way instead
> proposing a much more invasive patch that could
> not even be proved correct wrt. locking inside
> mac80211. Regardless of that, he believes this
> to be a bug in mac80211, and has also publicly
> stated [1] that he does not care about this even
> though it is a regression introduced by his own
> patches.
> 
> Since nobody else seems to be wanting to fix the
> problem, I'll just fix it for the benefit of the
> many users of this driver.
> 
> [1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/39440/focus=40266
> 
> Reported-by: Dave Young <hidave.darkstar@gmail.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: David S. Miller <davem@davemloft.net>
