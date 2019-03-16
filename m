Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0557BC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 22:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42E8218D4
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 22:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbfCPW2f (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 18:28:35 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:46764 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726562AbfCPW2f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 18:28:35 -0400
Received: by mail-ed1-f67.google.com with SMTP id n17so10489805edt.13
        for <linux-wireless@vger.kernel.org>; Sat, 16 Mar 2019 15:28:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PDL3+ryKJrV75lJ/eEmutLMoFqM+r1U5tBQ9FMiSxTc=;
        b=bvJm658TwFeXo/ebk4yyRz2GY1bcOD6KM9GQI8O3+7H4zm9qGYDqR3KxQ6VAanzmWC
         q2micHwxxFE91uhGuXGl41SubPI+yho7kSrXGgMyat2Q6utlBCqElrtZGQVlcEGwJrKs
         Se4eZuDSjkG8lBrlvHio0WeyS6v23+QZE0efgQmD7bMnPj3jJdLGy8JYrtxEuP7iiYYe
         tz/N3ej5uyCu+MKRBM+6hVSt7R98eyggaPHdNDL7fic88JGRyKSCdlGOx/b/r2gpLTox
         JK92I9SKAE30AVC9cVYU0g4hbKG15JMF6XWSnlrgF3Ad5ppiwyf6zHn4JmJ5EiVXgyzu
         ErlA==
X-Gm-Message-State: APjAAAU5TMNcCxvaglEMjscAhrj+Ez44fJFGQY1Sio70/97gVRm9aGBJ
        1UgOcarifGPYpQKJhzkbbMq+lG0rmt9MoHeV
X-Google-Smtp-Source: APXvYqyXUct7N415S6Fzbn2hmwpbu/dsSc4cKH/ltZ0CJx4xX+63DfQS7Ymr1TxapJ4/oqsu3m0rHQ==
X-Received: by 2002:a17:906:cc9:: with SMTP id l9mr3190540ejh.53.1552775313034;
        Sat, 16 Mar 2019 15:28:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id bq6sm1315759ejb.16.2019.03.16.15.28.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Mar 2019 15:28:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 5ABCA1804A2; Sat, 16 Mar 2019 23:28:30 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/6] mt76: use mac80211 txq scheduling
In-Reply-To: <20190316204242.73560-1-nbd@nbd.name>
References: <20190316204242.73560-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 16 Mar 2019 23:28:30 +0100
Message-ID: <87muluv4hd.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Performance improvement and preparation for adding airtime fairness
> support

Great to see this! Do you have a plan for the airtime fairness part?
I.e., how to get the airtime information?

Only one other comment, below.

> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/wireless/mediatek/mt76/dma.c  |  6 +-
>  drivers/net/wireless/mediatek/mt76/mt76.h |  3 +-
>  drivers/net/wireless/mediatek/mt76/tx.c   | 98 ++++++++++-------------
>  drivers/net/wireless/mediatek/mt76/usb.c  |  3 +-
>  4 files changed, 50 insertions(+), 60 deletions(-)
>
> diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
> index 7b8a998103d7..09978757e7d1 100644
> --- a/drivers/net/wireless/mediatek/mt76/dma.c
> +++ b/drivers/net/wireless/mediatek/mt76/dma.c
> @@ -184,9 +184,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
>  			last = ioread32(&q->regs->dma_idx);
>  	}
>  
> -	if (!flush)
> -		mt76_txq_schedule(dev, sq);
> -	else
> +	if (flush)
>  		mt76_dma_sync_idx(dev, q);
>  
>  	wake = wake && q->stopped &&
> @@ -199,6 +197,8 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
>  
>  	spin_unlock_bh(&q->lock);
>  
> +	if (!flush)
> +		mt76_txq_schedule(dev, qid);
>  	if (wake)
>  		ieee80211_wake_queue(dev->hw, qid);
>  }
> diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
> index edff44f32c8e..5d44f721d184 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt76.h
> +++ b/drivers/net/wireless/mediatek/mt76/mt76.h
> @@ -224,7 +224,6 @@ struct mt76_wcid {
>  };
>  
>  struct mt76_txq {
> -	struct list_head list;
>  	struct mt76_sw_queue *swq;
>  	struct mt76_wcid *wcid;
>  
> @@ -683,7 +682,7 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
>  void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
>  void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
>  			 bool send_bar);
> -void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_sw_queue *sq);
> +void mt76_txq_schedule(struct mt76_dev *dev, enum mt76_txq_id qid);
>  void mt76_txq_schedule_all(struct mt76_dev *dev);
>  void mt76_release_buffered_frames(struct ieee80211_hw *hw,
>  				  struct ieee80211_sta *sta,
> diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
> index 2c82db0b5834..ef9a0bbd64c1 100644
> --- a/drivers/net/wireless/mediatek/mt76/tx.c
> +++ b/drivers/net/wireless/mediatek/mt76/tx.c
> @@ -479,23 +479,37 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_sw_queue *sq,
>  }
>  
>  static int
> -mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_sw_queue *sq)
> +mt76_txq_schedule_list(struct mt76_dev *dev, enum mt76_txq_id qid)
>  {
> +	struct mt76_sw_queue *sq = &dev->q_tx[qid];
>  	struct mt76_queue *hwq = sq->q;
> -	struct mt76_txq *mtxq, *mtxq_last;
> -	int len = 0;
> +	struct ieee80211_txq *txq;
> +	struct mt76_txq *mtxq;
> +	struct mt76_wcid *wcid;
> +	int ret = 0;
>  
> -restart:
> -	mtxq_last = list_last_entry(&sq->swq, struct mt76_txq, list);
> -	while (!list_empty(&sq->swq)) {
> +	spin_lock_bh(&hwq->lock);
> +	while (1) {
>  		bool empty = false;
> -		int cur;
> +
> +		if (sq->swq_queued >= 4)
> +			break;
>  
>  		if (test_bit(MT76_OFFCHANNEL, &dev->state) ||
> -		    test_bit(MT76_RESET, &dev->state))
> -			return -EBUSY;
> +		    test_bit(MT76_RESET, &dev->state)) {
> +			ret = -EBUSY;
> +			break;
> +		}
> +
> +		txq = ieee80211_next_txq(dev->hw, qid);
> +		if (!txq)
> +			break;
> +
> +		mtxq = (struct mt76_txq *)txq->drv_priv;
> +		wcid = mtxq->wcid;
> +		if (wcid && test_bit(MT_WCID_FLAG_PS, &wcid->flags))
> +			continue;
>  
> -		mtxq = list_first_entry(&sq->swq, struct mt76_txq, list);
>  		if (mtxq->send_bar && mtxq->aggr) {
>  			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
>  			struct ieee80211_sta *sta = txq->sta;
> @@ -507,38 +521,36 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_sw_queue *sq)
>  			spin_unlock_bh(&hwq->lock);
>  			ieee80211_send_bar(vif, sta->addr, tid, agg_ssn);
>  			spin_lock_bh(&hwq->lock);
> -			goto restart;
>  		}
>  
> -		list_del_init(&mtxq->list);
> -
> -		cur = mt76_txq_send_burst(dev, sq, mtxq, &empty);
> +		ret += mt76_txq_send_burst(dev, sq, mtxq, &empty);
>  		if (!empty)
> -			list_add_tail(&mtxq->list, &sq->swq);
> -
> -		if (cur < 0)
> -			return cur;
> -
> -		len += cur;
> -
> -		if (mtxq == mtxq_last)
> -			break;
> +			ieee80211_return_txq(dev->hw, txq);

The call to ieee80211_return_txq() is really meant to be unconditional.
The TXQ will only actually be scheduled if it still has packets queued.
I know it's slightly more expensive to have the check in mac80211, but
this is what makes it possible to change the implementation without
touching the drivers (such as in the RFC patch I sent earlier that
switches the scheduling algorithm)...

-Toke
