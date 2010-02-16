Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57757 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554Ab0BPTmb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 14:42:31 -0500
Message-ID: <4B7AF51C.8000108@openwrt.org>
Date: Tue, 16 Feb 2010 20:42:20 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith <Sujith.Manoharan@atheros.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] ath9k: fix PAE frame handling
References: <4B65F735.1020509@openwrt.org> <19302.24837.154697.822430@gargle.gargle.HOWL>
In-Reply-To: <19302.24837.154697.822430@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-02-01 6:05 AM, Sujith wrote:
> Felix Fietkau wrote:
>> ath9k's tx handling code contains a special case for PAE frames, which
>> looks like it was intended to be improving reliability by excluding
>> them from aggregates.
>> What it actually did is the opposite: By assigning a faulty sequence
>> number, yet still keeping it as a qos-frame, it caused bogus packet
>> reordering, which broke WPA rekeying.
>> The special case handling is completely unnecessary, so this patch
>> removes it.
> 
> Sending PAE frames as part of an aggregate broke crypto with several APs.
> Assigning the correct seq. number should work, no ?
> 
> Something like the patch below. Can you check if it fixes your issue ?
> Though, removing the seq. number mess in the driver would be great. :D
> 
> 
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index a6893cf..cb6d982 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1610,7 +1610,7 @@ static int ath_tx_setup_buffer(struct ieee80211_hw *hw, struct ath_buf *bf,
>  		bf->bf_frmlen -= padsize;
>  	}
>  
> -	if (conf_is_ht(&hw->conf) && !is_pae(skb))
> +	if (conf_is_ht(&hw->conf))
>  		bf->bf_state.bf_type |= BUF_HT;
>  
>  	bf->bf_flags = setup_tx_flags(sc, skb, txctl->txq);
> @@ -1696,7 +1696,7 @@ static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>  			goto tx_done;
>  		}
>  
> -		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
> +		if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && !is_pae(skb)) {
I just stumbled upon the exact same issue again, though this time with a
Windows based Ralink STA instead of the Mac OS Broadcom STA. Same
symptoms, rekeying frequently leads to timeouts and thus causes
reconnects with long timeouts inbetween.

Turns out that my original patch works better than what was merged -
removing the is_pae() check entirely makes all the STA devices that I
have here work properly.

I'll submit a patch that removes the is_pae() stuff entirely, as I
believe that keeping these special cases there does more harm than good.

- Felix
