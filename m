Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37193
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752742AbYEEA7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 20:59:43 -0400
Date: Sun, 04 May 2008 17:59:43 -0700 (PDT)
Message-Id: <20080504.175943.181438923.davem@davemloft.net> (sfid-20080505_025909_325302_D11A7D12)
To: xemul@openvz.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH][MAC80211]: Do not free net device after it is
 unregistered.
From: David Miller <davem@davemloft.net>
In-Reply-To: <481D5D79.5080702@openvz.org>
References: <481D5D79.5080702@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Pavel Emelyanov <xemul@openvz.org>
Date: Sun, 04 May 2008 10:53:45 +0400

> The error path in ieee80211_register_hw() may call the unregister_netdev()
> and right after it - the free_netdev(), which is wrong, since the
> unregister releases the device itself.
> 
> So the proposed fix is to NULL the local->mdev after unregister is done
> and check this before calling free_netdev().
> 
> I checked - no code uses the local->mdev after unregister in this error
> path (but even if some did this would be a BUG).
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

I'll take this.

Applied, thanks Pavel.
