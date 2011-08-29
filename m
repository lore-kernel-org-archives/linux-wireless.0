Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39000 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab1H2FZy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 01:25:54 -0400
Date: Mon, 29 Aug 2011 10:56:21 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH] ath9k_hw: do not apply the 2.4 ghz ack timeout
 workaround to cts
Message-ID: <20110829052621.GB27901@vmraj-lnx.users.atheros.com> (sfid-20110829_072556_959538_489C70B3)
References: <1314489130-18003-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314489130-18003-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 28, 2011 at 01:52:10AM +0200, Felix Fietkau wrote:
> It is only used to workaround interoperability issues related to longer
> delays in receiving the block ack, so it is not necessary to apply it
> to the CTS exchange.
> Should improve throughput slightly, especially when there are lots
> of retransmissions.
> 
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> ---
>  drivers/net/wireless/ath/ath9k/hw.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
> index a0d1147..3ccadeb 100644
> --- a/drivers/net/wireless/ath/ath9k/hw.c
> +++ b/drivers/net/wireless/ath/ath9k/hw.c
> @@ -960,7 +960,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>  	struct ath_common *common = ath9k_hw_common(ah);
>  	struct ieee80211_conf *conf = &common->hw->conf;
>  	const struct ath9k_channel *chan = ah->curchan;
> -	int acktimeout;
> +	int acktimeout, ctstimeout;
>  	int slottime;
>  	int sifstime;
>  	int rx_lat = 0, tx_lat = 0, eifs = 0;
> @@ -1011,6 +1011,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>  
>  	/* As defined by IEEE 802.11-2007 17.3.8.6 */
>  	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
> +	ctstimeout = acktimeout;
>  
>  	/*
>  	 * Workaround for early ACK timeouts, add an offset to match the
> @@ -1025,7 +1026,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>  	ath9k_hw_set_sifs_time(ah, sifstime);
>  	ath9k_hw_setslottime(ah, slottime);
>  	ath9k_hw_set_ack_timeout(ah, acktimeout);
> -	ath9k_hw_set_cts_timeout(ah, acktimeout);
> +	ath9k_hw_set_cts_timeout(ah, ctstimeout);
>  	if (ah->globaltxtimeout != (u32) -1)
>  		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
>  
the cts timeout calculation does not include start delay factor.
And also it is always lesser than the INI values. Decreasing CTS timeout could
affect performance in congested network.

--
Rajkumar
