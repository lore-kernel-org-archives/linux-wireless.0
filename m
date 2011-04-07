Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:64278 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756685Ab1DGTP5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2011 15:15:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 07 Apr 2011 12:15:32 -0700
Date: Fri, 8 Apr 2011 00:46:03 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 2.6.39] ath9k: fix missing
 ath9k_ps_wakeup/ath9k_ps_restore calls
Message-ID: <20110407191603.GA6387@vmraj-lnx.users.atheros.com>
References: <1302196037-27378-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1302196037-27378-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 07, 2011 at 10:37:17PM +0530, Felix Fietkau wrote:
> These missing chip wakeups mainly cause crashes on AR5416 cards in MIPS
> boards, but have also been reported to cause radio stability issues on
> AR9285.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Cc: stable@kernel.org
> ---
>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index 6a41302..802a910 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1376,7 +1376,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
>  
>  	ath9k_calculate_iter_data(hw, vif, &iter_data);
>  
> -	ath9k_ps_wakeup(sc);
>  	/* Set BSSID mask. */
>  	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
>  	ath_hw_setbssidmask(common);
> @@ -1411,7 +1410,6 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
>  	}
>  
>  	ath9k_hw_set_interrupts(ah, ah->imask);
> -	ath9k_ps_restore(sc);
>
It seems to be the existing ps calls in ath9k_calculate_summary_state() are enough
to awake chip before doing hw access. Why the ps calls are unneccesarilly moved
to mac callbacks? If chip is not waken up, it should be noticed in x86 too.
isn't it?

--
Rajkumar
