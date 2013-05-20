Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51168 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3ETBDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 May 2013 21:03:25 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20889.30147.707771.32138@gargle.gargle.HOWL> (sfid-20130520_030328_912185_3357D7C2)
Date: Mon, 20 May 2013 06:30:51 +0530
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.10] ath9k: prevent aggregation session deadlocks
In-Reply-To: <1368905295-51440-1-git-send-email-nbd@openwrt.org>
References: <1368905295-51440-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Waiting for all subframes of an existing aggregation session to drain
> before allowing mac80211 to start a new one is fragile and deadlocks
> caused by this behavior have been observed.
> 
> Since mac80211 has proper synchronization for aggregation session
> start/stop handling, a better approach to session handling is to simply
> allow mac80211 to start a new session at any time. This requires
> changing the code to discard any packets outside of the BlockAck window
> in the A-MPDU software retry code.
> 
> This patch implements the above and also simplifies the code.

John,

Can you please drop my patch, "ath9k: Fix TID locking" since it is not necessary
after this one ?

The rest of the pending patches have been rebased and are here:
http://msujith.org/patches/wl/May-20-2013/

Yell at me if you want them to be resent.

Sujith
