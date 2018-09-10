Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35450 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbeIJOiO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 10:38:14 -0400
Subject: Re: [PATCH 06/42] mt76: move mt76x2u_set_txinfo in mt76x02-lib module
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-mediatek@lists.infradead.org
References: <1536225538-16454-1-git-send-email-sgruszka@redhat.com>
 <1536225538-16454-7-git-send-email-sgruszka@redhat.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <9d5b51ce-12c8-1195-1447-5d1beaf4d967@nbd.name> (sfid-20180910_114506_119666_CC585C64)
Date: Mon, 10 Sep 2018 11:45:02 +0200
MIME-Version: 1.0
In-Reply-To: <1536225538-16454-7-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-06 11:18, Stanislaw Gruszka wrote:
> From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> 
> Move mt76x2u_set_txinfo routine in mt76x02-lib module and rename it in
> mt76x02_set_txinfo in order to be reused in mt76x0 driver
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.c | 21 ++++++++++++++++++++
>  drivers/net/wireless/mediatek/mt76/mt76x02_util.h |  1 +
>  drivers/net/wireless/mediatek/mt76/mt76x2u_core.c | 24 +----------------------
>  3 files changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> index e4cf4e934153..6ed558c12786 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
> @@ -412,4 +412,25 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
>  }
>  EXPORT_SYMBOL_GPL(mt76x02_tx_complete_skb);
>  
> +int mt76x02_set_txinfo(struct sk_buff *skb, struct mt76_wcid *wcid, u8 ep)
> +{
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	enum mt76_qsel qsel;
> +	u32 flags;
> +
> +	if ((info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) ||
> +	    ep == MT_EP_OUT_HCCA)
> +		qsel = MT_QSEL_MGMT;
> +	else
> +		qsel = MT_QSEL_EDCA;
> +
> +	flags = FIELD_PREP(MT_TXD_INFO_QSEL, qsel) |
> +		MT_TXD_INFO_80211;
> +	if (!wcid || wcid->hw_key_idx == 0xff || wcid->sw_iv)
> +		flags |= MT_TXD_INFO_WIV;
> +
> +	return mt76u_skb_dma_info(skb, WLAN_PORT, flags);
Common MT76x02 code must not call USB specific functions.

- Felix
