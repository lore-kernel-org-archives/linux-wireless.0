Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:55540 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbcAOL2Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2016 06:28:25 -0500
Subject: Re: [PATCH 1/5] ath9k: avoid ANI restart if no trigger
To: miaoqing@codeaurora.org, linville@tuxdriver.com
References: <1452821009-1156-1-git-send-email-miaoqing@codeaurora.org>
 <1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	kvalo@qca.qualcomm.com
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <5698D7D0.5080204@openwrt.org> (sfid-20160115_122829_138687_5E0C042D)
Date: Fri, 15 Jan 2016 12:28:16 +0100
MIME-Version: 1.0
In-Reply-To: <1452821009-1156-2-git-send-email-miaoqing@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-15 02:23, miaoqing@codeaurora.org wrote:
> From: Miaoqing Pan <miaoqing@codeaurora.org>
> 
> ath9k_ani_restart() is always be invoked even if the trigger
> condition is false.
> 
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath9k/ani.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/ath/ath9k/ani.c
> index 25e45e4..0f74d59 100644
> --- a/drivers/net/wireless/ath/ath9k/ani.c
> +++ b/drivers/net/wireless/ath/ath9k/ani.c
> @@ -444,14 +444,16 @@ void ath9k_hw_ani_monitor(struct ath_hw *ah, struct ath9k_channel *chan)
>  		    ofdmPhyErrRate < ah->config.ofdm_trig_low) {
>  			ath9k_hw_ani_lower_immunity(ah);
>  			aniState->ofdmsTurn = !aniState->ofdmsTurn;
> +			ath9k_ani_restart(ah);
>  		} else if (ofdmPhyErrRate > ah->config.ofdm_trig_high) {
>  			ath9k_hw_ani_ofdm_err_trigger(ah);
>  			aniState->ofdmsTurn = false;
> +			ath9k_ani_restart(ah);
>  		} else if (cckPhyErrRate > ah->config.cck_trig_high) {
>  			ath9k_hw_ani_cck_err_trigger(ah);
>  			aniState->ofdmsTurn = true;
> +			ath9k_ani_restart(ah);
>  		}
How about adding an 'else return' here instead of duplicating the
ath9k_ani_restart lines?

- Felix
