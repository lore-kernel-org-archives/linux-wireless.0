Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40550 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758311Ab0KSWEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 17:04:53 -0500
Message-ID: <4CE6F478.1030102@candelatech.com>
Date: Fri, 19 Nov 2010 14:04:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Subject: Re: [PATCH 4/4] mac80211: reduce the probe response timeout after
 beacon loss
References: <1290203740-57124-1-git-send-email-nbd@openwrt.org> <1290203740-57124-2-git-send-email-nbd@openwrt.org> <1290203740-57124-3-git-send-email-nbd@openwrt.org> <1290203740-57124-4-git-send-email-nbd@openwrt.org>
In-Reply-To: <1290203740-57124-4-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2010 01:55 PM, Felix Fietkau wrote:
> Waiting for 500 ms after sending a probe request seems a bit excessive,
> especially when doing 5 attempts. If the connection is bad enough to make
> multiple requests time out, then user space should try to quickly find a
> new AP.
>
> Signed-off-by: Paul Stewart<pstew@google.com>
> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> ---
>   net/mac80211/mlme.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index ae99c0b..a64bb92 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -51,7 +51,7 @@
>    * a probe request because of beacon loss or for
>    * checking the connection still works.
>    */
> -#define IEEE80211_PROBE_WAIT		(HZ / 2)
> +#define IEEE80211_PROBE_WAIT		(HZ / 5)

Maybe make this a sysfs (or procfs) tunable?

Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

