Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:45775 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315AbZLFSfF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 13:35:05 -0500
Message-ID: <4B1BF952.1000909@openwrt.org>
Date: Sun, 06 Dec 2009 19:34:58 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: 8an@praha12.net
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
References: <200912061820.26320.8an@praha12.net> <200912061826.52394.8an@praha12.net>
In-Reply-To: <200912061826.52394.8an@praha12.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lukáš Turek wrote:
> The callback sets slot time as specified in IEEE 802.11-2007 section
> 17.3.8.6 (for 20MHz channels only for now) and ACK and CTS timeouts
> using calculations taken from Madwifi's athctrl. The values are
> persistent, they are restored after device reset.
> 
> Signed-off-by: Lukas Turek <8an@praha12.net>
> ---
> diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
> index 64fc1eb..2383e22 100644
> --- a/drivers/net/wireless/ath/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath/ath5k/pcu.c
> @@ -1050,3 +1050,22 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
>  	return 0;
>  }
>  
> +/**
> + * ath5k_hw_set_coverage - Set coverage class
> + *
> + * @ah: The &struct ath5k_hw
> + * @coverage_class: IEEE 802.11 coverage class
> + *
> + * Sets slot time, ACK timeout and CTS timeout for given coverage class.
> + */
> +void ath5k_hw_set_coverage(struct ath5k_hw *ah, u8 coverage_class)
> +{
> +	/* Calculations taken from Madwifi's athctrl */
> +	int slot_time = 9 + 3 * coverage_class;
> +	int ack_timeout = slot_time * 2 + 3;
> +	int cts_timeout = ack_timeout;
This part is wrong. The slot time can be either short or long, based on
configuration and PHY type.

- Felix
