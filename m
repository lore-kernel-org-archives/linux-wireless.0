Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36206 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab0JURre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 13:47:34 -0400
Message-ID: <4CC07CA9.4040808@candelatech.com>
Date: Thu, 21 Oct 2010 10:47:21 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/6] ath9k: fix RX poison issue
References: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287616028-12547-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/20/2010 04:07 PM, Luis R. Rodriguez wrote:
> This series addresses the RX poison issue reported by Ben.
> I've split the patches up into as many atomic pieces to make
> it easier for review and understanding. Some are stable, the
> last few patches are for debugging.
>
> Luis R. Rodriguez (6):
>    ath9k: add locking for stopping RX
>    ath9k: add locking for starting the PCU on RX
>    ath9k: rename rxflushlock to pcu_lock
>    ath9k: lock reset and PCU start/stopping
>    ath: add a ATH_DBG_WARN()
>    ath9k: add a debug warning when we cannot stop RX
>
>   drivers/net/wireless/ath/ath9k/ath9k.h |    2 +-
>   drivers/net/wireless/ath/ath9k/main.c  |   31 +++++++++++++++++++++++++++++--
>   drivers/net/wireless/ath/ath9k/recv.c  |   17 +++++++++--------
>   drivers/net/wireless/ath/debug.h       |    2 ++
>   4 files changed, 41 insertions(+), 11 deletions(-)

I tested this code when it was combined into a single patch.
There were still some issues, but I have no reason to believe
this patch set caused them.  This patch set significantly
improved stability in my testing with 130+ STA interfaces.

So:

Tested-by: Ben Greear <greearb@candelatech.com>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

