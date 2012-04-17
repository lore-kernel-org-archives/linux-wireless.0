Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53173 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2DQECY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 00:02:24 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20364.60189.208919.748818@gargle.gargle.HOWL> (sfid-20120417_060232_843599_661C1347)
Date: Tue, 17 Apr 2012 09:31:33 +0530
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: [PATCH v2 7/8] ath9k_hw: disable fast channel change when changing from/to half/quarter mode
In-Reply-To: <1334610565-37399-7-git-send-email-nbd@openwrt.org>
References: <1334610565-37399-1-git-send-email-nbd@openwrt.org>
	<1334610565-37399-2-git-send-email-nbd@openwrt.org>
	<1334610565-37399-3-git-send-email-nbd@openwrt.org>
	<1334610565-37399-4-git-send-email-nbd@openwrt.org>
	<1334610565-37399-5-git-send-email-nbd@openwrt.org>
	<1334610565-37399-6-git-send-email-nbd@openwrt.org>
	<1334610565-37399-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index ff8d58d..26e6083 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -1440,6 +1440,10 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
>  						    CHANNEL_5GHZ));
>  	mode_diff = (chan->chanmode != ah->curchan->chanmode);
>  
> +	if ((ah->curchan->channelFlags | chan->channelFlags) &
> +	    (CHANNEL_HALF | CHANNEL_QUARTER))
> +		return false;
> +

ath9k_hw_do_fastcc() is a better place where this check can be done.

Sujith
