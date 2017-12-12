Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:35638 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752318AbdLLIrR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 03:47:17 -0500
Message-ID: <1513068419.26976.86.camel@sipsolutions.net> (sfid-20171212_094742_751264_B994A2B3)
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Date: Tue, 12 Dec 2017 09:46:59 +0100
In-Reply-To: <20171212125805.5f7813fd@canb.auug.org.au>
References: <20171212125805.5f7813fd@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephen,

Thanks!

Felix made me aware of this yesterday evening and said he's going to
work out the required changes to mt76.

Kalle and I will make sure to submit the trees to Dave one by one so he
doesn't have to deal with it :)

Unfortunately, this might take a few days to resolve.

> -void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
> +void mt76_wake_tx_queue(struct ieee80211_hw *hw)
>  {
> +	struct ieee80211_txq *txq;
>  	struct mt76_dev *dev = hw->priv;
> -	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
> -	struct mt76_queue *hwq = mtxq->hwq;
> +	struct mt76_txq *mtxq;
> +	struct mt76_queue *hwq;
>  
> +	txq = ieee80211_next_txq(hw);
> +	mtxq = (struct mt76_txq *) txq->drv_priv;
> +	hwq = mtxq->hwq;


Looks pretty much right to me - perhaps for safety there should be a
NULL check on txq, but OTOH when you get here it should be non-NULL.

Sorry for the inconvenience, I hadn't realized mt76 went in now.

johannes
