Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44655 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899Ab2CAFjW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 00:39:22 -0500
Message-ID: <4F4F0B83.9050203@qca.qualcomm.com> (sfid-20120301_063926_635868_4D662124)
Date: Thu, 1 Mar 2012 11:09:15 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<senthilb@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>,
	Rajkumar_contact <rmanohar@qca.qualcomm.com>,
	"Manoharan, Sujith" <c_manoha@qca.qualcomm.com>
Subject: Re: [RFC 1/2] ath9k: use ieee80211_free_txskb
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com>
In-Reply-To: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,

On Monday 27 February 2012 09:40 PM, Christian Lamparter wrote:
> With the new tx status API: "mac80211: implement wifi TX status"
> All skb originating from mac80211 needs to be given back to mac80211.
>
> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> ---
> It's high time we change all calls in the tx-path from
> dev_kfree_skb into ieee80211_free_txskb.
>
> The call in ath9k_tx is straightforward, but the one in
> ath_tx_setup_buffer gives me headaches. I'm not sure if
> we even need to check bf->bf_state.bfs_paprd at this
> stage since ath_tx_start_dma sets bf->bf_state.bfs_paprd
> "after" calling ath_tx_setup_buffer?!

yes, i think its a problem, we cannot exactly say its the skb from 
mac80211 (or) its our PAPRD skb. though with the current code(as the 
PAPRD) is disabled the skb would be always from mac80211. let us see if 
we have some good solution.

>
> Regards,
> 	Chr
> ---
>   drivers/net/wireless/ath/ath9k/main.c |    2 +-
>   drivers/net/wireless/ath/ath9k/xmit.c |    6 +++++-
>   2 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> index c81304d..4471ed9 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -1162,7 +1162,7 @@ static void ath9k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>
>   	return;
>   exit:
> -	dev_kfree_skb_any(skb);
> +	ieee80211_free_txskb(sc->hw, skb);
>   }
>
>   static void ath9k_stop(struct ieee80211_hw *hw)
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
> index 3182408..0dadbc3 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1858,7 +1858,11 @@ static struct ath_buf *ath_tx_setup_buffer(struct ath_softc *sc,
>   	return bf;
>
>   error:
> -	dev_kfree_skb_any(skb);
> +
> +	if (bf->bf_state.bfs_paprd)
> +		dev_kfree_skb_any(skb);
> +	else
> +		ieee80211_free_txskb(sc->hw, skb);
>   	return NULL;
>   }
>


-- 
thanks,
shafi
