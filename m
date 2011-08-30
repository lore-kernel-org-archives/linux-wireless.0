Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49194 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab1H3HV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 03:21:28 -0400
Date: Tue, 30 Aug 2011 12:51:57 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH v7 3/4] ath9k: merge reset related functions
Message-ID: <20110830072155.GA2456@vmraj-lnx.users.atheros.com> (sfid-20110830_092132_383261_D260A6FB)
References: <1314643245-59142-1-git-send-email-nbd@openwrt.org>
 <1314643245-59142-2-git-send-email-nbd@openwrt.org>
 <1314643245-59142-3-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1314643245-59142-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 08:40:44PM +0200, Felix Fietkau wrote:
> +
> +	if (!hchan) {
> +		fastcc = false;
> +		flush = true;
> +		hchan = ah->curchan;
> +	}
> +
> +	if (fastcc && !ath9k_hw_check_alive(ah))
> +		fastcc = false;
> +
> +	if (!ath_prepare_reset(sc, retry_tx, flush))
> +		fastcc = false;
> +
> +	ath_dbg(common, ATH_DBG_CONFIG,
> +		"Reset to %u MHz, HT40: %d fastcc: %d\n",
> +		hchan->channel, !!(hchan->channelFlags & (CHANNEL_HT40MINUS |
> +							  CHANNEL_HT40PLUS)),
> +		fastcc);
> +
> +	r = ath9k_hw_reset(ah, hchan, caldata, fastcc);
> +	if (r) {
> +		ath_err(common,
> +			"Unable to reset channel, reset status %d\n", r);
> +		goto out;
> +	}
> +
> +	if (!ath_complete_reset(sc, true))
> +		r = -EIO;
> +
> +out:
>  	spin_unlock_bh(&sc->sc_pcu_lock);
> +	return 0;
> +}
Return proper error code.

--
Rajkumar
