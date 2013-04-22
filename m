Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3DVOhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 10:37:15 -0400
Message-ID: <1366641428.8637.31.camel@jlt4.sipsolutions.net> (sfid-20130422_163722_462125_19D139F7)
Subject: Re: [PATCH v2 2/2] mac80211: add support for per-chain signal
 strength reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Apr 2013 16:37:08 +0200
In-Reply-To: <1366640971-12872-2-git-send-email-nbd@openwrt.org>
References: <1366640971-12872-1-git-send-email-nbd@openwrt.org>
	 <1366640971-12872-2-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-22 at 16:29 +0200, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  include/net/mac80211.h  |  5 +++++
>  net/mac80211/cfg.c      | 13 ++++++++++++-
>  net/mac80211/rx.c       | 14 ++++++++++++++
>  net/mac80211/sta_info.c |  2 ++
>  net/mac80211/sta_info.h |  5 +++++
>  5 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 4ecff78..aeb4a5c 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -848,6 +848,9 @@ enum mac80211_rx_flags {
>   * @signal: signal strength when receiving this frame, either in dBm, in dB or
>   *	unspecified depending on the hardware capabilities flags
>   *	@IEEE80211_HW_SIGNAL_*
> + * @chains: bitmask of receive chains for which separate signal strength
> + *	values were filled.
> + * @chain_signal: per-chain signal strength, same format as @signal

Oops, sorry, I should've looked at this patch before ... This isn't
right, @signal can be in "dB" or "unspec" units, but @chain_signal is
required to be dBm. If you want, I'll edit the patch to just say that it
must only be provided in dBm?

johannes

