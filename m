Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43946 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab2CAN6w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 08:58:52 -0500
Message-ID: <4F4F8095.4010706@qca.qualcomm.com> (sfid-20120301_145856_169389_B12914BB)
Date: Thu, 1 Mar 2012 19:28:45 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	<senthilb@qca.qualcomm.com>, <vthiagar@qca.qualcomm.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [RFC 2/2] ath9k_htc: use ieee80211_free_txskb
References: <d053a9a1ec34c2e1b15cf50b272ba7863fb17088.1330360738.git.chunkeey@googlemail.com> <88bea301177cac98e77cd49490ac576d36b10c81.1330360738.git.chunkeey@googlemail.com>
In-Reply-To: <88bea301177cac98e77cd49490ac576d36b10c81.1330360738.git.chunkeey@googlemail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Christian,


On Monday 27 February 2012 10:02 PM, Christian Lamparter wrote:
> With the new tx status API: "mac80211: implement wifi TX status"
> All skb originating from mac80211 needs to be given back to mac80211.
>
> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> ---
> It compiles, but not tested.
> ---
>   drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> index 3e40a64..e958704 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
> @@ -451,7 +451,7 @@ static void ath9k_htc_tx_process(struct ath9k_htc_priv *priv,
>
>   	slot = strip_drv_header(priv, skb);
>   	if (slot<  0) {
> -		dev_kfree_skb_any(skb);
> +		ieee80211_free_txskb(priv->hw, skb);
>   		return;
>   	}
>
> @@ -687,7 +687,7 @@ void ath9k_htc_txep(void *drv_priv, struct sk_buff *skb,
>
>   	epid_queue = get_htc_epid_queue(priv, ep_id);
>   	if (!epid_queue) {
> -		dev_kfree_skb_any(skb);
> +		ieee80211_free_txskb(priv->hw, skb);
>   		return;
>   	}
>

also we should do it ath9k_htc_tx in htc_drv_main.c, i don't know very 
much about ath9k_htc.


-- 
thanks,
shafi
